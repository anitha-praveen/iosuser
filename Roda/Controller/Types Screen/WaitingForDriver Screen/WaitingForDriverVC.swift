//
//  WaitingForDriverVC.swift
//  Petra Ride
//
//  Created by Spextrum on 13/05/19.
//  Copyright © 2019 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import MTSlideToOpen
import GoogleMaps
class WaitingForDriverVC: UIViewController, MTSlideToOpenDelegate {
    
    var layoutDic = [String: AnyObject]()
    
    let mapview = GMSMapView()
    let pulseAnimator = NVActivityIndicatorView(frame: .zero, type: .ballScaleRippleMultiple, color: .secondThemeColor)
    
    let viewContent = UIView()
    
    let lblSearchingForDrivers = UILabel()
    let progressView = UIProgressView()
    let noteLbl = UILabel()
    let lblHint = UILabel()
    let cancelView = MTSlideToOpenView()
   
    var callback : ((_ response: [String : AnyObject], Bool) -> Void)?
    var requestId: String?
    
    var polyString = ""
    var selectedPickupLocation: SearchLocation?
    var selectedDropLocation: SearchLocation?
        
    private var progressTimer: Timer?
    private var progressCount = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setupMap()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        cancelView.resetStateWithAnimation(true)
        MySocketManager.shared.socketDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(checkrequestinprogress), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(driverRejected(_:)), name: .driverRejected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfRideLaterNoDriverReceivedNotification(notification:)), name: .rideLaterNoCaptainFound, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pulseAnimator.stopAnimating()
        MySocketManager.shared.socketDelegate = nil
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .driverRejected, object: nil)
        NotificationCenter.default.removeObserver(self, name: .rideLaterNoCaptainFound, object: nil)
    }
    
    @objc func methodOfRideLaterNoDriverReceivedNotification(notification: Notification) {
        self.progressCount = 0.0
        self.progressTimer?.invalidate()
        self.progressTimer = nil
        self.dismiss(animated: true) {
            self.callback?([:], false)
        }
    }
    
    @objc func driverRejected(_ notification: Notification) {
        self.progressCount = 0.0
        self.progressTimer?.invalidate()
        self.progressTimer = nil
        self.dismiss(animated: true) {
            self.callback?([:], false)
        }
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.secondaryColor
        
        mapview.isUserInteractionEnabled = false
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["mapview"] = mapview
        view.addSubview(mapview)
        
        pulseAnimator.startAnimating()
        pulseAnimator.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pulseAnimator"] = pulseAnimator
        view.addSubview(pulseAnimator)
        
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.backgroundColor = .secondaryColor
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewContent"] = viewContent
        view.addSubview(viewContent)

        lblSearchingForDrivers.text = "txt_searching_roda_drivers".localize()
        lblSearchingForDrivers.textColor = .txtColor
        lblSearchingForDrivers.textAlignment = .center
        lblSearchingForDrivers.font = UIFont.appBoldFont(ofSize: 20)
        lblSearchingForDrivers.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblSearchingForDrivers"] = lblSearchingForDrivers
        viewContent.addSubview(lblSearchingForDrivers)
        
        progressView.progress = 0.0
        progressView.layer.cornerRadius = 6
        progressView.clipsToBounds = true
        progressView.progressTintColor = .themeColor
        progressView.tintColor = .gray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["progressView"] = progressView
        viewContent.addSubview(progressView)
        
        noteLbl.textColor = .txtColor
        noteLbl.textAlignment = .center
        noteLbl.font = UIFont.appBoldFont(ofSize: 20)
        noteLbl.text = "txt_slide_cancel".localize()
        noteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["noteLbl"] = noteLbl
        viewContent.addSubview(noteLbl)
        
        lblHint.textColor = .txtColor
        lblHint.textAlignment = .center
        lblHint.font = UIFont.appRegularFont(ofSize: 15)
        lblHint.text = "txt_ride_start_soon".localize()
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblHint"] = lblHint
        viewContent.addSubview(lblHint)
        
        if APIHelper.appLanguageDirection == . directionRightToLeft {
            cancelView.appLanguageEnglish = false
        } else {
            cancelView.appLanguageEnglish = true
        }
        cancelView.textLabelLeadingDistance = 10
        cancelView.delegate = self
        cancelView.sliderViewTopDistance = 0
        cancelView.sliderCornerRadius = 5
        cancelView.sliderBackgroundColor = .hexToColor("D9D9D9")
        cancelView.slidingColor = UIColor.red.withAlphaComponent(0.6)
        cancelView.thumnailImageView.backgroundColor = .hexToColor("D9D9D9")
        cancelView.thumnailImageView.image = UIImage(named: "img_next_button")
        cancelView.labelText = "txt_slide_cancel".localize().uppercased()
        cancelView.textFont = UIFont.appSemiBold(ofSize: 16)
        cancelView.textColor = .hexToColor("757474")

        cancelView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cancelView"] = cancelView
        viewContent.addSubview(cancelView)
        
        mapview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: viewContent.topAnchor, constant:20).isActive = true
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        pulseAnimator.widthAnchor.constraint(equalToConstant: 180).isActive = true
        pulseAnimator.centerXAnchor.constraint(equalTo: mapview.centerXAnchor, constant: 0).isActive = true
        pulseAnimator.heightAnchor.constraint(equalToConstant: 180).isActive = true
        pulseAnimator.centerYAnchor.constraint(equalTo: mapview.centerYAnchor, constant: 0).isActive = true
        
        viewContent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:0).isActive = true        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblSearchingForDrivers(30)]-8-[progressView(12)]-15-[noteLbl(30)]-5-[lblHint(30)]-15-[cancelView(40)]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblSearchingForDrivers]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[progressView]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[noteLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHint]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[cancelView]-(30)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
    }
    
    @objc func updateProgress() {
        
        self.progressCount += 0.01
        
        if self.progressCount < 1.0 {

            UIView.animate(withDuration: 1) {
                self.progressView.setProgress(Float(self.progressCount), animated: true)
            }
        } else {
            self.progressCount = 0.0
            self.progressTimer?.invalidate()
            self.progressTimer = nil
        }
    }
    
    func setupMap() {
        
        if let selectedPickUpLoc = self.selectedPickupLocation?.coordinate {
          
            let coord = CLLocationCoordinate2D(latitude: selectedPickUpLoc.latitude, longitude: selectedPickUpLoc.longitude)
            let camera = GMSCameraPosition.camera(withTarget: coord, zoom: 18)
            self.mapview.camera = camera
        }
        
        if self.polyString != "" {
            
            let path = GMSPath(fromEncodedPath: self.polyString)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 4.0
            let redYellow = GMSStrokeStyle.gradient(from: .themeColor, to: .themeColor.withAlphaComponent(0.4))
            polyline.spans = [GMSStyleSpan(style: redYellow)]
            polyline.map = self.mapview
            
            let psth = GMSPath(fromEncodedPath: self.polyString)
            
            if let coord1 = path?.coordinate(at: 0) {
                let marker = GMSMarker()
                marker.position = coord1
                marker.icon = UIImage(named: "ic_pick_pin")
                marker.isFlat = true
                marker.map = self.mapview
                
                let camera = GMSCameraPosition.camera(withTarget: coord1, zoom: 18)
                self.mapview.camera = camera
                
            }
            if let coord2 = path?.coordinate(at: (psth?.count() ?? 0)-1) {
                let marker1 = GMSMarker()
                marker1.position = coord2
                marker1.icon = UIImage(named: "ic_destination_pin")
                marker1.isFlat = true
                marker1.map = self.mapview
                
            }
        } else {
            if let pickupCoord = self.selectedPickupLocation?.coordinate {
                let marker = GMSMarker()
                marker.position = pickupCoord
                marker.icon = UIImage(named: "ic_pick_pin")
                marker.isFlat = true
                marker.map = self.mapview
            }
            if let dropCoord = self.selectedDropLocation?.coordinate {
                let marker1 = GMSMarker()
                marker1.position = dropCoord
                marker1.icon = UIImage(named: "ic_destination_pin")
                marker1.isFlat = true
                marker1.map = self.mapview
            }
        }
        
    }
    
    @objc func cancelBtnAction() {
        
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_cancelling_request".localize())
            var paramDict = Dictionary<String, Any>()
           
            paramDict["request_id"] = self.requestId
            paramDict["custom_reason"] = "User Cancelled"
            

            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.cancelRide
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            self.progressCount = 0.0
                            self.progressTimer?.invalidate()
                            self.progressTimer = nil
                            self.dismiss(animated: true, completion: nil)
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
    
    // MARK: MTSlideToOpenDelegate
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        cancelBtnAction()
        sender.resetStateWithAnimation(true)
    }
    
    func forceLogout() {
        guard let navigationController = self.presentingViewController as? UINavigationController else {
            return
        }
        if let root = navigationController.revealViewController().navigationController {
            let firstvc = Initialvc()
                root.view.showToast("text_already_login".localize())
                root.setViewControllers([firstvc], animated: false)
        }
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
    
}

extension WaitingForDriverVC: MySocketManagerDelegate {
    func tripStatusResponseReceived(_ response: [String : AnyObject]) {
        print(response)
        if let result = response["result"] as? [String: AnyObject] {
            if let data = result["data"] as? [String: AnyObject] {
                self.progressCount = 0.0
                self.progressTimer?.invalidate()
                self.progressTimer = nil
                if let isDriverStarted = data["is_driver_started"] as? Bool, isDriverStarted {
                    self.dismiss(animated: true) {
                        self.callback?(data, true)
                    }
                } else {
                    self.dismiss(animated: true) {
                        self.callback?(data, false)
                    }
                }
                
            }
        }
        
    }
    
    
    @objc func checkrequestinprogress() {
        if ConnectionCheck.isConnectedToNetwork() {
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
                                        if let isDriverStarted = tripData["is_driver_started"] as? Bool, isDriverStarted {
                                            self.progressCount = 0.0
                                            self.progressTimer?.invalidate()
                                            self.progressTimer = nil
                                            self.dismiss(animated: true) {
                                                self.callback?(tripData, true)
                                            }
                                        } else if let isCancelled = tripData["is_cancelled"] as? Bool, isCancelled {
                                            self.progressCount = 0.0
                                            self.progressTimer?.invalidate()
                                            self.progressTimer = nil
                                            self.dismiss(animated: true) {
                                                self.callback?(tripData, false)
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
    
}

