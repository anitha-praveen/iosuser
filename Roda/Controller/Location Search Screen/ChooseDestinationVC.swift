//
//  ChooseDestinationVC.swift
//  Taxiappz
//
//  Created by Apple on 09/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import GoogleMaps
import GooglePlaces
import CoreLocation

class ChooseDestinationVC: UIViewController {

    let destinationView = ChooseDestinationView()
    
    var selectedDropLocation: SearchLocation?
    var selectedPickupLocation: SearchLocation?
    var selectedStopLocation: SearchLocation?
    
    private var searchLocationList: [SearchLocation] = []
    private var favouriteLocationList = [SearchLocation]()
    private var lastTripLocationList = [SearchLocation]()
    
    private var isMapGragged = false
    
    private var selectedTag = 101
    
    var selectedContact: ContactPerson?
    var selectedContactType: ContactType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedContactType = .myself
        self.selectedContact = ContactPerson(self.selectedContactType?.title ?? "", phone: APIHelper.shared.userDetails?.phone ?? "")
        self.destinationView.lblMyself.text = self.selectedContact?.name
        
        setupViews()
        setupData()
        setupMap()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getFavouriteListApi()
        self.selectAllContent()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    @objc func selectAllContent() {
        self.destinationView.dropTxt.selectAll(nil)
    }
    
    func setupViews() {
        destinationView.mapview.delegate = self
        destinationView.tblview.delegate = self
        destinationView.tblview.dataSource = self
        destinationView.tblview.register(SearchListTableViewCell.self, forCellReuseIdentifier: "SearchListTableViewCell")
        destinationView.tblview.register(RecentLocationsCell.self, forCellReuseIdentifier: "RecentLocationsCell")
        destinationView.tblview.register(FavouriteLocationsCell.self, forCellReuseIdentifier: "FavouriteLocationsCell")
        destinationView.setupViews(Base: self.view)
        destinationView.dropTxt.delegate = self
        destinationView.stopTxt.delegate = self
        
        destinationView.btnConfirmLocation.addTarget(self, action: #selector(btnConfirmLocationPressed(_ :)), for: .touchUpInside)
        destinationView.btnCurrentLocation.addTarget(self, action: #selector(currentLocation), for: .touchUpInside)
        destinationView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        
        destinationView.btnAddStop.addTarget(self, action: #selector(btnAddStopPressed(_ :)), for: .touchUpInside)
        destinationView.btnRemoveDrop.addTarget(self, action: #selector(btnSwapLocationPressed(_ :)), for: .touchUpInside)
        
        destinationView.btnRemoveStop.addTarget(self, action: #selector(btnRemoveLocationPressed(_ :)), for: .touchUpInside)
        
        destinationView.dropTxt.addTarget(self, action: #selector(searchPlace(_ :)), for: .editingChanged)
        destinationView.stopTxt.addTarget(self, action: #selector(searchPlace(_ :)), for: .editingChanged)
        
        destinationView.viewMyself.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(bookForOthersPressed(_ :))))
    }

    func setupData() {
        
        self.destinationView.viewStop.isHidden = true
        self.destinationView.btnRemoveDrop.isHidden = true
        
        self.destinationView.pickupTxt.text = self.selectedPickupLocation?.placeId
        self.destinationView.dropTxt.text = self.selectedDropLocation?.placeId
        self.destinationView.stopTxt.text = ""
    }
    
    func setupMap() {
        if let dropLocation = self.selectedPickupLocation {
            if let lat = dropLocation.latitude, let long = dropLocation.longitude {
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let camera = GMSCameraPosition.camera(withTarget: coord, zoom: 15)
                self.destinationView.mapview.camera = camera
            }
        }
    }
    
    @objc func btnAddStopPressed(_ sender: UIButton) {
        
        self.destinationView.viewStop.isHidden = false
        self.destinationView.btnRemoveDrop.isHidden = false
        self.destinationView.btnAddStop.isHidden = true
        
        self.destinationView.stopTxt.becomeFirstResponder()
        self.selectedTag = self.destinationView.stopTxt.tag
    }
    
    @objc func btnRemoveLocationPressed(_ sender: UIButton) {
        if sender == destinationView.btnRemoveDrop {
            self.destinationView.viewStop.isHidden = true
            self.selectedDropLocation = self.selectedStopLocation
            self.selectedStopLocation = nil
            self.destinationView.dropTxt.text = self.selectedDropLocation?.placeId
            
            self.destinationView.btnRemoveDrop.isHidden = true
            self.destinationView.btnAddStop.isHidden = false
        } else if sender == destinationView.btnRemoveStop {
            self.destinationView.viewStop.isHidden = true
            self.selectedStopLocation = nil
            self.destinationView.stopTxt.text = ""
            
            self.destinationView.btnRemoveDrop.isHidden = true
            self.destinationView.btnAddStop.isHidden = false
        }
        self.destinationView.tblview.isHidden = true
        self.selectedTag = self.destinationView.dropTxt.tag
    }
    
    @objc func btnSwapLocationPressed(_ sender: UIButton) {
        if sender == destinationView.btnRemoveDrop {
            if self.selectedStopLocation != nil {
                
                let dropLocation = self.selectedDropLocation
                
                self.selectedDropLocation = self.selectedStopLocation
                self.selectedStopLocation = dropLocation
                
                self.destinationView.dropTxt.text = self.selectedDropLocation?.placeId
                self.destinationView.stopTxt.text = self.selectedStopLocation?.placeId
              
            }
        }
        self.view.endEditing(true)
    }

    @objc func currentLocation() {

        
        guard let currentLoc = AppLocationManager.shared.locationManager.location else {
            return
        }
        if self.selectedTag == self.destinationView.dropTxt.tag {
            self.selectedDropLocation = SearchLocation(currentLoc.coordinate)
            self.getaddress(currentLoc.coordinate) { address in
                self.selectedDropLocation?.placeId = address
                self.destinationView.dropTxt.text = address
                
            }
        } else if selectedTag == self.destinationView.stopTxt.tag {
            self.selectedStopLocation = SearchLocation(currentLoc.coordinate)
            self.getaddress(currentLoc.coordinate) { address in
                self.selectedStopLocation?.placeId = address
                self.destinationView.stopTxt.text = address
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, zoom: 15)
        self.destinationView.mapview.camera = camera
        
        
        return
    }
    
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnConfirmLocationPressed(_ sender: UIButton) {
        if self.selectedDropLocation == nil {
            self.showAlert("", message: "txt_EnterDrop".localize())
        } else {
            
            self.checkZone(userLocation: self.selectedDropLocation!) { inOutStationZone in
                if !inOutStationZone {
                    let vc = BookingVC()
                    vc.navigationItem.hidesBackButton = true
                    vc.selectedPickUpLocation = self.selectedPickupLocation
                    if self.selectedStopLocation != nil {
                        let tempLoc = self.selectedDropLocation
                        vc.selectedDropLocation = self.selectedStopLocation
                        vc.selectedStopLocation = tempLoc
                        if let stopLocation = self.selectedDropLocation {
                            vc.selectedStopLocationParam = [StopLocationParam(pickupAddress: stopLocation.placeId ?? "", pickupLat: stopLocation.latitude ?? 0, pickupLng: stopLocation.longitude ?? 0)]
                        }
                        
                    } else {
                        vc.selectedDropLocation = self.selectedDropLocation
                    }
                    vc.selectedContact = self.selectedContact
                    vc.selectedContactType = self.selectedContactType
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.goToOutstation()
                }
            }
            
        }
    }
    
    func goToOutstation() {
        let alert = UIAlertController(title: "txt_info".localize(), message: "txt_redirect_outstation_hint".localize(), preferredStyle: .actionSheet)
        let btnOk = UIAlertAction(title: "text_ok".localize(), style: .default) { action in
            let vc = OutStationListVC()
            vc.selectedLocation = self.selectedPickupLocation
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let btnCancel = UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil)
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func bookForOthersPressed(_ sender: UITapGestureRecognizer) {
        let vc = BookForOthersVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedContact = self.selectedContact
        vc.selectedContactType = self.selectedContactType
        vc.callBack = {[weak self] contact,type in
            self?.selectedContact = contact
            self?.selectedContactType = type
            self?.destinationView.lblMyself.text = contact.name
        }
        self.present(vc, animated: true, completion:nil)
    }
    
}

//MARK: - MAPVIEW DELEGATE
extension ChooseDestinationVC:GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.isMapGragged = gesture
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if self.isMapGragged {
            if self.selectedTag == self.destinationView.dropTxt.tag {
                self.selectedDropLocation = SearchLocation(position.target)
                self.getaddress(position.target) { address in
                    self.selectedDropLocation?.placeId = address
                    DispatchQueue.main.async {
                        self.destinationView.dropTxt.text = address
                    }
                }
            } else if self.selectedTag == self.destinationView.stopTxt.tag {
                self.selectedStopLocation = SearchLocation(position.target)
                self.getaddress(position.target) { address in
                    self.selectedStopLocation?.placeId = address
                    DispatchQueue.main.async {
                        self.destinationView.stopTxt.text = address
                    }
                }
            }
            
        }
               
    }

}

//MARK: - TABLE DELEGATES
extension ChooseDestinationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.searchLocationList.count
        } else if section == 1 {
            return self.lastTripLocationList.count
        } else if section == 2 {
            return self.favouriteLocationList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell") as? SearchListTableViewCell ?? SearchListTableViewCell()
            cell.placenameLbl.text = searchLocationList[indexPath.row].nickName
            cell.placeaddLbl.text = searchLocationList[indexPath.row].placeId
           
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLocationsCell") as? RecentLocationsCell ?? RecentLocationsCell()
            
            cell.placeaddLbl.text = lastTripLocationList[indexPath.row].placeId
            cell.placeImv.image = UIImage(named: "ic_recent_location")
            cell.favBtn.isHidden = false
            cell.favAction = {[weak self] in
                
                if let location = self?.lastTripLocationList[indexPath.row] {
                    let vc = FavouriteLocationVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.selectedLocation = location
                    self?.present(vc, animated: true, completion: nil)
                }
                    
            }
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteLocationsCell") as? FavouriteLocationsCell ?? FavouriteLocationsCell()
            cell.placenameLbl.text = favouriteLocationList[indexPath.row].nickName
            cell.placeaddLbl.text = favouriteLocationList[indexPath.row].placeId
            if let imageset = self.favouriteLocationList[indexPath.row].nickName {
                if imageset == "Home" {
                    cell.placeImv.image = UIImage(named: "favHome")
                } else if imageset == "Work"{
                    cell.placeImv.image = UIImage(named: "favWork")
                } else {
                    cell.placeImv.image = UIImage(named: "favorOthers")
                }
            }
           
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            var selectedLocation: SearchLocation?
            selectedLocation = searchLocationList[indexPath.row]
            if let googlePlaceId = selectedLocation?.googlePlaceId {
                
                self.getCoordinates(selectedLocation?.placeId ?? "", placeId: googlePlaceId) { (location) in
                    selectedLocation?.latitude = location.latitude
                    selectedLocation?.longitude = location.longitude
                    if let location = selectedLocation {
                         self.setData(location)
                    }
                    let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
                    self.destinationView.mapview.camera = camera
                }
            }
            
        } else if indexPath.section == 1 {
            let location = self.lastTripLocationList[indexPath.row]
            self.setData(self.lastTripLocationList[indexPath.row])
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude ?? 0, longitude: location.longitude ?? 0, zoom: 15)
            self.destinationView.mapview.camera = camera
        } else if indexPath.section == 2 {
            let location = self.favouriteLocationList[indexPath.row]
            self.setData(self.favouriteLocationList[indexPath.row])
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude ?? 0, longitude: location.longitude ?? 0, zoom: 15)
            self.destinationView.mapview.camera = camera
        }
        self.searchLocationList = []
        self.destinationView.tblview.isHidden = true
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lblRecentLocation = UILabel()
        lblRecentLocation.font = UIFont.appBoldFont(ofSize: 16)
        lblRecentLocation.textColor = .txtColor
        lblRecentLocation.textAlignment = APIHelper.appTextAlignment
        if section == 1 {
            lblRecentLocation.text = "  " + "txt_recent".localize()
            return lblRecentLocation
        } else if section == 2 {
            lblRecentLocation.text = "  " + "txt_Fav_side_menu".localize()
            return lblRecentLocation
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if self.lastTripLocationList.count > 0 {
                return 30
            }
        } else if section == 2 {
            if self.favouriteLocationList.count > 0 {
                return 30
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setData(_ location: SearchLocation) {
        if self.selectedTag == self.destinationView.dropTxt.tag {
            self.selectedDropLocation = location
            self.destinationView.dropTxt.text = location.placeId
        } else if self.selectedTag == self.destinationView.stopTxt.tag {
            self.selectedStopLocation = location
            self.destinationView.stopTxt.text = location.placeId
        }
    }
}

//MARK: - Location Search
extension ChooseDestinationVC {
    
    @objc func searchPlace(_ sender: UITextField) {
        
        self.selectedTag = sender.tag
        guard let searchText = sender.text else {
            return
        }
        if searchText.isEmpty {
            self.searchLocationList = []
            self.destinationView.tblview.reloadData()
            self.destinationView.tblview.isHidden = true
            return
        } else {
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
                                            self.destinationView.tblview.reloadData()
                                            self.destinationView.tblview.isHidden = false
                                            self.destinationView.tblHeight?.constant = self.destinationView.tblview.contentSize.height
                                            self.view.setNeedsLayout()
                                            self.view.layoutIfNeeded()
                                            
                                        }
                                    }
                                } else if let status = result["status"] as? String {
                                    
                                    self.searchLocationList = []
                                    self.destinationView.tblview.reloadData()
                                    self.destinationView.tblview.isHidden = true
                                    print(status)
                                }
                            }
                            
                        }
                }
            
        }
    }
    
    
    func getFavouriteListApi() {

        if ConnectionCheck.isConnectedToNetwork() {
           
            let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let favPlaces = data["FavouriteList"] as? [[String:AnyObject]] {
                                        self.favouriteLocationList = favPlaces.compactMap({ SearchLocation($0) })
                                       
                                    }
                                    if let lastTrips = data["Last_trip_history"] as? [[String: AnyObject]] {
                                        if self.selectedPickupLocation == nil {
                                            self.lastTripLocationList = lastTrips.compactMap({
                                                if let lat = $0["pick_lat"] as? Double, let long = $0["pick_lng"] as? Double, let address = $0["pick_address"] as? String {
                                                    return SearchLocation(lat, longitude: long, address: address)
                                                }
                                                return nil
                                            })
                                        } else {
                                            self.lastTripLocationList = lastTrips.compactMap({
                                                if let lat = $0["drop_lat"] as? Double, let long = $0["drop_lng"] as? Double, let address = $0["drop_address"] as? String {
                                                    return SearchLocation(lat, longitude: long, address: address)
                                                }
                                                return nil
                                            })
                                        }
                                        
                                        if self.lastTripLocationList.count > 0 || self.favouriteLocationList.count > 0 {
                                            DispatchQueue.main.async {
                                                self.destinationView.tblview.reloadData()
                                                self.destinationView.tblview.isHidden = false
                                                self.destinationView.tblHeight?.constant = self.destinationView.tblview.contentSize.height
                                                self.view.setNeedsLayout()
                                                self.view.layoutIfNeeded()
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    
    func checkZone(userLocation: SearchLocation,completion:@escaping (Bool)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            var paramDict = Dictionary<String,Any>()
        
           
            paramDict["pickup_lat"] = userLocation.latitude
            paramDict["pickup_long"] = userLocation.longitude
           
            
            let url = APIHelper.shared.BASEURL + APIHelper.checkOutstationZone
            print("check user zone",url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    print("user zone response",response.result.value as Any)
                    if response.response?.statusCode == 200 {
                        if let result = response.result.value as? [String: AnyObject] {
                            if let data = result["data"] as? [String: AnyObject] {
                                
                                if let inZone = data["outstation"] as? Bool {
                                   completion(inZone)
                                }
                                
                            }
                        }
                    } else {
                        completion(false)
                    }
                    
                case .failure(_):
                    completion(false)
                }
            }
        }
    }
}

//MARK: - TEXTFIELD DELEGATES
extension ChooseDestinationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.destinationView.dropTxt || textField == self.destinationView.stopTxt {
            self.selectedTag = textField.tag
        }
        return true
    }
}
