//
//  TripVC.swift
//  Taxiappz
//
//  Created by Apple on 03/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import Kingfisher
import NVActivityIndicatorView
import MessageUI
import SWRevealViewController

class TripVC: UIViewController {
    
    let tripView = TripTrackingView()
    
    var tripstatusfromripdict = [String:AnyObject]()
    
    var selectedPickUpLocation: SearchLocation?
    var selectedDropLocation: SearchLocation?
    
    var pickUpMarker: GMSMarker!
    var dropMarker: GMSMarker!
    
    var driverMarker = GMSMarker()
    var drivermarkerLong = Double()
    var drivermarkerLat = Double()
    var drivermarkerrBearing = Double()
    var routeDrawn: Bool = false
    var routeStartPoint = CLLocationCoordinate2D()
    
    
    var isDriverArrived: Bool = false
    var estimtedArrivalTime = ""
    
    var driverPhoneNumber = ""
    var requestid = ""
    
    private var tripLink = ""
    
    private var polyStringAfterPickupChanged = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.driverMarker.icon = UIImage(named: "pin_driver")
        self.driverMarker.appearAnimation = .none
        setupViews()
        setupMap()
        if !tripstatusfromripdict.isEmpty {
            self.updateScreenForTripStatus(tripstatusfromripdict, first: true)
            self.updateDriverDetails(tripstatusfromripdict)
        }
    }
    
    func setupViews() {
        tripView.setupViews(Base: self.view)
        tripView.btnPickupEdit.addTarget(self, action: #selector(btnPickupEditPressed(_ :)), for: .touchUpInside)
        tripView.btnDropEdit.addTarget(self, action: #selector(btnDropEditPressed(_ :)), for: .touchUpInside)
        tripView.cancelBookBtn.addTarget(self, action: #selector(cancelBooking(_ :)), for: .touchUpInside)
        tripView.callBtn.addTarget(self, action: #selector(callBtnAction(_:)), for: .touchUpInside)
        tripView.btnSos.addTarget(self, action: #selector(btnSosPressed(_:)), for: .touchUpInside)
        tripView.shareBtn.addTarget(self, action: #selector(shareBtnPressed(_:)), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AppLocationManager.shared.locationManager.allowsBackgroundLocationUpdates = true
        MySocketManager.shared.socketDelegate = self
        FirebaseObserver.shared.firebaseDelegate = self
        self.addNotificationObservers()
       
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            tripView.btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)),for: .touchUpInside)
        }
        else
        {
            tripView.btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)),for: .touchUpInside)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotificationObservers()
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkrequestinprogress), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkrequestinprogress), name: .tripStateChanged, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(methodOfCancelledReceivedNotification(notification:)), name: .tripCancelled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tripLocationChangedObserver(_ :)), name: .locationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkrequestinprogress), name: .localToRental, object: nil)
    }
    
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .tripStateChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .locationChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .tripCancelled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .localToRental, object: nil)
    }
    
    
    func setupMap() {
        if let lat = tripstatusfromripdict["pick_lat"] as? Double, let long = tripstatusfromripdict["pick_lng"] as? Double, let loc = tripstatusfromripdict["pick_address"] as? String {
            self.selectedPickUpLocation = SearchLocation(CLLocationCoordinate2D(latitude: lat, longitude: long))
            self.selectedPickUpLocation?.placeId = loc
            self.tripView.lblPickup.text = loc
            if let selectedPickUpLoc = self.selectedPickUpLocation?.coordinate {
                self.addMarkerAtCoordinate()
                self.tripView.mapview.camera = GMSCameraPosition.camera(withLatitude: selectedPickUpLoc.latitude, longitude: selectedPickUpLoc.longitude, zoom: 15)
            }
        }
        if let lat = tripstatusfromripdict["drop_lat"] as? Double, let long = tripstatusfromripdict["drop_lng"] as? Double, let loc = tripstatusfromripdict["drop_address"] as? String {
            self.selectedDropLocation = SearchLocation(CLLocationCoordinate2D(latitude: lat, longitude: long))
            self.selectedDropLocation?.placeId = loc
            self.tripView.lblDrop.text = loc
        }
        
        
    }
    
}

//MARK:- CURRENT TRIP STATUS
extension TripVC {
    func updateScreenForTripStatus(_ requestDetails:[String:AnyObject], first: Bool) {
        
        self.tripstatusfromripdict = requestDetails
        if first {
            if let requestid = requestDetails["id"] {
                FirebaseObserver.shared.addTripObserverFor("\(requestid)")
            }
        }
        
        if let vehicleSlug = requestDetails["vehicle_slug"] as? String, vehicleSlug == "bajaj-auto" {
            
            self.driverMarker.icon = UIImage(named: "ic_pin_auto")
        } else {
            self.driverMarker.icon = UIImage(named: "pin_driver")
        }
        
        if let tripLink = requestDetails["share_path"] as? String {
            self.tripLink = tripLink
        }
        
        if let requestNumber = requestDetails["request_number"] as? String {
            self.tripView.btnRequestNumber.setTitle(requestNumber, for: .normal)
        }
        
        if let needLocApprove = requestDetails["location_approve"] as? Bool, needLocApprove {
            self.tripView.transparentWaitingLocationView.isHidden = false
        } else {
            self.tripView.transparentWaitingLocationView.isHidden = true
        }
        
        if let pickupAddress = requestDetails["pick_address"] as? String {
            self.tripView.lblPickup.text = pickupAddress
        }
        if let dropAddress = requestDetails["drop_address"] as? String {
            self.tripView.lblDrop.text = dropAddress
        }
        
        
        if let stop = requestDetails["stops"] as? [String: AnyObject] {
            if let address = stop["address"] as? String {
                self.tripView.lblStop.text = address
            }
        } else {
            self.tripView.stopView.isHidden = true
        }
        
        if let paymentOption = requestDetails["payment_opt"] as? String {
            self.tripView.btnPaymentMode.setTitle(paymentOption, for: .normal)
        }
        if let otp = requestDetails["request_otp"] {
            self.tripView.lblOtp.text = "OTP".localize() + ": \(otp)"
        }
        if let requestid = requestDetails["id"] {
            self.requestid = "\(requestid)"
        }
     
        if let promoUsed = requestDetails["promo_used"] as? Bool, promoUsed {
            let stringOne = "text_promo_applied".localize()
            let stringTwo = "txt_applied".localize()
            let range = (stringOne as NSString).range(of: stringTwo)
            
            let attributedText = NSMutableAttributedString.init(string: stringOne)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hexToColor("027D61") , range: range)
            tripView.btnApplyPromo.titleLabel?.attributedText = attributedText
            tripView.btnApplyPromo.isUserInteractionEnabled = false
        } else {
            tripView.btnApplyPromo.setTitle("txt_coupon".localize(), for: .normal)
            tripView.btnApplyPromo.isUserInteractionEnabled = true
        }
       
        
        
        if let isCompleted = requestDetails["is_completed"] as? Bool, isCompleted == true {
            print("ola ola ola")
            self.tripstatusfromripdict = requestDetails
            
            let feedbackVC = InvoiceVC()
            
            feedbackVC.tripinvoicedetdict = self.tripstatusfromripdict
            if self.navigationController?.topViewController is TripVC {
                APIHelper.pathToPickup = ""
                MySocketManager.shared.socketDelegate = nil
                FirebaseObserver.shared.firebaseDelegate = nil
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }
        } else if let isTripStart = requestDetails["is_trip_start"] as? Bool, isTripStart == true {
            print("vala vala vala")
            APIHelper.pathToPickup = ""
            self.isDriverArrived = true
            routeDrawn = false
            self.tripView.viewArrivalEta.isHidden = true
            
            self.tripView.lblStatusTitle.text = "txt_enjoy_ride".localize()
            self.tripView.lblStatusHint.text = "txt_driver_started_destination".localize()
            
            self.tripView.pickupView.isHidden = true
            if let serviceCategory = requestDetails["service_category"] as? String {
                if serviceCategory == "RENTAL" {
                    self.tripView.dropView.isHidden = true
                } else {
                    self.tripView.dropView.isHidden = false
                    if serviceCategory == "OUTSTATION" {
                        self.tripView.btnDropEdit.isHidden = true
                    }
                }
                
                if serviceCategory == "RENTAL" || serviceCategory == "OUTSTATION" {
                   
                    if let meterImage = requestDetails["trip_start_km_image"] as? String, let tripKm = requestDetails["start_km"] as? String {
                        let vc = TripMeterVerificationVC()
                        vc.meterImage = meterImage
                        vc.tripStartKm = tripKm
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            } else {
                self.tripView.dropView.isHidden = false
            }
            
            if let stop = requestDetails["stops"] as? [String: AnyObject] {
                if let address = stop["address"] as? String {
                    self.tripView.lblStop.text = address
                    self.tripView.stopView.isHidden = false
                }
            } else {
                self.tripView.stopView.isHidden = true
            }
            
            self.tripView.otpView.backgroundColor = .hexToColor("48CB90")
            
            tripView.cancelBookBtn.isEnabled = false
            tripView.cancelBookBtn.backgroundColor = .hexToColor("D5BEBD")
            tripView.cancelBookBtn.isHidden = true
            
            if let pathToDestination = requestDetails["poly_string"] as? String {
                self.setPathToDestination(pathToDestination)
            }
            
            if self.tripLink != "" {
                self.tripView.shareBtn.isHidden = true
            }
            
        } else if let isTriparr = requestDetails["is_driver_arrived"] as? Bool, isTriparr == true {
            print("dola dola dola")
            APIHelper.pathToPickup = ""
            self.isDriverArrived = true
            self.tripView.viewArrivalEta.isHidden = false
            self.tripView.lblArrivalEta.text = "Arrived".localize()
            self.tripView.btnPickupEdit.isHidden = true
            routeDrawn = false
            self.tripView.lblStatusTitle.text = "txt_found_driver".localize()
            self.tripView.lblStatusHint.text = "txt_driver_arrived_pickup".localize()
            tripView.cancelBookBtn.isEnabled = true
            tripView.cancelBookBtn.backgroundColor = .themeColor
            
            self.tripView.pickupView.isHidden = false
            self.tripView.dropView.isHidden = true
            self.tripView.stopView.isHidden = true
            
            if let pathToDestination = requestDetails["poly_string"] as? String {
                self.setPathToDestination(pathToDestination)
            }
            
            if let isNytTimePhotoSkipped = requestDetails["skip_night_photo"] as? Bool,!isNytTimePhotoSkipped {
                if let isDriverPhotoUploaded = requestDetails["driver_upload_image"] as? Bool,isDriverPhotoUploaded {
                    if let isUserPhotoUploaded = requestDetails["user_upload_image"] as? Bool,!isUserPhotoUploaded {
                        let vc = NytTimePictureUploadVC()
                        vc.modalPresentationStyle = .overFullScreen
                        if let driverPhoto = requestDetails["night_photo_driver"] as? String {
                            vc.driverImage = driverPhoto
                        }
                        vc.requestID = self.requestid
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            
        } else if let isAccepted = requestDetails["is_driver_started"] as? Bool, isAccepted == true {
            print("la la la")
            self.isDriverArrived = false
            routeDrawn = false
            self.tripView.lblStatusTitle.text = "txt_found_driver".localize()
            self.tripView.lblStatusHint.text = "txt_driver_started_your_location".localize()
            tripView.cancelBookBtn.isEnabled = true
            tripView.cancelBookBtn.backgroundColor = .themeColor
            
            self.tripView.pickupView.isHidden = false
            self.tripView.dropView.isHidden = true
            self.tripView.stopView.isHidden = true
        }
        print("bla bla bla")
    }
    
    func updateDriverDetails(_ requestDetails: [String: AnyObject]) {
        if let driverarray = requestDetails["driver"] as? [String:AnyObject] {
            if driverarray.count > 0 {
                if let firstName = driverarray["firstname"] as? String{
                    let str = firstName
                    self.tripView.lblDriverName.text = str.localizedCapitalized
                }
                
                if let driverphonenumber1 = driverarray["phone_number"] as? String {
                    self.driverPhoneNumber = driverphonenumber1
                }
   
                
                if let imgStr = driverarray["profile_pic"] as? String, let url = URL(string: imgStr) {
                    self.tripView.imgProfile.kf.indicatorType = .activity
                    let resource = ImageResource(downloadURL: url)
                    self.tripView.imgProfile.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
                } else {
                    self.tripView.imgProfile.image = UIImage(named: "profilePlaceHolder")
                }
                
// Using S3
//                if let imgStr = driverarray["profile_pic"] as? String {
//                    self.retriveImg(key: imgStr) { data in
//                        self.tripView.imgProfile.image = UIImage(data: data)
//                    }
//                }
                
                if let review = requestDetails["driver_overall_rating"] {
                    if let rating = Double("\(review)") {
                        self.tripView.ratingLbl.set(text: String(format: "%.2f", rating), with: UIImage(named: "star"))
                    }
                }
                if let typeName = requestDetails["vehicle_name"] as? String {
                    self.tripView.vehicleTypeLbl.text = typeName
                }
                if let vehModel = requestDetails["vehicle_model"] as? String {
                    
                    self.tripView.vehicleModelLbl.text =  vehModel.localizedCapitalized
                }
                if let vehicleNum = requestDetails["vehicle_number"] as? String {
                    self.tripView.vehicleNumberLbl.text =  vehicleNum.localizedCapitalized
                }
                
                if let vehicleImage = requestDetails["vehicle_highlight_image"] as? String {
                    if let url = URL(string: vehicleImage) {
                        let resource = ImageResource(downloadURL: url)
                        self.tripView.vehicleImageView.kf.setImage(with: resource)
                    }
                }
            }
        }
        
    }
    
}

//MARK:- TARGET ACTIONS

extension TripVC {
    
    @objc func btnPickupEditPressed(_ sender: UIButton) {
        let searchLocVC = SearchLocationVC()
        searchLocVC.titleText = "txt_choose_pickup".localize()
        searchLocVC.selectedLocation = { [weak self] selectedSearchLoc in

            if let selectedDropLoc = self?.selectedDropLocation?.coordinate {
                
                self?.getPolylineAfterPickupChanged(pickup: CLLocationCoordinate2D(latitude: selectedSearchLoc.latitude ?? 0, longitude: selectedSearchLoc.longitude ?? 0), drop: selectedDropLoc) { polyString in
                        self?.polyStringAfterPickupChanged = polyString
                        self?.changeLocationAPI(newLocation: selectedSearchLoc, type: "PICKUP")
                    }
              
            } else {
                self?.changeLocationAPI(newLocation: selectedSearchLoc, type: "PICKUP")
            }
        }
        self.navigationController?.pushViewController(searchLocVC, animated: true)
    }
    
    @objc func btnDropEditPressed (_ sender: UIButton) {
        let searchLocVC = SearchLocationVC()
        searchLocVC.titleText = "txt_choose_drop".localize()
        searchLocVC.selectedLocation = { [weak self] selectedSearchLoc in
 
                self?.changeLocationAPI(newLocation: selectedSearchLoc, type: "DROP")

        }
        self.navigationController?.pushViewController(searchLocVC, animated: true)
    }
    
    @objc func cancelBooking(_ sender: UIButton) {
       
        let cancelList = cancelListVC()
        cancelList.delegate = self
        cancelList.requestId = self.requestid
        cancelList.isDriverArrived = self.isDriverArrived
        cancelList.driverlocationCoord = CLLocationCoordinate2D(latitude: self.drivermarkerLat, longitude: self.drivermarkerLong)
        cancelList.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        cancelList.modalPresentationStyle = .overCurrentContext
        present(cancelList, animated: false, completion: nil)
    }
    
    @objc func goToPromo(_ sender: UITapGestureRecognizer) {
        let promoVC = PromoVC()
        promoVC.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        promoVC.promoView.textField.text = ""
        promoVC.promoView.textField.becomeFirstResponder()
        promoVC.modalPresentationStyle = .overCurrentContext
        promoVC.callBack = { [unowned self] promoBookedId in
            self.tripView.btnApplyPromo.setTitle("text_promo_applied".localize(), for: .normal)
            self.tripView.btnApplyPromo.isUserInteractionEnabled = false
        }
        present(promoVC, animated: false, completion: nil)
    }
    
    @objc func btnSosPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(SOSViewController(), animated: true)
    }
    
    @objc func callBtnAction(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "tel://" + driverPhoneNumber) {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func shareBtnPressed(_ sender: UIButton) {
        
        let objectsToShare:URL = URL(string: self.tripLink)!
        
        let activityViewController = UIActivityViewController(activityItems: [objectsToShare as Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func smsBtnAction(_ sender: UIButton) {
        if MFMessageComposeViewController.canSendText() {
            UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.appBoldTitleFont(ofSize: 18),.foregroundColor:UIColor.themeColor]
            UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appBoldTitleFont(ofSize: 15),.foregroundColor:UIColor.themeColor], for: .normal)
            let controller = MFMessageComposeViewController()
            controller.recipients = [driverPhoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}

//MARK:- NOTIFICATION OBSERVER

extension TripVC {
    
    @objc func tripLocationChangedObserver(_ notification: Notification) {
        
        if let object = notification.userInfo as? [String: AnyObject] {
            self.rideLocationChanged(object)
        }
    }
    
    @objc func methodOfCancelledReceivedNotification(notification: Notification) {
        
    }
}

//MARK:- API'S
extension TripVC {
    
    @objc func checkrequestinprogress() {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            let url = APIHelper.shared.BASEURL + APIHelper.checkRequestinProgress
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    print("Request in progress response",response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject]
                    {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let trips = data["trips"] as? [String: AnyObject] {
                                    if let tripData = trips["data"] as? [String: AnyObject] {
                                        if let isCancelled = tripData["is_cancelled"] as? Bool, isCancelled {
                                            self.showDriverCancelledPopup()
                                        } else {
                                            self.updateScreenForTripStatus(tripData, first: false)
                                        }
                                    }
                                } else {
                                    self.popToRootController()
                                }
                            }
                            
                        }
                        
                    }
            }
        }
    }
    
    func changeLocationAPI(newLocation: SearchLocation, type: String) {
        
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String, Any>()
            
            paramDict["request_id"] = self.requestid
            paramDict["latitude"] = newLocation.latitude
            paramDict["longitude"] = newLocation.longitude
            paramDict["address"] = newLocation.placeId
            paramDict["type"] = type
            
            if type == "PICKUP" {
                if self.polyStringAfterPickupChanged != "" {
                    paramDict["poly_string"] = self.polyStringAfterPickupChanged
                }
            }

            let url = APIHelper.shared.BASEURL + APIHelper.changeTripLocation
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON
                { response in
                    NKActivityLoader.sharedInstance.hide()
                    
                    switch response.result {
                    case .failure(let error):
                        self.view.showToast("txt_unable_to_change_location".localize())
                        print(error.localizedDescription)
                    case .success(_):
                        print(response.result.value as AnyObject)
                        if let result = response.result.value as? [String:AnyObject] {
                            if response.response?.statusCode == 200 {
                                
                                if type == "PICKUP" {
                                    self.selectedPickUpLocation = newLocation
                                    self.tripView.lblPickup.text = newLocation.placeId
                                    if let selectedPickUpLoc = self.selectedPickUpLocation?.coordinate {
                                        self.tripView.mapview.clear()
                                        self.drawRouteOnMap(false, drop: selectedPickUpLoc)
                                    }
                                } else {

                                    if let data = result["data"] as? [String: AnyObject],let resultData = data["result"] as? [String: AnyObject] {
                                        if let needLocApprove = resultData["location_approve"] as? Bool, needLocApprove {
                                            self.tripView.transparentWaitingLocationView.isHidden = false
                                        } else {
                                            self.tripView.transparentWaitingLocationView.isHidden = true
                                        }
                                    }
                                    
                                }
                                    
                            } else {
                                if let error = result["data"] as? [String:[String]] {
                                    let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                    self.showAlert("", message: errMsg)
                                } else if let errMsg = result["error_message"] as? String {
                                    self.showAlert("", message: errMsg)
                                } else if let msg = result["message"] as? String {
                                    self.showAlert("", message: msg)
                                }
                            }
                        }
                    }
                    
            }
        }
    }
    
}

//MARK: - FIREBASE OBSERVER
extension TripVC: MyFirebaseDelegate {
    func tripStatusReceived(_ tripId: String, response: [String : Any]) {
       // print("trip_status_2", response)
        
        if let distance = response["distancee"] as? Double {
            //self.tripView.distanceLbl.text = "Distance " + String(format: "%.2f", distance) + " " + "kms".localize()
        }
        
        if let serviceCategory = tripstatusfromripdict["service_category"] as? String, serviceCategory == "RENTAL" {
            if let rentalTripTime = response["rental_trip_time"] {
                tripView.waitingTimeLbl.text = "\(rentalTripTime)"
                tripView.waitingTimeCoverView.isHidden = false
                tripView.waitingTimeTitleLbl.text = "txt_trip_time_text".localize()
            }
        } else {
            if let waitingTime = response["waiting_time"] {
                tripView.waitingTimeLbl.text = "\(waitingTime)" + "\n"  + "txt_min".localize()
                tripView.waitingTimeCoverView.isHidden = false
            }
        }
        
        
        if let lat = response["lat"] , let long = response["lng"]  {
            
            if let bearing = response["bearing"] {
                self.drivermarkerrBearing = Double("\(bearing)") ?? 0
            }
            self.drivermarkerLat = Double("\(lat)") ?? 0
            self.drivermarkerLong = Double("\(long)") ?? 0
            
            self.calculateArrivalTime(drivermarkerLat, lng: drivermarkerLong)
            self.addmarkers()
            
        }
    
     }

    func calculateArrivalTime(_ lat: Double, lng: Double) {
        //print("arrival time calculation")
        if !self.isDriverArrived {
            let driverLocation = CLLocation(latitude: lat, longitude: lng)
            if let pickuplat = tripstatusfromripdict["pick_lat"] as? Double, let pickuplong = tripstatusfromripdict["pick_lng"] as? Double {
                let userLocation = CLLocation(latitude: pickuplat, longitude: pickuplong)
                let distance = driverLocation.distance(from: userLocation)/1000
                let speed = 50.0
                let time = distance/speed
                let arrivalTime = (time * 60) + 2.0
                let actualTime = arrivalTime.rounded()
                print("arrival Time",actualTime)
                
                self.tripView.viewArrivalEta.isHidden = false
                if actualTime <= 1 {
                    let mins = "1" + " " + "txt_min".localize()
                    self.tripView.lblArrivalEta.text = "txt_driver_pick_you_in".localize() + " " + mins
                } else if actualTime < 60 {
                    let mins = "\(actualTime)" + " " + "txt_min".localize()
                    self.tripView.lblArrivalEta.text = "txt_driver_pick_you_in".localize() + " " + mins
                } else {
                    let hours = actualTime / 60
                    
                    let mins = "\(hours)" + " " + "txt_hr".localize()
                    self.tripView.lblArrivalEta.text = "txt_driver_pick_you_in".localize() + " " + mins
                }
            }
            
        }
    }
}

//MARK: - SOCKET OBSERVER
extension TripVC: MySocketManagerDelegate {
    
    func tripStatusResponseReceived(_ response: [String : AnyObject]) {

        if let result = response["result"] as? [String: AnyObject] {
            if let data = result["data"] as? [String: AnyObject] {
                if let isCancelled = data["is_cancelled"] as? Bool, isCancelled {
                    self.showDriverCancelledPopup()
                } else {
                    self.updateScreenForTripStatus(data, first: false)
                }
                
            }
        }
       
    }
    
    func rideLocationChanged(_ response: [String : AnyObject]) {
        print("ride location changed",response)
        if let result = response["result"] as? [String: AnyObject] {
            self.tripView.transparentWaitingLocationView.isHidden = true
            
            if let type = result["type"] {
                let locType = "\(type)"
                if locType == "0" {
                    if let isAccepted = result["driver_accept"] as? Bool, isAccepted {
                        
                        if let lat = result["latitude"], let lng = result["longitude"], let address = result["address"] as? String {
                            
                            self.selectedDropLocation = SearchLocation(CLLocationCoordinate2D(latitude: Double("\(lat)") ?? 0, longitude: Double("\(lng)") ?? 0))
                            self.selectedDropLocation?.placeId = address
                            self.tripView.lblDrop.text = address
                            
                            
                            if let pathToDestination = result["poly_string"] as? String {
                                self.setPathToDestination(pathToDestination)
                            } else {
                                self.tripView.mapview.clear()
                                self.addMarkerAtCoordinate()
                            }
                        }
                    }
                } else {
                    self.showAlert("", message: "txt_driver_rejected".localize())
                }
                
            }
        }
        
    }
    
    
    func serviceCategoryChanged(_ response: [String : AnyObject]) {
        print("Service category changed",response)
        self.checkrequestinprogress()
    }
    
    func uploaduserPhoto(_ response: [String : AnyObject]) {
        print("Upload User photo",response)
        if let result = response["result"] as? [String: AnyObject] {
            if let uploadStatus = result["upload_status"] as? Bool, uploadStatus {
                
                let vc = NytTimePictureUploadVC()
                vc.modalPresentationStyle = .overFullScreen
                
                vc.requestID = self.requestid
                if let driverImg = result["upload_image_url"] as? String {
                    vc.driverImage = driverImg
                }
                if let retakeImage = result["retake_image"] as? Bool, retakeImage {
                    vc.retakePhoto = retakeImage
                }
                self.present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
}


extension TripVC {
    
    // updating the mapview when recieving driver details from socket
    func addmarkers() {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
            self.tripView.mapview.animate(to: GMSCameraPosition.camera(withLatitude: self.drivermarkerLat, longitude: self.drivermarkerLong, zoom: 15))
            self.tripView.mapview.animate(toBearing: self.drivermarkerrBearing)
            //self.driverMarker.rotation = self.drivermarkerrBearing
            self.driverMarker.position = CLLocationCoordinate2D(latitude: self.drivermarkerLat, longitude: self.drivermarkerLong)
            
            self.driverMarker.map = self.tripView.mapview
            CATransaction.commit()
        }
        
        
        if routeDrawn == false {
            if isDriverArrived == false {
                if APIHelper.pathToPickup == "" {
                    if let pickupCoord = self.selectedPickUpLocation?.coordinate {
                        self.drawRouteOnMap(false, drop: pickupCoord)
                    }
                    routeDrawn = true
                } else {
                    self.setPathToPickup(points: APIHelper.pathToPickup)
                }
            }
        }
    
    }
    
    // To draw a polyline on mapview
    func drawRouteOnMap(_ repeatAnimation:Bool, drop: CLLocationCoordinate2D) {
        
        routeStartPoint = CLLocationCoordinate2D(latitude: drivermarkerLat, longitude: drivermarkerLong)
        
        self.tripView.mapview.clear()
        self.addMarkerAtCoordinate()
        
        let queryItems = [URLQueryItem(name: "origin", value: "\(routeStartPoint.latitude),\(routeStartPoint.longitude)"),URLQueryItem(name: "destination", value: "\(drop.latitude),\(drop.longitude)"),URLQueryItem(name: "sensor", value: "true"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "key", value: "\(APIHelper.shared.gmsDirectionKey)")]
        
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)
        
        Alamofire.request(url).responseJSON { response in
            if case .failure(let error) = response.result
            {
                print(error.localizedDescription)
            }
            else if case .success = response.result
            {
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String
                {
                    if status == "OK"
                    {
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                            if self.isDriverArrived == false {
                                APIHelper.pathToPickup = points
                            }
                            DispatchQueue.main.async {
                                self.setPathToPickup(points: points)
                            }
                        }
                    }
                    else
                    {
                        self.view.showToast(status)
                    }
                }
            }
            
        }
    }
    
    
    // To get poly points
    func getPolylineAfterPickupChanged(pickup: CLLocationCoordinate2D,drop: CLLocationCoordinate2D, completion:@escaping(String)->()) {
        
        let queryItems = [URLQueryItem(name: "origin", value: "\(pickup.latitude),\(pickup.longitude)"),URLQueryItem(name: "destination", value: "\(drop.latitude),\(drop.longitude)"),URLQueryItem(name: "sensor", value: "true"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "key", value: "\(APIHelper.shared.gmsDirectionKey)")]
        
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)
        
        Alamofire.request(url).responseJSON { response in
            if case .failure(let error) = response.result
            {
                completion("")
                print(error.localizedDescription)
            }
            else if case .success = response.result
            {
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String
                {
                    if status == "OK"
                    {
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                           completion(points)
                        }
                    }
                    else
                    {
                        completion("")
                        self.view.showToast(status)
                    }
                }
            }
            
        }
    }
    
    func addMarkerAtCoordinate() {
        pickUpMarker = nil
        if let coordinate = self.selectedPickUpLocation?.coordinate {
            pickUpMarker = GMSMarker(position: coordinate)
            pickUpMarker.icon = UIImage(named: "ic_pick_pin")
            pickUpMarker.map = tripView.mapview
        }
        dropMarker = nil
        if let coordinate = self.selectedDropLocation?.coordinate {
            dropMarker = GMSMarker(position: coordinate)
            dropMarker.icon = UIImage(named: "ic_destination_pin")
            dropMarker.map = tripView.mapview
        }
        
    }
    
    func setPathToPickup(points: String) {
       
        let path = GMSPath(fromEncodedPath: points)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        let redYellow = GMSStrokeStyle.gradient(from: .themeColor, to: .themeColor.withAlphaComponent(0.4))
        polyline.spans = [GMSStyleSpan(style: redYellow)]
        polyline.map = self.tripView.mapview
    }
    
    func setPathToDestination(_ polyString: String) {
        
        self.tripView.mapview.clear()
        self.addMarkerAtCoordinate()
        
        let path = GMSPath(fromEncodedPath: polyString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        let redYellow = GMSStrokeStyle.gradient(from: .themeColor, to: .themeColor.withAlphaComponent(0.4))
        polyline.spans = [GMSStyleSpan(style: redYellow)]
        polyline.map = self.tripView.mapview
        
    }
    
    func forceLogout() {
        if let root = self.navigationController?.revealViewController().navigationController {
            let firstvc = Initialvc()
            root.view.showToast("text_already_login".localize())
            root.setViewControllers([firstvc], animated: false)
        }
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
        
    }

}
extension TripVC: CancelDetailsViewDelegate {
    func tripCancelled(_ msg: String) {
        self.popToRootController()
    }
    
    func showDriverCancelledPopup() {
        let alertVC = TripCancellledAlertVC()
        alertVC.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        alertVC.fileName = "cancelled"
        alertVC.lbl.text = "Txt_TripCanceled".localize()
        alertVC.callBack = { [unowned self] msg in
            
            self.popToRootController()
        }
        alertVC.modalPresentationStyle = .overCurrentContext
        self.dismissPresent(alertVC, animated: false, completion: nil)
    }
    
    func popToRootController() {
        APIHelper.pathToPickup = ""
        MySocketManager.shared.socketDelegate = nil
        FirebaseObserver.shared.firebaseDelegate = nil
        self.view.showToast("Txt_TripCanceled".localize())
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Trip Completed"), object: nil)
        if self.navigationController?.topViewController is TripVC {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
}
extension TripVC:  MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
