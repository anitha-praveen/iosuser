//
//  TaxiPickupVC.swift
//  Taxiappz
//
//  Created by Apple on 09/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Kingfisher
import SWRevealViewController
import Alamofire
import NVActivityIndicatorView
import MarqueeLabel
import MaterialShowcase
class TaxiPickupVC: UIViewController {

    private let pickupView = TaxiPickupView()
    
    var currentLayoutDirection = APIHelper.appLanguageDirection//TO REDRAW VIEWS IF DIRECTION IS CHANGED

    var selectedPickupLocation: SearchLocation?
    
    var driverPins:[String: GMSMarker]?
    var driverDatas = [String: [String: Any]]()

    let sideMenuHideBtn = UIButton(type: .custom)
    
    private var isMapDragged: Bool? = false
    private var isPickupChanged:Bool? = false
    
    var sequence = MaterialShowcaseSequence()
    
    private var rideCategories = [RideCategory]()
    private var selectedRideCategory: RideCategory?
    
    private var rentalPackageLists = [RentalPackageList]()
    private var selectedPackageList: RentalPackageList?
    
    private var lastTripLocationList = [SearchLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.rideCategories = RideCategory.allCases
        self.selectedRideCategory = .daily
        
        setupViews()
        AppLocationManager.shared.delegate = self
        self.currentLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(resetTripDetails), name: Notification.Name(rawValue: "Trip Completed"), object: nil)
        
        
        self.getFavouriteListApi()
        getKeyPair()
        changeHexToSecKey()
        secKeyGeneratorr()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !APIHelper.shared.isTourGuideShown {
            showTour()
        }
        
    }
    
    @objc func resetTripDetails() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
 
        self.currentLocation()
    }
    
    func setupViews() {
        pickupView.setupViews(Base: self.view, controller: self)
        pickupView.mapview.delegate = self
        
        pickupView.tblRecentLocation.delegate = self
        pickupView.tblRecentLocation.dataSource = self
        pickupView.tblRecentLocation.register(RecentLocationsCell.self, forCellReuseIdentifier: "RecentLocationsCell")
        
        pickupView.collectionvw.delegate = self
        pickupView.collectionvw.dataSource = self
        pickupView.collectionvw.register(RideCategoryCollectionCell.self, forCellWithReuseIdentifier: "RideCategoryCollectionCell")
        
        pickupView.packageCollectionvw.delegate = self
        pickupView.packageCollectionvw.dataSource = self
        pickupView.packageCollectionvw.register(PackageListCell.self, forCellWithReuseIdentifier: "PackageListCell")
        
        pickupView.btnNotification.addTarget(self, action: #selector(btnNotificationPressed(_ :)), for: .touchUpInside)
        pickupView.btnCurrentLocation.addTarget(self, action: #selector(currentLocation), for: .touchUpInside)
        pickupView.viewSearchDestination.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseDestination(_ :))))
        pickupView.pickMarkerView.btnFav.addTarget(self, action: #selector(gotoFavourite(_ :)), for: .touchUpInside)
        pickupView.btnFav.addTarget(self, action: #selector(gotoFavourite(_ :)), for: .touchUpInside)
        pickupView.pickMarkerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choosePickup(_:))))
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        var layoutDic = [String: AnyObject]()
        sideMenuHideBtn.isHidden = true
        sideMenuHideBtn.addTarget(self, action: #selector(sideMenuHideBtnAction(_:)), for: .touchUpInside)
        sideMenuHideBtn.backgroundColor = UIColor.secondaryColor.withAlphaComponent(0.7)
        sideMenuHideBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sideMenuHideBtn"] = sideMenuHideBtn
        self.navigationController?.view.addSubview(sideMenuHideBtn)
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[sideMenuHideBtn]|", options: [], metrics: nil, views: layoutDic))
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[sideMenuHideBtn]|", options: [], metrics: nil, views: layoutDic))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       // changeAuthorization()
        AppLocationManager.shared.locationManager.allowsBackgroundLocationUpdates = false
        FirebaseObserver.shared.firebaseDelegate = self
        
        sideMenuHideBtn.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        if currentLayoutDirection != APIHelper.appLanguageDirection {
           
            pickupView.setupViews(Base: self.view, controller: self)
            currentLayoutDirection = APIHelper.appLanguageDirection
            
             pickupView.btnMenu.removeTarget(nil, action: nil, for: .allEvents)
            if APIHelper.appLanguageDirection == .directionLeftToRight {
                pickupView.btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            } else {
                pickupView.btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
            }
        }
      
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(forceLogout), name: .anotherUserLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkrequestinprogress), name: .tripStateChanged, object: nil)
        
        checkrequestinprogress()
        MarqueeLabel.controllerViewWillAppear(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       
        NotificationCenter.default.removeObserver(self, name: .anotherUserLogin, object: nil)
        NotificationCenter.default.removeObserver(self, name: .tripStateChanged, object: nil)

        FirebaseObserver.shared.firebaseDelegate = nil
        self.driverPins = nil
    }
   
    @objc func sideMenuHideBtnAction(_ sender: UIButton) {
        sideMenuHideBtn.isHidden = true
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            self.revealViewController()?.revealToggle(animated: true)
        } else {
            self.revealViewController()?.rightRevealToggle(animated: true)
        }
    }
   
    @objc func currentLocation() {

        guard let currentLoc = AppLocationManager.shared.locationManager.location else {
            return
        }
        
        self.checkUserZone { (inZone) in
            if !inZone {
                self.pickupView.blurView.isHidden = false
            } else {
                self.pickupView.blurView.isHidden = true
            }
        }
        self.selectedPickupLocation = SearchLocation(currentLoc.coordinate)
        self.getaddress(currentLoc.coordinate) {[weak self] address in
            self?.selectedPickupLocation?.placeId = address
            self?.pickupView.pickMarkerView.lblPickupAddress.text = self?.selectedPickupLocation?.placeId
        }

        self.pickupView.mapview.clear()
        FirebaseObserver.shared.removeObservers()
        self.driverDatas = [:]
        self.driverPins = [:]
        FirebaseObserver.shared.selectedPickupLocation = self.selectedPickupLocation
        if let searchRadius = FirebaseObserver.shared.searchRadius {
            FirebaseObserver.shared.addDriverObservers(radius: searchRadius)
        } else {
            FirebaseObserver.shared.addDriverObservers(radius: 3.0)
        }
        
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, zoom: 18)
        self.pickupView.mapview.camera = camera
        
        return
    }
    

    @objc func chooseDestination(_ sender: UITapGestureRecognizer) {
        
        self.checkLocationAccess { isEnabled in
            if isEnabled {
                if self.selectedPickupLocation == nil {
                    self.view.showToast("txt_select_pickup_point".localize())
                } else {
                    self.view.endEditing(true)
                    let vc = ChooseDestinationVC()
                    vc.selectedPickupLocation = self.selectedPickupLocation
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let enableLocationVC = EnableLocationScreen()
                enableLocationVC.modalPresentationStyle = .overCurrentContext
                self.present(enableLocationVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func choosePickup(_ sender: UIButton) {
        let vc = SearchLocationVC()
        vc.titleText = "txt_choose_pickup".localize()
        vc.selectedLocation = { [weak self] selectedSearchLoc in
            self?.pickupView.pickMarkerView.lblPickupAddress.text = selectedSearchLoc.placeId
            self?.selectedPickupLocation = selectedSearchLoc
            
            self?.isPickupChanged = true
            if let lat = selectedSearchLoc.latitude, let long = selectedSearchLoc.longitude {
                self?.pickupView.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
                self?.pickupView.mapview.animate(toZoom: 18)
            }
            
            self?.pickupView.mapview.clear()
            FirebaseObserver.shared.removeObservers()
            self?.driverDatas = [:]
            self?.driverPins = [:]
            FirebaseObserver.shared.selectedPickupLocation = self?.selectedPickupLocation
            if let searchRadius = FirebaseObserver.shared.searchRadius {
                FirebaseObserver.shared.addDriverObservers(radius: searchRadius)
            } else {
                FirebaseObserver.shared.addDriverObservers(radius: 3.0)
            }
            
            self?.checkUserZone(userLocation: self?.selectedPickupLocation) { inZone in
                if !inZone {
                    self?.pickupView.blurView.isHidden = false
                } else {
                    self?.pickupView.blurView.isHidden = true
                }
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func gotoFavourite(_ sender: UIButton) {
        if self.selectedPickupLocation != nil {
            let vc = FavouriteLocationVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.selectedLocation = self.selectedPickupLocation
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func btnNotificationPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(NotificationVC(), animated: true)
//        self.navigationController?.pushViewController(PaymentOptionVC(), animated: true)
    }
}

//MARK: -TABLE LOCATION DELEGATES
extension TaxiPickupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lastTripLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLocationsCell") as? RecentLocationsCell ?? RecentLocationsCell()
        
        cell.placeaddLbl.text = lastTripLocationList[indexPath.row].placeId
        cell.placeImv.image = UIImage(named: "ic_recent_location")
        cell.favBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedPickupLocation == nil {
            self.view.showToast("txt_select_pickup_point".localize())
        } else {
            self.checkZone(userLocation: self.lastTripLocationList[indexPath.row]) { inOutstationZone in
                if !inOutstationZone {
                    let vc = BookingVC()
                    vc.selectedPickUpLocation = self.selectedPickupLocation
                    vc.selectedDropLocation = self.lastTripLocationList[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.goToOutstation()
                }
            }
            
        }
        
    }
    
    func goToOutstation() {
        let alert = UIAlertController(title: "txt_info".localize(), message: "txt_outstation_alert".localize(), preferredStyle: .actionSheet)
        let btnOk = UIAlertAction(title: "text_ok".localize().uppercased(), style: .default) { action in
            let vc = OutStationListVC()
            vc.selectedLocation = self.selectedPickupLocation
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let btnCancel = UIAlertAction(title: "text_cancel".localize().uppercased(), style: .cancel, handler: nil)
        alert.addAction(btnOk)
        alert.addAction(btnCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - RIDE CATEGORY COLLECTION DELEGATES
extension TaxiPickupVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.pickupView.collectionvw {
            return self.rideCategories.count
        } else if collectionView == self.pickupView.packageCollectionvw {
            return self.rentalPackageLists.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.pickupView.collectionvw {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RideCategoryCollectionCell", for: indexPath) as? RideCategoryCollectionCell ?? RideCategoryCollectionCell()
            
            cell.lblTypeName.text = self.rideCategories[indexPath.row].name
            
            if self.selectedRideCategory == self.rideCategories[indexPath.row] {
                
                cell.imgview.image = self.rideCategories[indexPath.row].selectedImage
                cell.lblTypeName.font = UIFont.appBoldFont(ofSize: 16)
                cell.backgroundImg.isHidden = false
            } else {
                
                cell.imgview.image = self.rideCategories[indexPath.row].image
                cell.lblTypeName.font = UIFont.appRegularFont(ofSize: 14)
                cell.backgroundImg.isHidden = true
            }
            
            return cell
        } else if collectionView == self.pickupView.packageCollectionvw {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageListCell", for: indexPath) as? PackageListCell ?? PackageListCell()
            cell.lblHour.text = self.rentalPackageLists[indexPath.item].hours
            cell.lblDistance.text = self.rentalPackageLists[indexPath.item].distance
            
            if self.selectedPackageList?.slug == self.rentalPackageLists[indexPath.item].slug {
                cell.viewContent.backgroundColor = .themeColor
            } else {
                cell.viewContent.backgroundColor = .hexToColor("F4F4F4")
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.pickupView.collectionvw {
            return CGSize(width: (UIScreen.main.bounds.width-25)/3, height: 90)
        } else if collectionView == self.pickupView.packageCollectionvw {
            return CGSize(width: 60, height: 50)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.checkLocationAccess { isEnabled in
            if isEnabled {
                if collectionView == self.pickupView.collectionvw {
                    self.selectedRideCategory = self.rideCategories[indexPath.row]
                    self.pickupView.collectionvw.reloadData()
                    
                    if self.selectedRideCategory == .daily {
                        self.pickupView.viewSearchDestination.isHidden = false
                        self.pickupView.tblRecentLocation.isHidden = false
                        self.pickupView.viewPackageList.isHidden = true
                    } else if self.selectedRideCategory == .outStation {
                        self.pickupView.viewPackageList.isHidden = true
                        let vc = OutStationListVC()
                        vc.selectedLocation = self.selectedPickupLocation
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else if self.selectedRideCategory == .rental {
                        self.getPackageList()
                    }
                } else if collectionView == self.pickupView.packageCollectionvw {
                    
                    self.selectedPackageList = self.rentalPackageLists[indexPath.item]
                    self.pickupView.packageCollectionvw.reloadData()
                    let vc = RentalVC()
                    vc.selectedLocation = self.selectedPickupLocation
                    vc.rentalPackageLists = self.rentalPackageLists
                    vc.selectedPackageList = self.selectedPackageList
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } else {
                let enableLocationVC = EnableLocationScreen()
                enableLocationVC.modalPresentationStyle = .overCurrentContext
                self.present(enableLocationVC, animated: true, completion: nil)
            }
        }
        
    }
    
}

//MARK: - GOOGLE MAPS DELEGATE
extension TaxiPickupVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.isMapDragged = gesture
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if (self.isMapDragged ?? false) && !(self.isPickupChanged ?? false) {
            self.selectedPickupLocation = SearchLocation(position.target)
            self.getaddress(position.target) { address in
                self.selectedPickupLocation?.placeId = address
                self.pickupView.pickMarkerView.lblPickupAddress.text = self.selectedPickupLocation?.placeId
                
                self.pickupView.mapview.clear()
                FirebaseObserver.shared.removeObservers()
                self.driverDatas = [:]
                self.driverPins = [:]
                FirebaseObserver.shared.selectedPickupLocation = self.selectedPickupLocation
                if let searchRadius = FirebaseObserver.shared.searchRadius {
                    FirebaseObserver.shared.addDriverObservers(radius: searchRadius)
                } else {
                    FirebaseObserver.shared.addDriverObservers(radius: 3.0)
                }
                
            }
        } else {
            self.isPickupChanged = false
        }
        
    }
}

// MARK:- response received from firebase observers
extension TaxiPickupVC: MyFirebaseDelegate {
    
    func driverEnteredFence(_ key: String, location: CLLocation, response: [String: Any]) {
      
        if let isActive = response["is_active"] as? Bool, let isAvailable = response["is_available"] as? Bool {
            if isActive && isAvailable {
                if let updatedAt = response["updated_at"] as? Int64 {
                    let currentTime = Date().millisecondsSince1970
                    let diff = (currentTime - updatedAt) / 1000
                  
                    if diff < (5 * 60) {
                        let driverPin = GMSMarker(position: location.coordinate)
                        if let vehicleType = response["type"] as? String, vehicleType == "bajaj-auto" {
                            driverPin.icon = UIImage(named: "ic_pin_auto")
                        } else {
                            driverPin.icon = UIImage(named: "pin_driver")
                        }
                        //driverPin.icon = img
                        driverPin.rotation = location.course
                        driverPin.isFlat = true
                        driverPin.map =  self.pickupView.mapview
                        self.driverPins?[key] = driverPin
                        self.driverDatas[key] = response
                        
                        FirebaseObserver.shared.addObserverFor(key)
                       
                    } else {
                        print("Last updated \(diff / 60) mins ago")
                    }
                }
            }
        }
    }
    
    func driverExitedFence(_ key: String, location: CLLocation, response: [String : Any]) {
        if let driverPin = self.driverPins?[key] {
            driverPin.map = nil
            self.driverPins?.removeValue(forKey: key)
            self.driverDatas.removeValue(forKey: key)
            
            FirebaseObserver.shared.removeObserverFor(key)
        }
    }
    
    func driverMovesInFence(_ key: String, location: CLLocation, response: [String : Any]) {
        if let isActive = response["is_active"] as? Bool, let isAvailable = response["is_available"] as? Bool {
            if isActive && isAvailable {
                if let driverPin = self.driverPins?[key] {
                    if let previousUpdate = response["updated_at"] as? Int64 {
                        let currentTime = Date().millisecondsSince1970
                        let diff = (currentTime - previousUpdate) / 1000
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(CFTimeInterval(diff))
                        driverPin.position = location.coordinate
                        driverPin.rotation = location.course
                        CATransaction.commit()
                        
                        self.driverPins?[key] = driverPin
                        self.driverDatas[key] = response
                        
                    }
                } else {
                    if let updatedAt = response["updated_at"] as? Int64 {
                        let currentTime = Date().millisecondsSince1970
                        let diff = (currentTime - updatedAt) / 1000
                      
                        if diff < (5 * 60 * 1000) {
                            let driverPin = GMSMarker.init(position: location.coordinate)
                            if let vehicleType = response["type"] as? String, vehicleType == "bajaj-auto" {
                                driverPin.icon = UIImage(named: "ic_pin_auto")
                            } else {
                                driverPin.icon = UIImage(named: "pin_driver")
                            }
                            driverPin.rotation = location.course
                            driverPin.isFlat = true
                            driverPin.map =  self.pickupView.mapview
                            self.driverPins?[key] = driverPin
                            self.driverDatas[key] = response
                            
                            FirebaseObserver.shared.addObserverFor(key)
                        }
                    }
                }
            } else {
                if let driverPin = self.driverPins?[key] {
                    driverPin.map = nil
                    self.driverPins?.removeValue(forKey: key)
                    self.driverDatas.removeValue(forKey: key)
                    
                    FirebaseObserver.shared.removeObserverFor(key)
                }
            }
        }
    }
    
    func driverWentOffline(_ key: String) {
        if let driverPin = self.driverPins?[key] {
            driverPin.map = nil
            self.driverPins?.removeValue(forKey: key)
            self.driverDatas.removeValue(forKey: key)
            
        }
    }
    
    func driverDataUpdated(_ key: String, response: [String : Any]) {
        if let isActive = response["is_active"] as? Bool,let isAvailable = response["is_available"] as? Bool {
            if !isActive || !isAvailable {
                if let driverPin = self.driverPins?[key] {
                    driverPin.map = nil
                    self.driverPins?.removeValue(forKey: key)
                    self.driverDatas.removeValue(forKey: key)
                    
                }
            } else {
                
                if !(self.driverPins?.keys.contains(key) ?? true) {
                    if let driverLocation = response["l"] as? [Double] {
                        let driverLat = driverLocation[0]
                        let driverLng = driverLocation[1]
                        let coord = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLng)
                        let driverPin = GMSMarker(position: coord)
                        if let vehicleType = response["type"] as? String, vehicleType == "bajaj-auto" {
                            driverPin.icon = UIImage(named: "ic_pin_auto")
                        } else {
                            driverPin.icon = UIImage(named: "pin_driver")
                        }
                        if let bearing = response["bearing"] as? Double {
                            driverPin.rotation = bearing
                        }
                        driverPin.isFlat = true
                        driverPin.map =  self.pickupView.mapview
                        self.driverPins?[key] = driverPin
                        self.driverDatas[key] = response
                    }
                  
                }

            }
            
        }
        
    }
    
}


//MARK:- LOCATION MANAGER DELEGATE
extension TaxiPickupVC: AppLocationManagerDelegate {
    func appLocationManager(didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }

        if self.selectedPickupLocation == nil {
            AppLocationManager.shared.stopTracking()
            self.selectedPickupLocation = SearchLocation(location.coordinate)
            self.getaddress(location.coordinate) { address in
                self.selectedPickupLocation?.placeId = address
                DispatchQueue.main.async {
                    self.pickupView.pickMarkerView.lblPickupAddress.text = self.selectedPickupLocation?.placeId
                    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18)
                    self.pickupView.mapview.camera = camera
                   
                }
            }
        }
    }
    
    func applocationManager(didChangeAuthorization status: CLAuthorizationStatus) {
        
        changeAuthorization()
    }
    func changeAuthorization() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            
            case .authorizedAlways, .authorizedWhenInUse:
                
                break
            case .restricted, .denied, .notDetermined:
                let enableLocationVC = EnableLocationScreen()
                enableLocationVC.modalPresentationStyle = .overCurrentContext
                self.present(enableLocationVC, animated: true, completion: nil)
                break
            @unknown default:
                break
            }
        } else {
            let enableLocationVC = EnableLocationScreen()
            enableLocationVC.modalPresentationStyle = .overCurrentContext
            self.present(enableLocationVC, animated: true, completion: nil)
        }
    }
    func checkLocationAccess(completion:@escaping(Bool)->Void) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            
            case .authorizedAlways, .authorizedWhenInUse:
                completion(true)
                break
            case .restricted, .denied, .notDetermined:
                completion(false)
                break
            @unknown default:
                completion(true)
            }
        } else {
            completion(false)
        }
    }
}

//MARK: - API'S
extension TaxiPickupVC {
    @objc func checkrequestinprogress() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            let url = APIHelper.shared.BASEURL + APIHelper.checkRequestinProgress
            print(url,APIHelper.shared.authHeader)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    print("Request in progress response",response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let user = data["user"] as? [String: AnyObject] {
                                    
                                    if let searchRadius = user["search_radius"] {
                                        
                                        FirebaseObserver.shared.searchRadius = Double("\(searchRadius)")
                                       
                                        self.pickupView.mapview.clear()
                                        FirebaseObserver.shared.removeObservers()
                                        self.driverDatas = [:]
                                        self.driverPins = [:]
                                       
                                        if let searchRadius = FirebaseObserver.shared.searchRadius {
                                            FirebaseObserver.shared.addDriverObservers(radius: searchRadius)
                                        } else {
                                            FirebaseObserver.shared.addDriverObservers(radius: 3.0)
                                        }
                                    }
                                }
                                if let trips = data["trips"] as? [String: AnyObject] {
                                    if let tripData = trips["data"] as? [String: AnyObject] {
                                        
                                        self.updateScreen(tripData)
                                    }
                                } else {
                                    APIHelper.pathToPickup = ""
                                }
                            }
                            
                        } else {
                            if response.response?.statusCode == 401 {
                                self.forceLogout()
                            } else if response.response?.statusCode == 400 {
                              print("BAD REQUEST")
                            } else if response.response?.statusCode == 403 {
                                let vc = UserBlockedVC()
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        
                    }
                }
        }
    }
    
    func updateScreen(_ tripDetails: [String: AnyObject]) {
        
        if let isCompleted = tripDetails["is_completed"] as? Bool, isCompleted {
            
            let vc = InvoiceVC()
            vc.navigationItem.hidesBackButton = true
            vc.tripinvoicedetdict = tripDetails
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let isDriverStarted = tripDetails["is_driver_started"] as? Bool, isDriverStarted {
            
            let vc = TripVC()
            vc.navigationItem.hidesBackButton = true
            vc.tripstatusfromripdict = tripDetails
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if let isDriverStarted = tripDetails["is_driver_started"] as? Bool, !isDriverStarted {
            if let isLater = tripDetails["is_later"] as? Bool, !isLater {
                if let reqId = tripDetails["id"] as? String{
//                    let vc = NoDriversFoundVC()
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.reqID = reqId
//                    self.present(vc, animated: true, completion: nil)
                }
                
            }

        }
        
    }
    
    func checkUserZone(userLocation: SearchLocation? = nil,completion:@escaping (Bool)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            guard let location = AppLocationManager.shared.locationManager.location else {
                return
            }
            var paramDict = Dictionary<String,Any>()
        
            if userLocation != nil {
                paramDict["pickup_lat"] = userLocation?.latitude
                paramDict["pickup_long"] = userLocation?.longitude
            } else {
                paramDict["pickup_lat"] = location.coordinate.latitude
                paramDict["pickup_long"] = location.coordinate.longitude
            }
            
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
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            
                            if let inZone = data["outstation"] as? Bool {
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
    
    func getPackageList() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            
            let url = APIHelper.shared.BASEURL + APIHelper.getPackageList
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON{ (response) in
                NKActivityLoader.sharedInstance.hide()
                switch response.result {
                case .success(_):
                    print("RentalPackage List",response.result.value as Any)
                    if response.response?.statusCode == 200 {
                        if let result = response.result.value as? [String: AnyObject] {
                            if let data = result["data"] as? [[String: AnyObject]] {
                                self.rentalPackageLists = data.compactMap({RentalPackageList($0)})
                                
                                if !self.rentalPackageLists.isEmpty {
                                    self.pickupView.packageCollectionvw.reloadData()
                                    self.pickupView.viewPackageList.isHidden = false
                                    self.pickupView.viewSearchDestination.isHidden = true
                                    self.pickupView.tblRecentLocation.isHidden = true
                                } else {
                                    self.view.showToast("txt_no_vehicle_for_rent".localize())
                                }
                                
                            }
                        }
                    } else {
                        self.view.showToast("txt_no_vehicle_for_rent".localize())
                    }
                case .failure(_):
                    self.view.showToast("txt_no_vehicle_for_rent".localize())
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
                                    if let lastTrips = data["Last_trip_history"] as? [[String: AnyObject]] {
                                        
                                        self.lastTripLocationList = lastTrips.compactMap({
                                            if let lat = $0["drop_lat"] as? Double, let long = $0["drop_lng"] as? Double, let address = $0["drop_address"] as? String {
                                                return SearchLocation(lat, longitude: long, address: address)
                                            }
                                            return nil
                                        })
                                        
                                        if self.lastTripLocationList.count > 0 {
                                            DispatchQueue.main.async {
                                                self.pickupView.tblRecentLocation.reloadData()
                                                self.pickupView.tblRecentLocation.isHidden = false
                                                self.pickupView.recentTableHeightConstraint?.constant = self.pickupView.tblRecentLocation.contentSize.height
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
    
    @objc func forceLogout() {
        if let root = self.navigationController?.revealViewController().navigationController {
            let firstvc = Initialvc()
                root.view.showToast("text_already_login".localize())
                root.setViewControllers([firstvc], animated: false)
        }
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
}

//MARK:- TOUR GUIDE
extension TaxiPickupVC:MaterialShowcaseDelegate {
    
    func showTour() {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: pickupView.pickMarkerView)
        showcase.backgroundViewType = .circle
        showcase.targetTintColor = UIColor.clear
        showcase.targetHolderColor = UIColor.clear
        showcase.skipButton = nil
        showcase.primaryText = "txt_pickupLoc".localize()
        showcase.secondaryText = "txt_change_pickup_click_here".localize()
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            showcase.primaryTextAlignment = .left
            showcase.secondaryTextAlignment = .left
        } else {
            showcase.primaryTextAlignment = .right
            showcase.secondaryTextAlignment = .right
        }
        showcase.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase.backgroundPromptColor = UIColor.themeColor
        showcase.isTapRecognizerForTargetView = true
        showcase.backgroundRadius = 300
        showcase.targetHolderRadius = 80
        
        let showcase1 = MaterialShowcase()
        showcase1.setTargetView(view: pickupView.viewSearchDestination)
        showcase1.skipButton = nil
        showcase1.primaryText = "txt_dropLoc".localize()
        showcase1.secondaryText = "txt_choose_drop_click_here".localize()
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            showcase1.primaryTextAlignment = .left
            showcase1.secondaryTextAlignment = .left
        } else {
            showcase1.primaryTextAlignment = .right
            showcase1.secondaryTextAlignment = .right
        }
        showcase1.shouldSetTintColor = false
        showcase1.backgroundPromptColor = UIColor.themeColor
        showcase1.isTapRecognizerForTargetView = false
        showcase1.targetHolderRadius = 100
        
        
        let showcase2 = MaterialShowcase()
        showcase2.setTargetView(button: pickupView.btnMenu, tapThrough: true)
        showcase2.skipButton = nil
        showcase2.primaryText = ""
        showcase2.secondaryText = ""
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            showcase2.primaryTextAlignment = .left
            showcase2.secondaryTextAlignment = .left
        } else {
            showcase2.primaryTextAlignment = .right
            showcase2.secondaryTextAlignment = .right
        }
        showcase2.shouldSetTintColor = false
        showcase2.backgroundPromptColor = UIColor.themeColor
        showcase2.isTapRecognizerForTargetView = false
        showcase2.backgroundRadius = 400
        
        showcase.delegate = self
        showcase1.delegate = self
//        showcase2.delegate = self
        
        let oneTimeKey = UUID().uuidString
        sequence.temp(showcase).temp(showcase1).setKey(key: oneTimeKey).start()
    }
    
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
        APIHelper.shared.isTourGuideShown = true
    }
}


// MARK: ECDH
extension TaxiPickupVC {

    func getKeyPair() {

        var error: Unmanaged<CFError>?
        let keyPairAttr:[String : Any] = [kSecAttrKeySizeInBits as String: 256,
                                          SecKeyKeyExchangeParameter.requestedSize.rawValue as String: 32,
                                          kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                          kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                          kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: false],
                                          kSecPublicKeyAttrs as String:[kSecAttrIsPermanent as String: false]]
        let algorithm:SecKeyAlgorithm = SecKeyAlgorithm.ecdhKeyExchangeStandardX963SHA256 //ecdhKeyExchangeStandardX963SHA256

        do {
            guard let privateKey = SecKeyCreateRandomKey(keyPairAttr as CFDictionary, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            let publicKey = SecKeyCopyPublicKey(privateKey)

            print("public ky1: \(String(describing: publicKey)),\n private key: \(privateKey)")


    
            guard let privateKey2 = SecKeyCreateRandomKey(keyPairAttr as CFDictionary, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            let publicKey2 = SecKeyCopyPublicKey(privateKey2)
            print("public ky2: \(String(describing: publicKey2)),\n private key2: \(privateKey2)")

            
            let shared:CFData? = SecKeyCopyKeyExchangeResult(privateKey, algorithm, publicKey2!, keyPairAttr as CFDictionary, &error)
            let sharedData:Data = shared! as Data

            print("shared Secret key",sharedData.base64EncodedString())

            let shared2:CFData? = SecKeyCopyKeyExchangeResult(privateKey2, algorithm, publicKey!, keyPairAttr as CFDictionary, &error)
            let sharedData2:Data = shared2! as Data
            print("shared Secret key 2",sharedData2.base64EncodedString())

            // shared secret key and shared secret key 2 should be same

            if sharedData.base64EncodedString() == sharedData2.base64EncodedString() {
                let secretKey = sharedData.base64EncodedString()
                print("SEC KEY MATCHES",secretKey)

                let stringToEncrpt = "HelloThere"
                let encrptrd = stringToEncrpt.aesEncrypt(key: secretKey, iv: "qwertyuiopasdfgh")
                print("ENCRPTED VALUE",encrptrd)
            }


        } catch let error as NSError {
            print("error: \(error)")
        } catch  {
            print("unknown error")
        }
    }
    
    func isHexString(_ string: String) -> Bool {
        let hexRegex = "^[0-9a-fA-F]+$"
        let range = string.range(of: hexRegex, options: .regularExpression)
        return range != nil
    }
    
    func changeHexToSecKey() {
        
        let hexkey = "037e7bd0c625dcbf0e67c1133bfca26c332f6e8ac553cc3a12530a58702d04cddc"
        

        let b64Key = "A3570MYl3L8OZ8ETO/yibDMvborFU8w6ElMKWHAtBM3c"
        
//        let keyBase64 = "MIIBCgKCAQEA0bipoOhkkvPxcsyOzcqsIUeVe0+iwe8W7N4EbHZMgujRERu1TPpyUcCO0uuKmm1TU09Kl40rRvDbtgB1YcGV3FPnNp3sOyFVsdyZ5bzxZtyyLrSWtj/nbLnGwaG9xJSwd2R/pTQLzOLV5KldwD2eUb3Z4Z4e9Z8II7eWgGaCLLqbrtEAa05NEqARckxrzJ1S3j+59h4AQovF72KI90/kRPryT2OGDiVlJ6CTjn2ZnTYcx65X6RwfAeJKHZAGhw96j9tXyS+dJcXy4IBUTi3PXw0aEfhHQr/JsSHuMp/8mrhVJEokXb1CgKDZgJXujpGhCBdztHBAJxLBQMlODg7srwIDAQAB"
        
    
        if let keyData = Data(base64Encoded: b64Key) {
            let key = SecKeyCreateWithData(keyData as NSData, [
                kSecAttrKeyType: kSecAttrKeyType,
                kSecAttrKeyClass: kSecAttrKeyClassPublic,
            ] as NSDictionary, nil)
            
            print("PUB KEY",key)
        }
        

//        guard let data = Data.init(base64Encoded: b64Key) else {
//           return
//        }
//
//        let attributes123 = [kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
//                        kSecAttrKeyClass: kSecAttrKeyClassPublic,
//                        kSecAttrKeySizeInBits: 256
//                        ] as [CFString : Any]

//        let keyDict:[NSObject:NSObject] = [
//           kSecAttrKeyType: kSecAttrKeyTypeRSA,
//           kSecAttrKeyClass: kSecAttrKeyClassPublic,
//           kSecAttrKeySizeInBits as String: 256,
//           kSecReturnPersistentRef: true as NSObject
//        ]

//         let publicKey = SecKeyCreateWithData(data as CFData, attributes123 as CFDictionary, nil)
        
        
        
    }
    
    
    func secKeyGeneratorr() {
    
        let hexString = "037e7bd0c625dcbf0e67c1133bfca26c332f6e8ac553cc3a12530a58702d04cddc"
        let data = hexString.data(using: .utf8)!
        let cfData = data as CFData
        
        
        let publicKeyAttributes: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: 256
        ]

        var error: Unmanaged<CFError>?
        guard let publicKey = SecKeyCreateWithData(cfData as CFData, publicKeyAttributes as CFDictionary, &error) else {
            print("ERRORR",error!.takeRetainedValue() as Error)
            return
        }
        print("PUBLICC KEYY",publicKey)
    }
    
}
