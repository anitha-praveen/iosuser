//
//  FavoritesAddedVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 30/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import GooglePlaces
import GoogleMaps

class FavoritesAddedVC: UIViewController , UITextFieldDelegate {
    
    let backBtn = UIButton()
    let titleLbl = UILabel()
    
    let bgView = UIView()
    
    let contentView = UIView()
    let homeBtn = UIButton()
    let workBtn = UIButton()
    let otherBtn = UIButton()
    let stackview = UIStackView()
    let viewName = UIView()
    let placeNamelbl = UILabel()
    let placeNameTfd = UITextField()
    let viewAddress = UIView()
    let placeAddrsLbl = UILabel()
    let placeAddrsTfd = UITextField()
    let pickOnMap = UIButton()
    
    let savePlaceBtn = UIButton()
    
    var selectedFavLocation:FavouriteLocation?
    
    var layoutDict = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondaryColor
        self.navigationController?.navigationBar.isHidden = true
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.selectedFavLocation?.place = self.placeAddrsTfd.text
    }
    func setupViews() {
        
        [backBtn, titleLbl, bgView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        [homeBtn, workBtn, otherBtn].forEach {
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
            $0.setTitleColor(UIColor(red: 0.673, green: 0.693, blue: 0.754, alpha: 1), for: .normal)
            $0.titleLabel?.font = UIFont.appRegularFont(ofSize: 15)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            $0.imageView?.contentMode = .scaleAspectFill
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .secondaryColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        backBtn.setAppImage("BackImage")
        backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        backBtn.contentMode = .scaleAspectFit
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        
        titleLbl.text = "txt_save_fav_title".localize()
        titleLbl.font = .appSemiBold(ofSize: 20)
        titleLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        titleLbl.textAlignment = .center
        layoutDict["titleLbl"] = titleLbl
        
        bgView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        layoutDict["bgView"] = bgView
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
        contentView.backgroundColor = .secondaryColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["contentView"] = contentView
        bgView.addSubview(contentView)
        
        homeBtn.setTitle("txt_Home".localize(), for: .normal)
        let imageHome = UIImage(named: "ic_home")
        homeBtn.setImage(imageHome?.withRenderingMode(.alwaysTemplate), for: .normal)
        homeBtn.imageView?.tintColor = UIColor(red: 0.774, green: 0.81, blue: 0.88, alpha: 1)
        homeBtn.addTarget(self, action: #selector(homeBtnAction(_ :)), for: .touchUpInside)
        layoutDict["homeBtn"] = homeBtn
        
        workBtn.setTitle("txt_Work".localize(), for: .normal)
        let imageWork = UIImage(named: "ic_work")
        workBtn.setImage(imageWork?.withRenderingMode(.alwaysTemplate), for: .normal)
        workBtn.imageView?.tintColor = UIColor(red: 0.774, green: 0.81, blue: 0.88, alpha: 1)
        workBtn.addTarget(self, action: #selector(workBtnAction(_ :)), for: .touchUpInside)
        layoutDict["workBtn"] = workBtn
        
        otherBtn.setTitle("txt_Other".localize(), for: .normal)
        let imageOther = UIImage(named: "ic_search_address")
        otherBtn.setImage(imageOther?.withRenderingMode(.alwaysTemplate), for: .normal)
        otherBtn.imageView?.tintColor = UIColor(red: 0.774, green: 0.81, blue: 0.88, alpha: 1)
        otherBtn.addTarget(self, action: #selector(otherBtnAction(_ :)), for: .touchUpInside)
        layoutDict["otherBtn"] = otherBtn
        
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 5
        layoutDict["stackview"] = stackview
        stackview.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackview)
        
        layoutDict["viewName"] = viewName
        viewName.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(viewName)
        
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(viewAddress)
        
        viewName.addSubview(placeNamelbl)
        viewName.addSubview(placeNameTfd)
        viewAddress.addSubview(placeAddrsLbl)
        viewAddress.addSubview(placeAddrsTfd)
        
        [placeNamelbl,placeAddrsLbl].forEach {
            $0.textAlignment = APIHelper.appTextAlignment
            $0.backgroundColor = .secondaryColor
            $0.font = .appSemiBold(ofSize: 13)
            $0.textColor = UIColor(red: 0.537, green: 0.573, blue: 0.639, alpha: 1)
            $0.translatesAutoresizingMaskIntoConstraints = false
            //contentView.addSubview($0)
        }
        [placeNameTfd,placeAddrsTfd].forEach {
            $0.leftViewMode = .always
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.font = UIFont.appRegularFont(ofSize: 16)
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
            $0.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
            $0.translatesAutoresizingMaskIntoConstraints = false
           // contentView.addSubview($0)
        }
        placeNamelbl.text = "txt_place_name".localize().uppercased()
        layoutDict["placeNamelbl"] = placeNamelbl
        placeNameTfd.placeholder = "txt_place_name_enter".localize()
        layoutDict["placeNameTfd"] = placeNameTfd
        placeAddrsLbl.text = "txt_place_addr".localize().uppercased()
        layoutDict["placeAddrsLbl"] = placeAddrsLbl
        placeAddrsTfd.delegate = self
        placeAddrsTfd.placeholder = "txt_place_addr_enter".localize()
        layoutDict["placeAddrsTfd"] = placeAddrsTfd
        
        
        pickOnMap.setTitle("txt_map_pick".localize().uppercased(), for: .normal)
        pickOnMap.setImage(UIImage(named: "ic_pick_map"), for: .normal)
        pickOnMap.addTarget(self, action: #selector(pickMapBtnAction(_ :)), for: .touchUpInside)
        pickOnMap.titleLabel?.font = UIFont.appSemiBold(ofSize: 14)
        pickOnMap.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        pickOnMap.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        pickOnMap.imageView?.contentMode = .scaleAspectFill
        pickOnMap.layer.cornerRadius = 5
        pickOnMap.backgroundColor = .themeColor
        layoutDict["pickOnMap"] = pickOnMap
        pickOnMap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pickOnMap)
        
        savePlaceBtn.setTitle("txt_Save_place".localize().uppercased(), for: .normal)
        savePlaceBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        savePlaceBtn.setTitleColor(.secondaryColor, for: .normal)
        savePlaceBtn.backgroundColor = .themeColor
        savePlaceBtn.addTarget(self, action: #selector(favouritepSaveBtnAction(_ :)), for: .touchUpInside)
        savePlaceBtn.layer.cornerRadius = 5
        savePlaceBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["savePlaceBtn"] = savePlaceBtn
        bgView.addSubview(savePlaceBtn)
        

        backBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 10).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-15-[bgView]", options: [], metrics: nil, views: layoutDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[backBtn(30)]-[titleLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 0).isActive = true
        titleLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bgView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[contentView]", options: [], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[savePlaceBtn(48)]-5-|", options: [], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[savePlaceBtn]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[homeBtn(35)]-25-[stackview]-15-[pickOnMap(40)]-30-|", options: [], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stackview]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(13)-[homeBtn]-(10)-[workBtn(==homeBtn)]-(10)-[otherBtn(==homeBtn)]-(13)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[pickOnMap]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickOnMap.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -20).isActive = true
        
        
        viewName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[placeNamelbl]-10-[placeNameTfd(50)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[placeNameTfd]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[placeAddrsLbl]-10-[placeAddrsTfd(50)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[placeAddrsTfd]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.homeSelected()

    }
    @objc func backBtnAction(_ sender: UIButton) {
        self.selectedFavLocation = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == placeAddrsTfd {
            let vc = SearchLocationVC()
          
            vc.selectedLocation = { [weak self] selectedSearchLoc in
                self?.placeAddrsTfd.text = selectedSearchLoc.placeId
                if selectedSearchLoc.locationType == .googleSearch {
                    
                    if let googlePlaceId = selectedSearchLoc.googlePlaceId {
                       
                        self?.getCoordinates(selectedSearchLoc.placeId ?? "", placeId: googlePlaceId, completion: { (location) in
                            self?.selectedFavLocation?.place = selectedSearchLoc.placeId
                            self?.selectedFavLocation?.latitude = "\(location.latitude)"
                            self?.selectedFavLocation?.longitude = "\(location.longitude)"
                        })
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
    
    @objc func homeBtnAction(_ sender: UIButton) {

        self.homeSelected()
    }
    
    func homeSelected() {
        homeBtn.layer.borderColor = UIColor.txtColor.cgColor
        homeBtn.setTitleColor(UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1), for: .normal)
        homeBtn.imageView?.tintColor = .txtColor
        [workBtn, otherBtn].forEach {
            $0.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
            $0.setTitleColor(UIColor(red: 0.673, green: 0.693, blue: 0.754, alpha: 1), for: .normal)
            $0.imageView?.tintColor = UIColor(red: 0.774, green: 0.81, blue: 0.88, alpha: 1)
        }
        viewName.isHidden = true
        self.selectedFavLocation?.type = .home
    }
    @objc func workBtnAction(_ sender: UIButton) {
        workBtn.layer.borderColor = UIColor.txtColor.cgColor
        workBtn.setTitleColor(UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1), for: .normal)
        workBtn.imageView?.tintColor = .txtColor
        [homeBtn, otherBtn].forEach {
            $0.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
            $0.setTitleColor(UIColor(red: 0.673, green: 0.693, blue: 0.754, alpha: 1), for: .normal)
            $0.imageView?.tintColor = UIColor(red: 0.774, green: 0.81, blue: 0.88, alpha: 1)
        }
        viewName.isHidden = true
        self.selectedFavLocation?.type = .work
    }
    
    @objc func otherBtnAction(_ sender: UIButton) {
        
        otherBtn.layer.borderColor = UIColor.txtColor.cgColor
        otherBtn.setTitleColor(UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1), for: .normal)
        otherBtn.imageView?.tintColor = .txtColor
        [homeBtn, workBtn].forEach {
            $0.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
            $0.setTitleColor(UIColor(red: 0.673, green: 0.693, blue: 0.754, alpha: 1), for: .normal)
            $0.imageView?.tintColor = UIColor(red: 0.774, green: 0.81, blue: 0.88, alpha: 1)
        }
        viewName.isHidden = false
        self.selectedFavLocation?.type = .other
    }
    
    @objc func pickMapBtnAction(_ sender: UIButton) {
        let vc = FavPickMapVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @objc func favouritepSaveBtnAction(_ sender: UIButton) {
        switch self.selectedFavLocation?.type {
        case .home:
            self.selectedFavLocation?.title = "txt_Home".localize()
        case .work:
            self.selectedFavLocation?.title = "txt_Work".localize()
        case .other:
            self.selectedFavLocation?.title = self.placeNameTfd.text//"txt_Other".localize()
        case .none:
            break
        }
        if self.selectedFavLocation?.type == .other {
            if self.placeAddrsTfd.text == "" {
                self.view.showToast("txt_place_addr_enter".localize())
            } else if self.placeNameTfd.text == "" {
                self.view.showToast("txt_enter_place".localize())
            } else {
                self.savefavouriteapicall()
            }
        } else {
            if self.placeAddrsTfd.text == "" {
                self.view.showToast("txt_place_addr_enter".localize())
            } else {
                self.savefavouriteapicall()
            }
        }
       
    }
    func savefavouriteapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String, Any>()

            paramDict["title"] = self.selectedFavLocation?.title
            paramDict["address"] = self.placeAddrsTfd.text!
            paramDict["latitude"] = self.selectedFavLocation?.latitude
            paramDict["longitude"] = self.selectedFavLocation?.longitude
           

            let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    self.placeNameTfd.text = ""
                                    self.placeAddrsTfd.text = ""
                                    self.selectedFavLocation = nil
                                    
                                    self.navigationController?.view.showToast("txt_Fav_Add".localize())
                                    self.navigationController?.popViewController(animated: true)
                                }
                            } else {
                                if let errcodestr = result["error_code"] as? String, errcodestr == "606" || errcodestr == "609" || errcodestr == "603" {
                                    self.forceLogout()
                                } else {
                                    self.view.showToast("text_someting_went_wrong".localize())
                                }
                            }
                        }
                    }
            }
        }
    }
    @objc func forceLogout() {
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
}
extension FavoritesAddedVC: selectedLocationDelegate {
    func selectAddress(address: String?) {
        self.selectedFavLocation?.place = address
        self.placeAddrsTfd.text = address
    }
    func selectedLat(lat: String?) {
        self.selectedFavLocation?.latitude = lat
    }
    func selectedLong(long: String?) {
        self.selectedFavLocation?.longitude = long
    }
}
