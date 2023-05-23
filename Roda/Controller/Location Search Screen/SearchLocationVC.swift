//
//  SearchLocationVC.swift
//  Taxiappz
//
//  Created by Apple on 10/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import NVActivityIndicatorView
import GoogleMaps
class SearchLocationVC: UIViewController {

    let searchLocationView = SearchLocationView()
    
    var searchLocationList: [SearchLocation] = []
   
    var selectedLocation:((SearchLocation) -> Void)?
    
    var selectedPickupLocation: SearchLocation?
    
    var titleText = "txt_choose_location".localize()
    private var isMapDragged: Bool? = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTarget()
        setupMap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func setupViews() {
        self.searchLocationView.setupViews(Base: self.view)
        searchLocationView.mapview.delegate = self
        
        self.searchLocationView.titleLbl.text = self.titleText
    }
    
    func setupTarget() {
        searchLocationView.tblLocation.delegate = self
        searchLocationView.tblLocation.dataSource = self
        searchLocationView.tblLocation.register(SearchListTableViewCell.self, forCellReuseIdentifier: "SearchListTableViewCell")
        
        searchLocationView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        searchLocationView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed(_ :)), for: .touchUpInside)
        searchLocationView.btnEditLocation.addTarget(self, action: #selector(btnEditLocationPressed(_ :)), for: .touchUpInside)
        searchLocationView.txtLocation.addTarget(self, action: #selector(searchPlace(_ :)), for: .editingChanged)
       
    }
    
    func setupMap() {
        guard let currentLoc = AppLocationManager.shared.locationManager.location else {
            return
        }
        self.selectedPickupLocation = SearchLocation(currentLoc.coordinate)
        self.getaddress(currentLoc.coordinate) {[weak self] address in
            self?.selectedPickupLocation?.placeId = address
            self?.searchLocationView.txtLocation.text = self?.selectedPickupLocation?.placeId
        }
        let camera = GMSCameraPosition.camera(withLatitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, zoom: 18)
        self.searchLocationView.mapview.camera = camera
    }
    
    @objc func btnConfirmPressed(_ sender: UIButton) {
        
        
        
        if let location = self.selectedPickupLocation {
            self.checkUserZone(userLocation: location) { inZone in
                if inZone {
                    self.selectedLocation?(location)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert("txt_info".localize(), message: "txt_service_unavailable_for_selectedLoc".localize())
                }
            }
            
        }
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnEditLocationPressed(_ sender: UIButton) {
        self.searchLocationView.txtLocation.text = ""
        self.searchLocationView.txtLocation.isUserInteractionEnabled = true
        self.searchLocationView.txtLocation.becomeFirstResponder()
    }

}

//MARK: - GOOGLE MAPS DELEGATE
extension SearchLocationVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.isMapDragged = gesture
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if (self.isMapDragged ?? false) {
            self.selectedPickupLocation = SearchLocation(position.target)
            self.getaddress(position.target) { address in
                self.selectedPickupLocation?.placeId = address
                self.searchLocationView.txtLocation.text = self.selectedPickupLocation?.placeId
                
            }
        }
    }
}

extension SearchLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell") as? SearchListTableViewCell ?? SearchListTableViewCell()
        
        cell.selectionStyle = .none
        
        cell.placenameLbl.text = searchLocationList[indexPath.row].nickName
        cell.placeaddLbl.text = searchLocationList[indexPath.row].placeId
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedPickupLocation = self.searchLocationList[indexPath.row]
        self.searchLocationView.tblLocation.isHidden = true
        if let googlePlaceId = searchLocationList[indexPath.row].googlePlaceId {
            
            self.getCoordinates(searchLocationList[indexPath.row].placeId ?? "", placeId: googlePlaceId) { (location) in
                self.selectedPickupLocation?.latitude = location.latitude
                self.selectedPickupLocation?.longitude = location.longitude
                self.searchLocationView.txtLocation.text = self.selectedPickupLocation?.placeId
                
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 18)
                self.searchLocationView.mapview.camera = camera
                if let location = self.selectedPickupLocation {
                    self.checkUserZone(userLocation: location) { inZone in
                        if inZone {
                            self.selectedLocation?(location)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.showAlert("txt_info".localize(), message: "txt_service_unavailable_for_selectedLoc".localize())
                        }
                    }
                    
                }
            }
            
        }
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func forceLogout() {
        if let root = self.navigationController?.revealViewController().navigationController {
            
            let firstvc = Initialvc()
            root.setViewControllers([firstvc], animated: false)
            
        }
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
        
    }
}

extension SearchLocationVC {
    @objc func searchPlace(_ sender: UITextField) {
        if let searchText = sender.text {
            
            if searchText.isEmpty {
                self.searchLocationList = []
                self.searchLocationView.tblLocation.reloadData()
                self.searchLocationView.tblLocation.isHidden = true
                return
            }
            
                    if ConnectionCheck.isConnectedToNetwork() {
                        
                        var paramDict = [String: Any]()
                        paramDict["input"] = searchText
                        paramDict["key"] = APIHelper.shared.gmsPlacesKey
                        if let location = AppLocationManager.shared.locationManager.location?.coordinate {
                            paramDict["location"] = "\(location.latitude),\(location.longitude)"
                            
                        }
                        paramDict["radius"] = "500"
                        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                            paramDict["components"] = "country:" + countryCode
                        }
                        
                        print(paramDict)
                        
                        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/place/autocomplete/json", queryItem: [])
                        print(url)
                        Alamofire.request(url, method: .get, parameters: paramDict, headers: APIHelper.shared.header)
                            .responseJSON { response in
                                if let result = response.result.value as? [String:AnyObject] {
                                    if let status = result["status"] as? String, status == "OK" {
                                        if let predictions = result["predictions"] as? [[String:AnyObject]] {
                                            print(predictions)
                                            self.searchLocationList = predictions.compactMap({
                                                if let googlePlaceId = $0["place_id"] as? String,
                                                   let address = $0["description"] as? String,
                                                   let structuredFormat = $0["structured_formatting"] as? [String:AnyObject],
                                                   let title = structuredFormat["main_text"] as? String {
                                                    return SearchLocation(googlePlaceId,title:title,address: address)
                                                }
                                                return nil
                                            })
                                            DispatchQueue.main.async {
                                                self.searchLocationView.tblLocation.reloadData()
                                                self.searchLocationView.tblLocation.isHidden = false
                                                self.searchLocationView.tblHeightConstraint?.constant = self.searchLocationView.tblLocation.contentSize.height
                                                self.view.setNeedsLayout()
                                                self.view.layoutIfNeeded()
                                                
                                            }
                                        }
                                    } else {
                                        
                                        self.searchLocationList = []
                                        self.searchLocationView.tblLocation.reloadData()
                                        self.searchLocationView.tblLocation.isHidden = true
                                
                                    }
                                }
                                
                            }
                    }
                
        }
        
    }
    
    
    func checkUserZone(userLocation: SearchLocation,completion:@escaping (Bool)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
            

            var paramDict = Dictionary<String,Any>()
        
            
            paramDict["pickup_lat"] = userLocation.latitude
            paramDict["pickup_long"] = userLocation.longitude
           
            
            let url = APIHelper.shared.BASEURL + APIHelper.checkUserZone
            print("check user zone",url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    print("user zone response",response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            
                            if let inZone = data["zone"] as? Bool {
                               completion(inZone)
                            }
                            
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}
