//
//  BookingVC.swift
//  Roda
//
//  Created by Apple on 12/04/22.
//

//
//  TypesVC.swift
//  Taxiappz
//
//  Created by Apple on 02/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Kingfisher
import Alamofire
import NVActivityIndicatorView
import Network

class BookingVC: UIViewController {

    private let typesView = BookingView()
    
    var selectedPickUpLocation:SearchLocation?
    var selectedDropLocation:SearchLocation?
    var selectedStopLocation: SearchLocation?
    
    var selectedStopLocationParam:[StopLocationParam]? = []
   
    private var newCarModels: [NewCarModel]? = []
    private var selectedNewCarModel: NewCarModel?
    
    var paymentTypes = [PaymentOption]()
    var selectedPaymentType:PaymentOption?
    
    var rideLaterDate: Date?
    var currency: String?
    
    var selectedPromo: String?


    var polyLineString: String?
    
    var driverPins = [String: GMSMarker]()
    var driverDatas = [String: [String: Any]]()
    
    private var etaForSelectedType = ""
    
    var selectedContact: ContactPerson?
    var selectedContactType: ContactType?
    
    private var reloadTimer: Timer?
    
    func deinitialize() {
        self.selectedPickUpLocation = nil
        self.selectedDropLocation = nil
        self.selectedStopLocation = nil
        self.newCarModels = nil
        self.selectedNewCarModel = nil
        self.rideLaterDate = nil
        self.currency = nil
        self.selectedPromo = nil
        self.polyLineString = nil
        FirebaseObserver.shared.firebaseDelegate = nil
        reloadTimer?.invalidate()
        reloadTimer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        getTypesAPI()
        
        if self.selectedContactType == nil {
            self.selectedContactType = .myself
            self.selectedContact = ContactPerson(self.selectedContactType?.title ?? "", phone: APIHelper.shared.userDetails?.phone ?? "")
            self.typesView.lblMyself.text = self.selectedContact?.name
        } else {
            
            self.typesView.lblMyself.text = self.selectedContact?.name
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        FirebaseObserver.shared.removeObservers()
        if let searchRadius = FirebaseObserver.shared.searchRadius {
            FirebaseObserver.shared.addDriverObservers(radius: searchRadius)
        } else {
            FirebaseObserver.shared.addDriverObservers(radius: 3.0)
        }
        FirebaseObserver.shared.firebaseDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(methodOfNoDriverReceivedNotification(notification:)), name: .noDriverFound, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfNoDriverReceivedNotification(notification:)), name: Notification.Name("TripCancelledbyDriverOrBydefault"), object: nil)
        
        reloadTimer?.invalidate()
        reloadTimer = nil
        reloadTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(reloadTimerTriggred), userInfo: nil, repeats: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    
      
    }
    
    @objc func reloadTimerTriggred() {
       
        self.typesView.collectionvw.reloadData()
        
    }
   
    func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        typesView.setupViews(Base: self.view, controller: self)
        typesView.collectionvw.delegate = self
        typesView.collectionvw.dataSource = self
        typesView.collectionvw.register(RideTypesCollectionCell.self, forCellWithReuseIdentifier: "RideTypesCollectionCell")

        setupMap()
        setupData()
        setupTarget()
    }
    
    func setupTarget() {
        typesView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        typesView.btnApplyPromo.addTarget(self, action: #selector(gotoPromo(_ :)), for: .touchUpInside)
        typesView.btnBookNow.addTarget(self, action: #selector(booknowPressed(_ :)), for: .touchUpInside)
        typesView.btnPaymentMode.addTarget(self, action: #selector(changePayment(_ :)), for: .touchUpInside)
        typesView.btnFareDetail.addTarget(self, action: #selector(goToFareDetails(_ :)), for: .touchUpInside)
       
        typesView.viewDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnCalenderPressed(_ :))))
        
        typesView.btnCall.addTarget(self, action: #selector(btnCallPressed(_ :)), for: .touchUpInside)
        typesView.btnNotes.addTarget(self, action: #selector(btnNotesPressed(_ :)), for: .touchUpInside)
        
        
        typesView.dropTxt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnEditDropPressed(_ :))))
        
        typesView.viewMyself.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(bookForOthersPressed(_ :))))
    }
    
    func setupMap() {
        if let selectedPickUpLoc = self.selectedPickUpLocation?.coordinate, let selectedDropLoc = self.selectedDropLocation?.coordinate {
          
            let coord = CLLocationCoordinate2D(latitude: selectedPickUpLoc.latitude, longitude: selectedPickUpLoc.longitude)
            let camera = GMSCameraPosition.camera(withTarget: coord, zoom: 18)
            self.typesView.mapview.camera = camera
            
            if self.selectedStopLocation != nil {
                var points = [CLLocationCoordinate2D]()
                points.append(selectedPickUpLoc)
                if let stopLoc = self.selectedStopLocation?.coordinate {
                    points.append(stopLoc)
                }
                points.append(selectedDropLoc)
                self.drawWayPointRoutes(selectedPickUpLoc, drop: selectedDropLoc, points: points)
                
            } else {
                self.drawRoute(selectedPickUpLoc, drop: selectedDropLoc)
            }
            
            
        }
    }
    
    func setupData() {
        
        if self.selectedStopLocation != nil {
            self.typesView.viewStop.isHidden = false
            if let stop = self.selectedStopLocation {
                self.typesView.stopTxt.text = stop.placeId
            }
        } else {
            self.typesView.viewStop.isHidden = true
        }

        if let pickup = self.selectedPickUpLocation {
            self.typesView.pickupTxt.text = pickup.placeId
        }
        if let drop = self.selectedDropLocation {
            self.typesView.dropTxt.text = drop.placeId
        }
    }
    
}

//MARK:- TARGET ACTIONS
extension BookingVC {
    
   
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.deinitialize()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func gotoPromo(_ sender: UIButton) {
        let promoVC = PromoVC()
        promoVC.selectedPromo = self.selectedPromo
        promoVC.tripType = "LOCAL"
        promoVC.callBack = { [unowned self] selectedPromo in
            self.selectedPromo = selectedPromo
            self.getTypesAPI(nil, promoCode: selectedPromo)
            self.typesView.btnApplyPromo.setTitle("text_promo_applied".localize(), for: .normal)
            
        }
        promoVC.promoCancelledClouser = {[weak self] cancelled in
            if cancelled {
                self?.selectedPromo = nil
                self?.getTypesAPI()
                self?.typesView.btnApplyPromo.setTitle("txt_coupon".localize().localize(), for: .normal)
            }
            
        }
        self.navigationController?.pushViewController(promoVC, animated: true)
    }
   
    @objc func goToFareDetails(_ sender: UIButton) {
        let fareDetailsVC = FareDetailsVC()
        fareDetailsVC.selectedNewCarModel = self.selectedNewCarModel
        fareDetailsVC.currency = self.currency ?? ""
        fareDetailsVC.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        fareDetailsVC.modalPresentationStyle = .overCurrentContext
        present(fareDetailsVC, animated: false, completion: nil)
    }
    
    @objc func btnCallPressed(_ sender: UIButton) {
        self.callForInstantBooking()
    }
    
    @objc func btnNotesPressed(_ sender: UIButton) {
        let vc = DriverNotesVC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func btnCalenderPressed(_ sender: UITapGestureRecognizer) {
        let vc = RideDatePickerVC()
        if let date = self.rideLaterDate {
            vc.selectedDate = date
        }
        vc.callBack = {[weak self] date, type in
            
            if type == .later {
                self?.rideLaterDate = date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd,MMM"
                let dateStr = dateFormatter.string(from: date)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm a"
                let timeStr = timeFormatter.string(from: date)
                
                self?.typesView.lblDate.text = dateStr + "\n" + timeStr
                
                self?.getTypesAPI(date)
                
                self?.typesView.btnBookNow.setTitle("text_schedule".localize() + " " + (self?.selectedNewCarModel?.typeName ?? ""), for: .normal)
                
                
//                self?.typesView.btnBookNow.isEnabled = true
//                self?.typesView.btnBookNow.backgroundColor = .themeColor
//                self?.typesView.btnCall.isHidden = true
                
            } else if type == .now {
                self?.rideLaterDate = nil
               
                self?.typesView.lblDate.text = "txt_now".localize()
               
                self?.typesView.btnBookNow.setTitle("txt_book_now".localize() + " " + (self?.selectedNewCarModel?.typeName ?? ""), for: .normal)
               
            }
            
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
   
    
    @objc func changePayment(_ sender: UIButton) {
        let paymentSelectionVC = PaymentOptionVC()
        paymentSelectionVC.paymentOptions = self.paymentTypes
        paymentSelectionVC.selectedPaymentOption = self.selectedPaymentType
        paymentSelectionVC.callBack = {[unowned self] type in
            self.selectedPaymentType = type
            self.typesView.btnPaymentMode.setTitle(self.selectedPaymentType?.title, for: .normal)
        }
        self.navigationController?.pushViewController(paymentSelectionVC, animated: true)

       // self.view.showToast("txt_only_cashmode_available".localize())
    }
    
    @objc func bookForOthersPressed(_ sender: UITapGestureRecognizer) {
        let vc = BookForOthersVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedContact = self.selectedContact
        vc.selectedContactType = self.selectedContactType
        vc.callBack = {[weak self] contact,type in
            self?.selectedContact = contact
            self?.selectedContactType = type
            self?.typesView.lblMyself.text = contact.name
        }
        self.present(vc, animated: true, completion:nil)
    }
    
    @objc func btnEditDropPressed(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
       
    }
    
    @objc func booknowPressed(_ sender: UIButton) {
        if self.rideLaterDate != nil {
            self.rideLaterRequest()
        } else {
            self.createRequest()
        }
    }
}

//MARK: NOTIFICATION ACTIONS
extension BookingVC {
    @objc func methodOfNoDriverReceivedNotification(notification: Notification) {
        
    }
    
    @objc func requestedAnotherDriver(_ notification: Notification) {
        
    }
}

//MARK: - COLLECTION DELEGATES
extension BookingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newCarModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RideTypesCollectionCell", for: indexPath) as? RideTypesCollectionCell ?? RideTypesCollectionCell()
       
        cell.imgview.kf.indicatorType = .activity
    
        cell.lblTypeName.text = self.newCarModels?[indexPath.row].typeName?.capitalized
       
        if self.etaForSelectedType == "" {
            cell.lblEtaMin.text = "NA"
            /*
            if self.rideLaterDate == nil {
                self.typesView.btnBookNow.isEnabled = false
                self.typesView.btnBookNow.backgroundColor = .themeColor//hexToColor("#F4F4F4")
                self.typesView.btnCall.isHidden = false
            }
            */
        } else {
            cell.lblEtaMin.text = self.etaForSelectedType
            /*
            self.typesView.btnBookNow.isEnabled = true
            self.typesView.btnBookNow.backgroundColor = .themeColor
            self.typesView.btnCall.isHidden = true
            */
        }
        
        if self.selectedNewCarModel == self.newCarModels?[indexPath.row] {
            cell.colorBackground.backgroundColor = .hexToColor("#FDEEAE")
            cell.imgview.kf.setImage(with: self.newCarModels?[indexPath.row].selectedTypeImage)
            cell.lblTypeName.font = UIFont.appSemiBold(ofSize: 14)
            cell.lblEtaMin.isHidden = false
            cell.viewContent.addBorder(edges: .bottom, colour: .secondaryColor, thickness: 0.5)
            
        } else {
            cell.colorBackground.backgroundColor = .hexToColor("#F4F4F4")
            cell.imgview.kf.setImage(with: self.newCarModels?[indexPath.row].iconResource)
            cell.lblTypeName.font = UIFont.appRegularFont(ofSize: 14)
            cell.lblEtaMin.isHidden = true
            cell.viewContent.addBorder(edges: .bottom, colour: .hexToColor("DADADA"), thickness: 0.5)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedNewCarModel = self.newCarModels?[indexPath.row]
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.setupTotalAmount()
        if self.rideLaterDate == nil {
            self.typesView.btnBookNow.setTitle("txt_book_now".localize() + " " + (self.selectedNewCarModel?.typeName ?? ""), for: .normal)
        } else {
            self.typesView.btnBookNow.setTitle("text_schedule".localize() + " " + (self.selectedNewCarModel?.typeName ?? ""), for: .normal)
        }
        
        self.driverPins.forEach({
            $0.value.map = nil
            FirebaseObserver.shared.removeObserverFor($0.key)
        })
        self.etaForSelectedType = ""
        self.calculateEtaForType()
        self.showFirebaseCarMarkers()
        self.typesView.collectionvw.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/4, height: 100)
    }
    
    func setupTotalAmount() {
        if self.selectedNewCarModel?.isPromoApplied ?? false {
            
            if let promoAmt = self.selectedNewCarModel?.promoTotalAmount {
                self.typesView.promoHint.isHidden = true
                self.typesView.lblPromoAmount.isHidden = false
                self.typesView.lblPromoAmount.font = UIFont.appSemiBold(ofSize: 25)
                self.typesView.lblAmount.font = UIFont.appSemiBold(ofSize: 13)
                self.typesView.lblPromoAmount.text = (self.currency ?? "") + " " + promoAmt
                let attributedText = NSAttributedString(
                    string: (self.currency ?? "") + " " + (self.selectedNewCarModel?.totalAmount ?? ""),
                    attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,.strikethroughColor:UIColor.red]
                )
                self.typesView.lblAmount.attributedText = attributedText
                
            } else {
                self.typesView.promoHint.isHidden = false
                self.typesView.lblPromoAmount.text = ""
                self.typesView.lblPromoAmount.isHidden = true
                let attrText = NSAttributedString(string: (self.currency ?? "") + " " + (self.selectedNewCarModel?.totalAmount ?? ""), attributes: nil)
                self.typesView.lblAmount.attributedText = attrText
                self.typesView.lblAmount.font = UIFont.appSemiBold(ofSize: 25)
            }
            
        } else {
            self.typesView.promoHint.isHidden = true
            self.typesView.lblPromoAmount.text = ""
            self.typesView.lblPromoAmount.isHidden = true
            let attrText = NSAttributedString(string: (self.currency ?? "") + " " + (self.selectedNewCarModel?.totalAmount ?? ""), attributes: nil)
            self.typesView.lblAmount.attributedText = attrText
            self.typesView.lblAmount.font = UIFont.appSemiBold(ofSize: 25)
        }
    }
}

//MARK: - API'S
extension BookingVC {
    
    func getPaymentMode(payment mode: [String]) {
        
        self.paymentTypes = mode.compactMap({ (str) -> [PaymentOption] in
            switch str {
            case "CASH":
                return [PaymentOption(rawValue: "1")].compactMap { $0 }
            case "CARD":
                return [PaymentOption(rawValue: "2")].compactMap { $0 }
            case "UPI":
                return [PaymentOption(rawValue: "3")].compactMap { $0 }
            case "WALLET":
                return [PaymentOption(rawValue: "4")].compactMap { $0 }
            case "ALL":
                return PaymentOption.allCases
            default:
                return []
            }
        }).flatMap({$0})
    }
    
    func getTypesAPI(_ rideDate: Date? = nil, promoCode: String? = nil) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            
            paramDict["pickup_lat"] = self.selectedPickUpLocation?.latitude
            paramDict["pickup_long"] = self.selectedPickUpLocation?.longitude
            paramDict["drop_lat"] = self.selectedDropLocation?.latitude
            paramDict["drop_long"] = self.selectedDropLocation?.longitude
            paramDict["pickup_address"] = self.selectedPickUpLocation?.placeId
            paramDict["drop_address"] = self.selectedDropLocation?.placeId
            paramDict["ride_type"] = "RIDE_NOW"
            
            let dFormatter = DateFormatter()
            dFormatter.dateFormat = "yyyy-MM-dd"
            let tFormatter = DateFormatter()
            tFormatter.dateFormat = "HH:mm:ss"
            
            if rideDate == nil {
                paramDict["ride_type"] = "RIDE_NOW"
                
                paramDict["ride_date"] = dFormatter.string(from: Date())
                
                paramDict["ride_time"] = tFormatter.string(from: Date())
            } else {
                paramDict["ride_type"] = "RIDE_LATER"
                
                paramDict["ride_date"] = dFormatter.string(from: rideDate ?? Date())
                
                paramDict["ride_time"] = tFormatter.string(from: rideDate ?? Date())
            }
            
            if promoCode != nil {
                paramDict["promo_code"] = promoCode
            }
            
            if self.selectedStopLocationParam?.count != 0 {
                do {
                    let jsonData = try JSONEncoder().encode(self.selectedStopLocationParam)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        paramDict["stops"] = jsonString
                    }
                } catch { print(error) }
            }
            
            
            let url = APIHelper.shared.BASEURL + APIHelper.getTypes
            print(url, paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as AnyObject)
                if let result = response.result.value as? [String:AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let currency = data["currency_symble"] as? String {
                                self.currency = currency
                            }
                            if self.selectedPaymentType == nil {
                                if let paymentTypes = data["payment_types"] as? [String] {
                                    self.getPaymentMode(payment: paymentTypes)
                                    self.selectedPaymentType = self.paymentTypes.first
                                    self.typesView.btnPaymentMode.setTitle(self.selectedPaymentType?.title, for: .normal)
                                }
                            }
                            
                            if let typeList = data["zone_type_price"] as? [[String: AnyObject]] {
                                self.newCarModels = typeList.compactMap({NewCarModel($0)})
                                
                                if !(self.newCarModels?.isEmpty ?? false) {
                                    if self.selectedNewCarModel == nil {
                                        self.selectedNewCarModel = self.newCarModels?.first
                                        self.showFirebaseCarMarkers()
                                        self.setupTotalAmount()
                                        
                                        if self.rideLaterDate == nil {
                                            self.typesView.btnBookNow.setTitle("txt_book_now".localize() + " " + (self.selectedNewCarModel?.typeName ?? ""), for: .normal)
                                        } else {
                                            self.typesView.btnBookNow.setTitle("text_schedule".localize() + " " + (self.selectedNewCarModel?.typeName ?? ""), for: .normal)
                                        }
                                    } else if self.selectedNewCarModel != nil {
                                        self.selectedNewCarModel = self.newCarModels?.first(where: {$0.typeId == self.selectedNewCarModel?.typeId})
                                        self.showFirebaseCarMarkers()
                                        self.setupTotalAmount()
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.typesView.collectionvw.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        
                        if response.response?.statusCode == 401 {
                            self.forceLogout()
                        } else if response.response?.statusCode == 400 {
                            self.typesView.noServiceView.isHidden = false
                        } else if response.response?.statusCode == 403 {
                            self.typesView.noServiceView.isHidden = false
                        } else {
                            self.typesView.noServiceView.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    func createRequest() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            
            paramDict["pick_lat"] = self.selectedPickUpLocation?.latitude
            paramDict["pick_lng"] = self.selectedPickUpLocation?.longitude
            paramDict["pick_address"] = self.selectedPickUpLocation?.placeId
            paramDict["drop_lat"] = self.selectedDropLocation?.latitude
            paramDict["drop_lng"] = self.selectedDropLocation?.longitude
            paramDict["drop_address"] = self.selectedDropLocation?.placeId
            paramDict["vehicle_type"] = self.selectedNewCarModel?.typeId
            paramDict["payment_opt"] = self.selectedPaymentType?.slug
            paramDict["ride_type"] = "LOCAL"
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
            }
            if self.polyLineString != nil {
                paramDict["poly_string"] = self.polyLineString
            }
            if self.selectedStopLocationParam?.count != 0 {
                do {
                    let jsonData = try JSONEncoder().encode(self.selectedStopLocationParam)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        paramDict["stops"] = jsonString
                    }
                } catch { print(error) }
            }
            
            paramDict["booking_for"] = self.selectedContactType?.title
            if self.selectedContactType == .others {
                paramDict["others_name"] = self.selectedContact?.name
                paramDict["others_number"] = self.selectedContact?.phone
            }
            
            let url = APIHelper.shared.BASEURL + APIHelper.createRequest
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any, response.response?.statusCode as Any)
                switch response.result {
                case .success(_):
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let requestData = data["data"] as? [String: AnyObject] {
                                    if let reqID = requestData["id"] as? String {
                                        
                                        let vc = WaitingForDriverVC()
                                        vc.modalPresentationStyle = .overFullScreen
                                        vc.requestId = reqID
                                        vc.polyString = self.polyLineString ?? ""
                                        vc.selectedPickupLocation = self.selectedPickUpLocation
                                        vc.selectedDropLocation = self.selectedDropLocation
                                        vc.callback = {[unowned self] tripData, isAccepted in
                                            if isAccepted {
                                                self.deinitialize()
                                                let vc = TripVC()
                                                vc.tripstatusfromripdict = tripData
                                                if self.navigationController?.topViewController is BookingVC {
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                }
                                            } else {
                                                if let reqId = tripData["id"] as? String{
                                                    self.openNoDriversFoundScreen(reqId)
                                                }
                                            }
                                        }
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                    
                                }
                            }
                        } else {
                            
                            if let data = result["data"] as? [String: AnyObject] {
                                if let errCode = data["error_code"] as? Int, errCode == 2001 {
                                    if let requestId = data["request_id"] as? String {
                                        self.openNoDriversFoundScreen(requestId)
                                    }
                                    
                                } else {
                                    self.view.showToast("txt_Something_wrong_trylater".localize())
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
                case .failure(let error):
                    self.view.showToast(error.localizedDescription)
                    
                }
                
            }
        } else {
            self.showAlert("", message: "txt_NoInternet_title".localize())
        }
        
    }
    
    func openNoDriversFoundScreen(_ reqId: String) {
        self.view.showToast("txt_instant_call_booking_title".localize())
//        let vc = NoDriversFoundVC()
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.reqID = reqId
//        self.present(vc, animated: true, completion: nil)
    }
    
    func callForInstantBooking() {
        let alert = UIAlertController(title: "txt_instant_call_booking_title".localize(), message: "txt_plz_reach_us".localize(), preferredStyle: .actionSheet)
        let okbtn = UIAlertAction(title: "txt_call".localize().uppercased(), style: .default) { action in
            if let phoneCallURL = URL(string: "tel://" + ("txt_admin_number".localize())) {
                let application: UIApplication = UIApplication.shared
                if application.canOpenURL(phoneCallURL) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
        let cancelbtn = UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil)
        alert.addAction(okbtn)
        alert.addAction(cancelbtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    func rideLaterRequest() {
        guard let date = rideLaterDate else { return }
        if ConnectionCheck.isConnectedToNetwork() {

            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            
            paramDict["pick_lat"] = self.selectedPickUpLocation?.latitude
            paramDict["pick_lng"] = self.selectedPickUpLocation?.longitude
            paramDict["pick_address"] = self.selectedPickUpLocation?.placeId
            paramDict["drop_lat"] = self.selectedDropLocation?.latitude
            paramDict["drop_lng"] = self.selectedDropLocation?.longitude
            paramDict["drop_address"] = self.selectedDropLocation?.placeId
            paramDict["vehicle_type"] = self.selectedNewCarModel?.typeId
            paramDict["payment_opt"] = self.selectedPaymentType?.slug
            paramDict["ride_type"] = "LOCAL"
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = dateFormatter.string(from: date)
            paramDict["trip_start_time"] = dateStr
            
            paramDict["is_later"] = "1"
            if self.polyLineString != nil {
                paramDict["poly_string"] = self.polyLineString
            }
            if self.selectedStopLocationParam?.count != 0 {
                do {
                    let jsonData = try JSONEncoder().encode(self.selectedStopLocationParam)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        paramDict["stops"] = jsonString
                    }
                } catch { print(error) }
            }
            
            paramDict["booking_for"] = self.selectedContactType?.title
            if self.selectedContactType == .others {
                paramDict["others_name"] = self.selectedContact?.name
                paramDict["others_number"] = self.selectedContact?.phone
            }
            
            let url = APIHelper.shared.BASEURL + APIHelper.createRequest
            
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any, response.response?.statusCode as Any)
                switch response.result {
                    
                case .success(_):
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            
                            let vc = RideLaterSucessVC()
                            vc.rideLaterDate = self.rideLaterDate ?? Date()
                            vc.callBack = { [weak self] StrValue in
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Trip Completed"), object: nil)
                                self?.navigationController?.popToRootViewController(animated: true)
                                
                            }
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: true)
                            
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
                case .failure(let error):
                    self.view.showToast(error.localizedDescription)
                }
            }
        } else {
            self.showAlert("", message: "txt_NoInternet_title".localize())
        }
    }
    func drawRoute(_ pickup: CLLocationCoordinate2D, drop: CLLocationCoordinate2D) {
       
      
        let queryItems = [URLQueryItem(name: "origin", value: "\(pickup.latitude),\(pickup.longitude)"),URLQueryItem(name: "destination", value: "\(drop.latitude),\(drop.longitude)"),URLQueryItem(name: "sensor", value: "true"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "key", value: "\(APIHelper.shared.gmsDirectionKey)")]
        
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)
        print(url)
        Alamofire.request(url).responseJSON { response in
            print(response.result.value as Any)
            if case .failure(let error) = response.result {
                print(error.localizedDescription)
            }
            else if case .success = response.result {
                
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String {
                    if status == "OK" {
                     
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                            print(points)
                            self.polyLineString = points
                            self.setPath(polyString: points)

                        }
                    }
                    else
                    {
                        self.setMapBoundsWithoutPath()
                        
                    }
                }
            }
          
        }
    }
    
    func drawWayPointRoutes(_ pickup: CLLocationCoordinate2D, drop: CLLocationCoordinate2D,points:[CLLocationCoordinate2D]) {
        var wayPoints = ""
    
        // wayPoints = "\(stopLat),\(stopLong)"
        for point in points {
            wayPoints = wayPoints == "" ? "\(point.latitude),\(point.longitude)" : "\(wayPoints)|\(point.latitude),\(point.longitude)"
        }
           
      
        let queryItems = [URLQueryItem(name: "origin", value: "\(pickup.latitude),\(pickup.longitude)"),URLQueryItem(name: "destination", value: "\(drop.latitude),\(drop.longitude)"),URLQueryItem(name: "sensor", value: "true"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "waypoints", value: "\(wayPoints)"),URLQueryItem(name: "key", value: "\(APIHelper.shared.gmsDirectionKey)")]
        
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)
        print(url)
        Alamofire.request(url).responseJSON { response in
            print(response.result.value as Any)
            if case .failure(let error) = response.result {
                print(error.localizedDescription)
            }
            else if case .success = response.result {
                
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String {
                    if status == "OK" {
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first,let legs = route["legs"] as? [[String:AnyObject]], let legFirst = legs.first, let data = legFirst["distance"] as? [String: AnyObject] {
                            if let distance = data["text"] as? String {
//                                self.dropMarkerView.viewDistance.isHidden = false
//                                self.dropMarkerView.lblDistance.text = distance
                            }
                        }
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                            print(points)
                            self.polyLineString = points
                            self.setPath(polyString: points)

                        }
                    }
                    else
                    {
                        self.setMapBoundsWithoutPath()
                        
                    }
                }
            }
          
        }
    }
    
    func setPath(polyString points: String) {
        
        let path = GMSPath(fromEncodedPath: points)
        let bounds = GMSCoordinateBounds(path: path!)
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 20, left: 70, bottom: 20, right: 70))
        self.typesView.mapview.moveCamera(update)
        
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        let redYellow = GMSStrokeStyle.gradient(from: .themeColor, to: .themeColor.withAlphaComponent(0.4))
        polyline.spans = [GMSStyleSpan(style: redYellow)]
        polyline.map = self.typesView.mapview
        
        let psth = GMSPath(fromEncodedPath: points)
        if let path = psth {
            let distanceInKm = GMSGeometryLength(path) / 1000.0
            print(distanceInKm)
        }
        if let coord1 = path?.coordinate(at: 0) {
            let marker = GMSMarker()
            marker.position = coord1
            marker.isTappable = true
            marker.icon = UIImage(named: "ic_pick_pin")
            marker.isFlat = true
            marker.map = self.typesView.mapview
            
        }
        if let coord2 = path?.coordinate(at: (psth?.count() ?? 0)-1) {
            let marker = GMSMarker()
            marker.position = coord2
            marker.icon = UIImage(named: "ic_destination_pin")
            marker.isFlat = true
            marker.map = self.typesView.mapview
            
        }
        
        if self.selectedStopLocation != nil {
            let stopMarker = GMSMarker()
            if let location = self.selectedStopLocation {
                stopMarker.position = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            }
            stopMarker.map = typesView.mapview
           
        }
    }
    
    func setMapBoundsWithoutPath() {
        
        var markers = [GMSMarker]()
        if let coord1 = self.selectedPickUpLocation?.coordinate {
            let marker = GMSMarker()
            marker.position = coord1
            marker.isTappable = true
            marker.icon = UIImage(named: "ic_pick_pin")
            marker.isFlat = true
            marker.map = self.typesView.mapview
            
            markers.append(marker)
        }
        if let coord2 = self.selectedDropLocation?.coordinate {
            let marker = GMSMarker()
            marker.position = coord2
            marker.icon = UIImage(named: "ic_destination_pin")
            marker.isFlat = true
            marker.map = self.typesView.mapview
            markers.append(marker)
        }
        
        if self.selectedStopLocation != nil {
            let stopMarker = GMSMarker()
            if let location = self.selectedStopLocation {
                stopMarker.position = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            }
            stopMarker.map = typesView.mapview
            markers.append(stopMarker)
        }
        var bounds = GMSCoordinateBounds()
        for mark in markers {
            bounds = bounds.includingCoordinate(mark.position)
        }
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 20, left: 70, bottom: 20, right: 70))
        self.typesView.mapview.moveCamera(update)
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

// MARK: - response received from firebase observers
extension BookingVC: MyFirebaseDelegate {
    
    func driverEnteredFence(_ key: String, location: CLLocation, response: [String: Any]) {
        if let isActive = response["is_active"] as? Bool, let isAvailable = response["is_available"] as? Bool {
            if isActive && isAvailable {
                if let updatedAt = response["updated_at"] as? Int64 {
                    let currentTime = Date().millisecondsSince1970
                    let diff = (currentTime - updatedAt) / 1000
                    if diff < (5 * 60) {
                        let driverPin = GMSMarker.init(position: location.coordinate)
                        if let vehicleType = response["type"] as? String, vehicleType == "bajaj-auto" {
                            driverPin.icon = UIImage(named: "ic_pin_auto")
                        } else {
                            driverPin.icon = UIImage(named: "pin_driver")
                        }
                        driverPin.rotation = location.course
                        driverPin.isFlat = true
                        self.driverPins[key] = driverPin
                        self.driverDatas[key] = response
                        
                        showFirebaseCarMarkers()
                        self.calculateEtaForType()
                        DispatchQueue.main.async {
                            self.typesView.collectionvw.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    func driverExitedFence(_ key: String, location: CLLocation, response: [String : Any]) {
        if let driverPin = self.driverPins[key] {
            driverPin.map = nil
            self.driverPins.removeValue(forKey: key)
            self.driverDatas.removeValue(forKey: key)
            
            FirebaseObserver.shared.removeObserverFor(key)
           
            self.etaForSelectedType = ""
            self.calculateEtaForType()
            showFirebaseCarMarkers()
            
            DispatchQueue.main.async {
                self.typesView.collectionvw.reloadData()
            }
        }
    }
    
    func driverMovesInFence(_ key: String, location: CLLocation, response: [String : Any]) {
        if let isActive = response["is_active"] as? Bool, let isAvailable = response["is_available"] as? Bool {
            if isActive && isAvailable {
                if let driverPin = self.driverPins[key] {
                    driverPin.position = location.coordinate
                    driverPin.rotation = location.course
                    
                    self.driverPins[key] = driverPin
                    self.driverDatas[key] = response
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
                            self.driverPins[key] = driverPin
                            self.driverDatas[key] = response
                            
                            showFirebaseCarMarkers()
                        }
                    }
                }
            } else {
                if let driverPin = self.driverPins[key] {
                    driverPin.map = nil
                    self.driverPins.removeValue(forKey: key)
                    self.driverDatas.removeValue(forKey: key)
                    
                    FirebaseObserver.shared.removeObserverFor(key)
                   
                }
            }
          
        }
    }
    
    func driverWentOffline(_ key: String) {
        if let driverPin = self.driverPins[key] {
            driverPin.map = nil
            self.driverPins.removeValue(forKey: key)
            self.driverDatas.removeValue(forKey: key)
            
            
            self.etaForSelectedType = ""
            self.calculateEtaForType()
            showFirebaseCarMarkers()
            DispatchQueue.main.async {
                self.typesView.collectionvw.reloadData()
            }
        }
       
    }
    
    func driverDataUpdated(_ key: String, response: [String : Any]) {
        if let isActive = response["is_active"] as? Bool, let isAvailable = response["is_available"] as? Bool {
            if !isActive || !isAvailable {
                if let driverPin = self.driverPins[key] {
                    driverPin.map = nil
                    self.driverPins.removeValue(forKey: key)
                    self.driverDatas.removeValue(forKey: key)
                }
            } else {
               
                if !self.driverPins.keys.contains(key) {
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
                        driverPin.isFlat = true
                        
                        self.driverPins[key] = driverPin
                        self.driverDatas[key] = response
                        
                        
                        calculateEtaForType()
                        showFirebaseCarMarkers()
                        DispatchQueue.main.async {
                            self.typesView.collectionvw.reloadData()
                        }
                        
                    }
                  
                } else {
                    calculateEtaForType()
                }
                
            }
          
        }
    }
    
    func showFirebaseCarMarkers() {
        
        self.driverPins.forEach({
            let driverId = $0.key
            let driverData = driverDatas[driverId]!
            
            if let typeId = driverData["type"] {
                let vehicleType = "\(typeId)"
                if self.selectedNewCarModel != nil {
                    
                    if self.selectedNewCarModel?.typeId == vehicleType {
                        if let serviceCategory = driverData["service_category"] as? String,serviceCategory.contains("LOCAL") {
                            
                            let driverPinNow = $0.value
                            driverPinNow.map = typesView.mapview
                            
                            FirebaseObserver.shared.addObserverFor(driverId)
                            
                        }
                        
                    }
                }
            }
        })
        
    }
    
    func calculateEtaForType() {
        var timeList = [Int]()
        if self.selectedNewCarModel != nil {
            self.driverDatas.forEach({
                let driverData = $0.value
                
                if let typeId = driverData["type"] {
                   let vehicleType = "\(typeId)"
                    if vehicleType == self.selectedNewCarModel?.typeId {
                        if let serviceCategory = driverData["service_category"] as? String,serviceCategory.contains("LOCAL") {
                            let driverLocation = driverData["l"] as? [Double]
                            let driver_lat = driverLocation![0]
                            let driver_lng = driverLocation![1]
                            
                            let driverLoc = CLLocation(latitude: driver_lat, longitude: driver_lng)
                            
                            
                            let pickLocation = CLLocation.init(latitude: self.selectedPickUpLocation?.coordinate?.latitude ?? 0, longitude: self.selectedPickUpLocation?.coordinate?.longitude ?? 0)
                            
                            let distance = driverLoc.distance(from: pickLocation)/1000
                            
                            let time = distance/40
                            let arrivalTime = (time*60) + 2.0
                            let actualTime = arrivalTime.rounded()
                            
                            timeList.append(Int(actualTime))
                            
                            if let minTime = timeList.min() {
                                
                                if minTime <= 1 {
                                    let mins = " " + "1 " + "txt_min".localize()
                                    self.etaForSelectedType = mins
                                } else if minTime < 60 {
                                    let mins = " " + "\(minTime) " + "txt_min".localize()
                                    self.etaForSelectedType = mins
                                    
                                } else {
                                    let hours = minTime / 60
                                    let minutes = minTime % 60
                                    
                                    let mins = " " + "\(hours) " + "txt_hr".localize() + "\(minutes) " + "txt_min".localize()
                                    self.etaForSelectedType = mins
                                }
                                
                            }
                        }
                    }
                }
                
            })

            
        }

    }
    
}

extension String {
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "EEE,MMM dd, hh:mm a"
            
            return dateFormatter.string(from: date)
            
        }
        return ""
    }
}

