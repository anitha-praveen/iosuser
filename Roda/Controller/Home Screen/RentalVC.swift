//
//  RentalVC.swift
//  Roda
//
//  Created by Apple on 02/05/22.
//

import UIKit
import Alamofire
import GoogleMaps
import Kingfisher
class RentalVC: UIViewController {

    let rentalView = RentalView()
    var selectedLocation: SearchLocation?
    
    var rentalPackageLists = [RentalPackageList]()
    var selectedPackageList: RentalPackageList?
    
    private var rentalPackageTypes = [RentalPackageType]()
    private var selectedPackageType: RentalPackageType?
    
    var rideLaterDate: Date?
    var selectedPromo: String?
    
    var selectedPaymentType = "CASH"
    
    var driverPins = [String: GMSMarker]()
    var driverDatas = [String: [String: Any]]()
    var etaForSelectedType = ""
    
    private var reloadTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        self.getRentalPackageTypes(self.selectedPackageList?.slug ?? "")
        self.setupMap()
        self.setupTarget()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseObserver.shared.firebaseDelegate = self
        reloadTimer?.invalidate()
        reloadTimer = nil
        reloadTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reloadTimerTriggred), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        FirebaseObserver.shared.firebaseDelegate = nil
        reloadTimer?.invalidate()
        reloadTimer = nil
    }
    
    @objc func reloadTimerTriggred() {
       
        self.rentalView.packageTypesCollectionView.reloadData()
        
    }
    
    func setupViews() {
        rentalView.setupViews(Base: self.view)
        
        rentalView.packageCollectionvw.delegate = self
        rentalView.packageCollectionvw.dataSource = self
        rentalView.packageCollectionvw.register(PackageListCell.self, forCellWithReuseIdentifier: "PackageListCell")
        
        rentalView.packageTypesCollectionView.delegate = self
        rentalView.packageTypesCollectionView.dataSource = self
        rentalView.packageTypesCollectionView.register(PackageTypesCollectionCell.self, forCellWithReuseIdentifier: "PackageTypesCollectionCell")
    }
    
    func setupTarget() {
        rentalView.btnBack.addTarget(self, action: #selector(backBtnPressed(_:)), for: .touchUpInside)
        rentalView.btnEditLocation.addTarget(self, action: #selector(btnEditLocationPressed(_ :)), for: .touchUpInside)
        rentalView.viewDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnCalenderPressed(_ :))))
        rentalView.btnApplyPromo.addTarget(self, action:#selector(gotoPromo(_ :)) , for: .touchUpInside)
        
        rentalView.btnBookNow.addTarget(self, action:#selector(bookTrip(_ :)) , for: .touchUpInside)
        rentalView.btnPaymentMode.addTarget(self, action: #selector(changePayment(_ :)), for: .touchUpInside)
        rentalView.btnCall.addTarget(self, action: #selector(btnCallPressed(_ :)), for: .touchUpInside)
        rentalView.btnFareDetail.addTarget(self, action: #selector(btnFareDetailPressed(_ :)), for: .touchUpInside)
        
    }
    func setupMap() {
        self.rentalView.txtLocation.text = self.selectedLocation?.placeId
        if let selectedLoc = self.selectedLocation?.coordinate {
            let camera = GMSCameraPosition.camera(withTarget: selectedLoc, zoom: 15)
            self.rentalView.mapview.camera = camera
            
        }
    }

}


//MARK: - TARGET ACTIONS
extension RentalVC {
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnFareDetailPressed(_ sender: UIButton) {
        let vc = RentalFareDetailVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedPackageType = self.selectedPackageType
        vc.selectedPackage = self.selectedPackageList
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
                
                self?.rentalView.lblDate.text = dateStr + "\n" + timeStr
                
                self?.getRentalPackageTypes(self?.selectedPackageList?.slug ?? "")
                
                self?.rentalView.btnBookNow.setTitle("text_schedule".localize() + " " + (self?.selectedPackageType?.typeName ?? ""), for: .normal)
            } else if type == .now {
                self?.rideLaterDate = nil
               
                self?.rentalView.lblDate.text = "txt_now".localize()
               
                self?.rentalView.btnBookNow.setTitle("txt_book_now".localize() + " " + (self?.selectedPackageType?.typeName ?? ""), for: .normal)
               
            }
            
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
 
    @objc func btnEditLocationPressed(_ sender: UIButton) {
        let vc = SearchLocationVC()
        vc.titleText = "txt_choose_pickup".localize()
        vc.selectedLocation = { [weak self] selectedSearchLoc in
            self?.selectedLocation = selectedSearchLoc
            self?.rentalView.txtLocation.text = selectedSearchLoc.placeId
            if let lat = selectedSearchLoc.latitude, let long = selectedSearchLoc.longitude {
                self?.rentalView.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
                self?.rentalView.mapview.clear()
                FirebaseObserver.shared.removeObservers()
                self?.driverDatas = [:]
                self?.driverPins = [:]
                FirebaseObserver.shared.selectedPickupLocation = self?.selectedLocation
                if let searchRadius = FirebaseObserver.shared.searchRadius {
                    FirebaseObserver.shared.addDriverObservers(radius: searchRadius)
                } else {
                    FirebaseObserver.shared.addDriverObservers(radius: 3.0)
                }
            }
        
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changePayment(_ sender: UIButton) {

        self.view.showToast("txt_only_cashmode_available".localize())
    }
    
    @objc func gotoPromo(_ sender: UIButton) {
        let promoVC = PromoVC()
        promoVC.selectedPromo = self.selectedPromo
        promoVC.tripType = "RENTAL"
        promoVC.callBack = { [unowned self] selectedPromo in
            self.selectedPromo = selectedPromo
            self.getRentalPackageTypes(self.selectedPackageList?.slug ?? "")
            self.rentalView.btnApplyPromo.setTitle("text_promo_applied".localize(), for: .normal)
            
        }
        promoVC.promoCancelledClouser = {[weak self] cancelled in
            if cancelled {
                self?.selectedPromo = nil
                self?.getRentalPackageTypes(self?.selectedPackageList?.slug ?? "")
                self?.rentalView.btnApplyPromo.setTitle("txt_coupon".localize().localize(), for: .normal)
            }
            
        }
        self.navigationController?.pushViewController(promoVC, animated: true)
    }
    
    @objc func btnCallPressed(_ sender: UIButton) {
        self.callForInstantBooking()
    }
    
    @objc func bookTrip(_ sender: UIButton) {
        if self.rideLaterDate != nil {
            self.rideLaterRequest()
        } else {
            self.createRequest()
        }
    }
}

//MARK: - Collection Delegates
extension RentalVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.rentalView.packageCollectionvw {
            return self.rentalPackageLists.count
        } else if collectionView == self.rentalView.packageTypesCollectionView {
            if self.rentalPackageTypes.count == 0 {
                let noData = UILabel()
                noData.textColor = .txtColor
                noData.textAlignment = .center
                noData.text = "txt_no_vehicle_types_found".localize()
                collectionView.backgroundView = noData
            } else {
                collectionView.backgroundView = nil
            }
            return self.rentalPackageTypes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.rentalView.packageCollectionvw {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageListCell", for: indexPath) as? PackageListCell ?? PackageListCell()
            cell.lblHour.text = self.rentalPackageLists[indexPath.item].hours
            cell.lblDistance.text = self.rentalPackageLists[indexPath.item].distance
            
            if self.selectedPackageList?.id == self.rentalPackageLists[indexPath.item].id {
                cell.viewContent.backgroundColor = .themeColor
            } else {
                cell.viewContent.backgroundColor = .hexToColor("F4F4F4")
            }
            
            return cell
        } else if collectionView == self.rentalView.packageTypesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageTypesCollectionCell", for: indexPath) as? PackageTypesCollectionCell ?? PackageTypesCollectionCell()
            
            let types = self.rentalPackageTypes[indexPath.item]
            cell.lblTypeName.text = types.typeName
            if self.etaForSelectedType == "" {
                /*
                cell.lblMin.text = "NA"
                if self.rideLaterDate == nil {
                    self.rentalView.btnBookNow.isEnabled = false
                    self.rentalView.btnBookNow.backgroundColor = .hexToColor("#F4F4F4")
                    self.rentalView.btnCall.isHidden = false
                }
                */
            } else {
                cell.lblMin.text = self.etaForSelectedType
                /*
                self.rentalView.btnBookNow.isEnabled = true
                self.rentalView.btnBookNow.backgroundColor = .themeColor
                self.rentalView.btnCall.isHidden = true
                */
            }
            if self.selectedPackageType?.id == self.rentalPackageTypes[indexPath.item].id {
                cell.lblMin.isHidden = false
                cell.colorBackground.backgroundColor = .hexToColor("#FDEEAE")
                cell.lblTypeName.textColor = .txtColor
                if let url = URL(string: types.highlightImage ?? "") {
                    let resource = ImageResource(downloadURL: url)
                    cell.imgview.kf.setImage(with: resource)
                }
            } else {
                cell.lblMin.isHidden = true
                cell.colorBackground.backgroundColor = .hexToColor("F4F4F4")
                cell.lblTypeName.textColor = .hexToColor("979797")
                if let url = URL(string: types.typeImage ?? "") {
                    let resource = ImageResource(downloadURL: url)
                    cell.imgview.kf.setImage(with: resource)
                }
            }
           
           
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.rentalView.packageCollectionvw {
            self.selectedPackageList = self.rentalPackageLists[indexPath.item]
            self.rentalView.packageCollectionvw.reloadData()
          //  self.selectedPackageType = nil
            self.getRentalPackageTypes(self.selectedPackageList?.slug ?? "")
        } else if collectionView == self.rentalView.packageTypesCollectionView {
            self.selectedPackageType = self.rentalPackageTypes[indexPath.item]
            self.rentalView.packageTypesCollectionView.reloadData()
            if self.rideLaterDate != nil {
                self.rentalView.btnBookNow.setTitle("text_schedule".localize() + " " + (self.selectedPackageType?.typeName ?? ""), for: .normal)
            } else  {
                self.rentalView.btnBookNow.setTitle("txt_book_now".localize() + " " + (self.selectedPackageType?.typeName ?? ""), for: .normal)
            }
            
            self.setupFareAMount()
            
            self.driverPins.forEach({
                $0.value.map = nil
                FirebaseObserver.shared.removeObserverFor($0.key)
            })
            self.etaForSelectedType = ""
            self.calculateEtaForType()
            self.showFirebaseCarMarkers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.rentalView.packageCollectionvw {
            return CGSize(width: 60, height: 50)
        } else if collectionView == self.rentalView.packageTypesCollectionView {
            return CGSize(width: rentalView.packageTypesCollectionView.frame.size.width/4, height: 80)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func setupFareAMount() {
        if self.selectedPackageType?.isPromoApplied ?? false {
            if let amt = self.selectedPackageType?.totalPromoAmount {
                self.rentalView.promoHint.isHidden = true
                self.rentalView.lblPromoAmount.isHidden = false
                self.rentalView.lblPromoAmount.font = UIFont.appSemiBold(ofSize: 25)
                self.rentalView.lblAmount.font = UIFont.appSemiBold(ofSize: 13)
                self.rentalView.lblPromoAmount.text = (self.selectedPackageType?.currency ?? "") + " " + amt
                let attributedText = NSAttributedString(
                    string: (self.selectedPackageType?.currency ?? "") + " " + (self.selectedPackageType?.totalAmout ?? ""),
                    attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,.strikethroughColor:UIColor.red]
                )
                self.rentalView.lblAmount.attributedText = attributedText
            } else {
                self.rentalView.promoHint.isHidden = false
                self.rentalView.lblPromoAmount.text = ""
                self.rentalView.lblPromoAmount.isHidden = true
                let attrText = NSAttributedString(string: (self.selectedPackageType?.currency ?? "") + " " + (self.selectedPackageType?.totalAmout ?? ""), attributes: nil)
                self.rentalView.lblAmount.attributedText = attrText
                self.rentalView.lblAmount.font = UIFont.appSemiBold(ofSize: 25)
            }
        } else {
            self.rentalView.promoHint.isHidden = true
            self.rentalView.lblPromoAmount.text = ""
            self.rentalView.lblPromoAmount.isHidden = true
            self.rentalView.lblAmount.text = (self.selectedPackageType?.currency ?? "") + " " + (self.selectedPackageType?.totalAmout ?? "")
            self.rentalView.lblAmount.font = UIFont.appSemiBold(ofSize: 25)
        }
    }
    
}

//MARK: - API'S
extension RentalVC {
    func getRentalPackageTypes(_ slug: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            paramDict["package_id"] = slug
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
            }
            let url = APIHelper.shared.BASEURL + APIHelper.getPackageTypes
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON{ (response) in
                NKActivityLoader.sharedInstance.hide()
                switch response.result {
                case .success(_):
                    print("RentalPackage types",response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [[String: AnyObject]] {
                            self.rentalPackageTypes = data.compactMap({RentalPackageType($0)})
                            
                            if !self.rentalPackageTypes.isEmpty {
                                if self.selectedPackageType == nil {
                                    self.selectedPackageType = self.rentalPackageTypes.first
                                    self.setupFareAMount()
                                    self.rentalView.btnBookNow.setTitle("txt_book_now".localize() + " " + (self.selectedPackageType?.typeName ?? ""), for: .normal)
                                } else if self.selectedPackageType != nil {
                                    if let type = self.rentalPackageTypes.first(where: {$0.typeId == self.selectedPackageType?.typeId}) {
                                        self.selectedPackageType = type
                                    } else {
                                        self.selectedPackageType = self.rentalPackageTypes.first
                                    }
                                   // self.selectedPackageType = self.rentalPackageTypes.first(where: {$0.typeId == self.selectedPackageType?.typeId})
                                    
                                    self.setupFareAMount()
                                }
                                
                            }
                            self.rentalView.packageTypesCollectionView.reloadData()
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    func createRequest() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            
            paramDict["pick_lat"] = self.selectedLocation?.latitude
            paramDict["pick_lng"] = self.selectedLocation?.longitude
            paramDict["pick_address"] = self.selectedLocation?.placeId
            
            paramDict["package_item_id"] = self.selectedPackageType?.id
            paramDict["payment_opt"] = self.selectedPaymentType
            paramDict["ride_type"] = "RENTAL"
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
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
                                        vc.selectedPickupLocation = self.selectedLocation
                                       
                                        vc.callback = {[unowned self] tripData, isAccepted in
                                            if isAccepted {
                                               
                                                let vc = TripVC()
                                                vc.tripstatusfromripdict = tripData
                                                if self.navigationController?.topViewController is RentalVC {
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
    
    
    func rideLaterRequest() {
        guard let date = rideLaterDate else { return }
        if ConnectionCheck.isConnectedToNetwork() {

            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            
            paramDict["pick_lat"] = self.selectedLocation?.latitude
            paramDict["pick_lng"] = self.selectedLocation?.longitude
            paramDict["pick_address"] = self.selectedLocation?.placeId
            
            paramDict["package_item_id"] = self.selectedPackageType?.id
            paramDict["payment_opt"] = self.selectedPaymentType
            paramDict["ride_type"] = "RENTAL"
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = dateFormatter.string(from: date)
            paramDict["trip_start_time"] = dateStr
            
            paramDict["is_later"] = "1"
            
            
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
    
}


// MARK:- response received from firebase observers
extension RentalVC: MyFirebaseDelegate {
    
    func driverEnteredFence(_ key: String, location: CLLocation, response: [String: Any]) {
        if let isActive = response["is_active"] as? Bool, let isAvailable = response["is_available"] as? Bool {
            if isActive && isAvailable {
                if let updatedAt = response["updated_at"] as? Int64 {
                    let currentTime = Date().millisecondsSince1970
                    let diff = (currentTime - updatedAt) / 1000
                    if diff < (5 * 60) {
                        let driverPin = GMSMarker.init(position: location.coordinate)
                        let img = UIImage(named: "pin_driver")
                        driverPin.icon = img
                        driverPin.rotation = location.course
                        driverPin.isFlat = true
                        self.driverPins[key] = driverPin
                        self.driverDatas[key] = response
                        
                        self.calculateEtaForType()
                        showFirebaseCarMarkers()
                    } else {
                        print("Last updated \(diff / 60) mins ago")
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
            
            self.rentalView.packageTypesCollectionView.reloadData()
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
                            let img = UIImage(named: "pin_driver")
                            driverPin.icon = img
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
            
            self.rentalView.packageTypesCollectionView.reloadData()
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
                        let img = UIImage(named: "pin_driver")
                        driverPin.icon = img
                        driverPin.isFlat = true
                        
                        self.driverPins[key] = driverPin
                        self.driverDatas[key] = response
                        
                        
                        self.calculateEtaForType()
                        showFirebaseCarMarkers()
                        
                        self.rentalView.packageTypesCollectionView.reloadData()
                    }
                  
                } else {
                    calculateEtaForType()
                }
            }
           
        }
    }
    
    func showFirebaseCarMarkers() {
        print("driver pins are",self.driverPins)
        self.driverPins.forEach({
            let driverId = $0.key
            let driverData = driverDatas[driverId]!
            
            if let typeId = driverData["type"] {
                let typeIdInt = "\(typeId)"
                if self.selectedPackageType != nil {
                    
                    if self.selectedPackageType?.typeId == typeIdInt {
                        if let serviceCategory = driverData["service_category"] as? String,serviceCategory.contains("RENTAL") {
                            
                            let driverPinNow = $0.value
                            driverPinNow.map = rentalView.mapview
                            
                            FirebaseObserver.shared.addObserverFor(driverId)
                        }
                        
                    }
                }
            }
        })
        
    }
    
    func calculateEtaForType() {
        var timeList = [Int]()
        if self.selectedPackageType != nil {
            self.driverDatas.forEach({
                let driverData = $0.value
                
                if let typeId = driverData["type"] {
                    let typedIdInt = "\(typeId)"
                    if typedIdInt == self.selectedPackageType?.typeId {
                        if let serviceCategory = driverData["service_category"] as? String,serviceCategory.contains("RENTAL") {
                            let driverLocation = driverData["l"] as? [Double]
                            let driver_lat = driverLocation![0]
                            let driver_lng = driverLocation![1]
                            
                            let driverLoc = CLLocation(latitude: driver_lat, longitude: driver_lng)
                            
                            
                            let pickLocation = CLLocation.init(latitude: self.selectedLocation?.coordinate?.latitude ?? 0, longitude: self.selectedLocation?.coordinate?.longitude ?? 0)
                            
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
                                    
                                    let mins = " " + "\(hours)" + "txt_hr".localize() + "\(minutes)" + "txt_min".localize()
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
