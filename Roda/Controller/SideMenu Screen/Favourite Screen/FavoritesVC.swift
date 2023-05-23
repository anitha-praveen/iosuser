//
//  FavoritesVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 29/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GooglePlaces
import NVActivityIndicatorView

class FavoritesVC: UIViewController {
    
    private let favouriteView = FavouriteView()
    
    var favouriteLocationList: [SearchLocation]? = []
    var selectedFavLocation:FavouriteLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondaryColor
        self.navigationController?.navigationBar.isHidden = true
        
        self.setupViews()
        self.setupTarget()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavouriteListApi()
    }
    
    func setupViews() {
        favouriteView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        favouriteView.favListTB.delegate = self
        favouriteView.favListTB.dataSource = self
        favouriteView.favListTB.register(FavCell.self, forCellReuseIdentifier: "FavCell")
        favouriteView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        favouriteView.addBtn.addTarget(self, action: #selector(addBtnAction(_ :)), for: .touchUpInside)
        
    }
}

extension FavoritesVC {
    
    @objc func backBtnAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBtnAction(_ sender: UIButton){
        
        let vc = FavoritesAddedVC()
        vc.selectedFavLocation?.latitude = selectedFavLocation?.latitude
        vc.selectedFavLocation?.longitude = selectedFavLocation?.longitude
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getFavouriteListApi() { // get user favourite location

        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            let paramDict = Dictionary<String, Any>()

            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
            print(url)
            print("Auth Token", APIHelper.shared.authHeader)
            Alamofire.request(url, method: .get, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let favPlaces = data["FavouriteList"] as? [[String:AnyObject]] {
                                        self.favouriteLocationList = favPlaces.map({ SearchLocation($0) })
                                        self.favouriteView.favListTB.reloadData()
                                    }
                                }
                            } else {
                                if let errcodestr = result["error_code"] as? String, errcodestr == "606" || errcodestr == "609" || errcodestr == "603" {
                                    self.forceLogout()
                                } else if let errorCode = result["error_code"] as? String , errorCode == "721"{
                                    self.view.showToast("txt_Fav_list_no_data".localize())
                                } else {
                                    self.view.showToast("text_someting_went_wrong".localize())
                                }
                            }
                        }
                    }
                    
            }
        }
    }
    
    func deleteFavourite(_ slug: String) { // delete user favourite location
        if ConnectionCheck.isConnectedToNetwork() {
            
            let paramDict = Dictionary<String, Any>()

            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.deleteFavourite + "/" + slug
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                self.getFavouriteListApi()
                            } else {
                                if let errcodestr = result["error_code"] as? String, errcodestr == "606" || errcodestr == "609" || errcodestr == "603" {
                                    self.forceLogout()
                                } else {
                                    self.view.showToast("txt_Fav_list_no_data".localize())
                                }
                            }
                        }

                    } else {
                        self.view.showToast("text_someting_went_wrong".localize())
                    }
            }
        }
    }
    
    @objc func forceLogout() {
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteLocationList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell") as? FavCell ?? FavCell()
        
        cell.selectionStyle = .none
        
        cell.textLbl.text = self.favouriteLocationList?[indexPath.row].nickName
        cell.addressLbl.text = self.favouriteLocationList?[indexPath.row].placeId
        cell.deleteBtn.tag = self.favouriteLocationList?[indexPath.row].id ?? 0
        cell.favDeleteBtnAction = {[weak self] in
            self?.deleteFavourite(self?.favouriteLocationList?[indexPath.row].slug ?? "")
        }
        if let imageset = self.favouriteLocationList?[indexPath.row].nickName {
            if imageset == "Home" {
                cell.imgView.image = UIImage(named: "favHome")?.withRenderingMode(.alwaysTemplate)
            } else if imageset == "Work"{
                cell.imgView.image = UIImage(named: "favWork")?.withRenderingMode(.alwaysTemplate)
            } else {
                cell.imgView.image = UIImage(named: "favorOthers")?.withRenderingMode(.alwaysTemplate)
            }
        
        }
       
        return cell
    }
}
