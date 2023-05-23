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

class TypesVC: UIViewController {

    private let typesView = TypesView()
    
    var selectedPickUpLocation:SearchLocation?
    var selectedDropLocation:SearchLocation?
    var selectedStopLocation: SearchLocation?
    
    var selectedStopLocationParam:[StopLocationParam]? = []
   
    private var newCarModels: [NewCarModel]? = []
    private var selectedNewCarModel: NewCarModel?
    
    var paymentTypes = [String]()
    var selectedPaymentType = ""
    
    var rideLaterDate: Date?
    var currency: String?
    
    var selectedPromo: String?

    var animatedPolyline:AnimatedPolyLine?
    
    var polyLineString: String?
    
    var driverPins = [String: GMSMarker]()
    var driverDatas = [String: [String: Any]]()
    
    let pickupMarkerView = PickupPointIconView(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
    let dropMarkerView = DropPointIconView(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
    
    func deinitialize() {
        self.selectedPickUpLocation = nil
        self.selectedDropLocation = nil
        self.selectedStopLocation = nil
        self.newCarModels = nil
        self.selectedNewCarModel = nil
        self.animatedPolyline = nil
        self.rideLaterDate = nil
        self.currency = nil
        self.selectedPromo = nil
        self.polyLineString = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typesView.mapview.delegate = self
        setupViews()
        
        getTypesAPI()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(detectPan(recognizer:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        typesView.viewBottom.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupData()
        FirebaseObserver.shared.firebaseDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(methodOfNoDriverReceivedNotification(notification:)), name: .noDriverFound, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfNoDriverReceivedNotification(notification:)), name: Notification.Name("TripCancelledbyDriverOrBydefault"), object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.animatedPolyline = nil
        FirebaseObserver.shared.firebaseDelegate = nil
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        typesView.viewDot.createVerticalDottedLine(width: 3, color: UIColor.txtColor.cgColor)
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        typesView.setupViews(Base: self.view, controller: self)
        typesView.tblTypes.delegate = self
        typesView.tblTypes.dataSource = self
        typesView.tblTypes.register(TypesCell.self, forCellReuseIdentifier: "typescell")

        setupMap()
        setupData()
        setupTarget()
    }
    
    func setupTarget() {
        typesView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        typesView.lblPromo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoPromo(_ :))))
        typesView.btnBookNow.addTarget(self, action: #selector(booknowPressed(_ :)), for: .touchUpInside)
        typesView.viewPay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePayment(_ :))))
        typesView.btnCalender.addTarget(self, action: #selector(btnCalenderPressed(_ :)), for: .touchUpInside)
        
    }
    
    func setupMap() {
        if let selectedPickUpLoc = self.selectedPickUpLocation?.coordinate, let selectedDropLoc = self.selectedDropLocation?.coordinate {
            //self.typesView.mapview.clear()
            
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
        if let pickup = self.selectedPickUpLocation {
            self.typesView.lblPickup.text = pickup.placeId
        }
        if let drop = self.selectedDropLocation {
            self.typesView.lblDrop.text = drop.placeId
        }
    }
    
}

//MARK:- TARGET ACTIONS
extension TypesVC {
    
    @objc func detectPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let isDraggingDown = translation.y > 0
        
        let newHeight = typesView.containerCurrentHeight - translation.y
        
//        if newHeight < typesView.containerDefaultHeight {
//            return
//        }
        
        if (self.newCarModels?.count ?? 0) <= 3 {
            return
        }
        
        switch recognizer.state {
        
        case .changed:

            if newHeight < typesView.containerMaximumHeight {
                typesView.containerHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            } else if newHeight < typesView.containerDefaultHeight {
                break
            }
           
        case .ended:
            
            if newHeight < typesView.containerDefaultHeight {
                animateContainerHeight(typesView.containerDefaultHeight)
                UIView.animate(withDuration: 1) {
                    self.typesView.viewAnim.alpha = 0
                    self.typesView.viewAnim.isHidden = true
                }
            }
            else if newHeight < typesView.containerMaximumHeight && isDraggingDown {
                
                animateContainerHeight(typesView.containerDefaultHeight)
                UIView.animate(withDuration: 1) {
                    
                    self.typesView.viewAnim.isHidden = true
                    self.typesView.viewAnim.alpha = 0
                }
            }
            else if newHeight > typesView.containerDefaultHeight && !isDraggingDown {
                UIView.animate(withDuration: 1) {
                    self.typesView.viewAnim.isHidden = false
                    self.typesView.viewAnim.alpha = 1
                    
                }
                animateContainerHeight(typesView.containerMaximumHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.typesView.containerHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        typesView.containerCurrentHeight = height
    }
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.deinitialize()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func gotoPromo(_ sender: UITapGestureRecognizer) {
        let promoVC = PromoVC()
        promoVC.selectedPromo = self.selectedPromo
        promoVC.callBack = { [unowned self] selectedPromo in
            self.selectedPromo = selectedPromo
            self.getTypesAPI(nil, promoCode: selectedPromo)
            self.typesView.lblPromo.text = "    ".localize()
            self.typesView.lblPromo.textColor = .green
            
        }
        promoVC.promoCancelledClouser = {[weak self] cancelled in
            if cancelled {
                self?.selectedPromo = nil
                self?.getTypesAPI()
                self?.typesView.lblPromo.text = "Txt_title_Promocode".localize()
                self?.typesView.lblPromo.textColor = .txtColor
            }
            
        }
        self.navigationController?.pushViewController(promoVC, animated: true)
    }
    
    @objc func goToFareDetails(_ sender: UIButton) {
        let fareDetailsVC = FareDetailsVC()
        fareDetailsVC.selectedNewCarModel = self.selectedNewCarModel
        fareDetailsVC.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        fareDetailsVC.modalPresentationStyle = .overCurrentContext
        present(fareDetailsVC, animated: false, completion: nil)
    }
    
    
    @objc func btnCalenderPressed(_ sender: UIButton) {
        let vc = RideDatePickerVC()
        vc.scheduleTripMinTime = 30
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
                self?.getTypesAPI(date)
                self?.typesView.btnBookNow.setTitle("txt_ride_at".localize() + " " + "\(dateStr), \(timeStr)", for: .normal)
            } else if type == .now {
                self?.rideLaterDate = nil
                self?.typesView.btnBookNow.setTitle("txt_book_now".localize(), for: .normal)
            }
            
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
   
    @objc func changePayment(_ sender: UIButton) {
        let paymentSelectionVC = PaymentSelectVC()
        paymentSelectionVC.paymentTypeList = self.paymentTypes
        paymentSelectionVC.selectedPaymentType = self.selectedPaymentType
        paymentSelectionVC.callBack = {[unowned self] type in
            self.selectedPaymentType = type
            self.typesView.lblPayment.text = self.selectedPaymentType
        }
        self.navigationController?.pushViewController(paymentSelectionVC, animated: true)

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
extension TypesVC {
    @objc func methodOfNoDriverReceivedNotification(notification: Notification) {
        
    }
    
    @objc func requestedAnotherDriver(_ notification: Notification) {
        
    }
}

extension TypesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newCarModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typescell") as? TypesCell ?? TypesCell()
        cell.selectionStyle = .none
        cell.imgview.kf.indicatorType = .activity
        cell.imgview.kf.setImage(with: self.newCarModels?[indexPath.row].iconResource)
        
        cell.lblTypeName.text = self.newCarModels?[indexPath.row].typeName?.capitalized
       
        if self.newCarModels?[indexPath.row].isPromoApplied ?? false {
            cell.lblPromoAmount.text = (self.currency ?? "") + " " + (self.newCarModels?[indexPath.row].promoTotalAmount ?? "")
            cell.lblPromoAmount.isHidden = false
            
            let attributedText = NSAttributedString(
                string: (self.currency ?? "") + " " + (self.newCarModels?[indexPath.row].totalAmount ?? ""),
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            cell.lblAmount.attributedText = attributedText
        } else {
            cell.lblPromoAmount.isHidden = true
            let attrText = NSAttributedString(string: (self.currency ?? "") + " " + (self.newCarModels?[indexPath.row].totalAmount ?? ""), attributes: nil)
            cell.lblAmount.attributedText = attrText
        }
     
        if self.selectedNewCarModel == self.newCarModels?[indexPath.row] {
            cell.viewContent.layer.borderColor = UIColor.themeColor.cgColor
            cell.viewContent.addShadow()
        } else {
            cell.viewContent.layer.borderColor = UIColor.secondaryColor.cgColor
            cell.viewContent.removeShadow()
        }
        
        cell.btnFareDetails.tag = indexPath.row
        cell.btnFareDetails.addTarget(self, action: #selector(goToFareDetails(_ :)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedNewCarModel = self.newCarModels?[indexPath.row]
        self.typesView.tblTypes.reloadData()
        
    }
    
}

//MARK: - API'S
extension TypesVC {
    
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
                            if self.selectedPaymentType == "" {
                                if let paymentTypes = data["payment_types"] as? [String] {
                                    self.paymentTypes = paymentTypes
                                    self.selectedPaymentType = self.paymentTypes.first ?? ""
                                    self.typesView.lblPayment.text = self.selectedPaymentType
                                }
                            }
                            
                            if let typeList = data["zone_type_price"] as? [[String: AnyObject]] {
                                self.newCarModels = typeList.compactMap({NewCarModel($0)})
                                
                                if !(self.newCarModels?.isEmpty ?? false) {
                                    if self.selectedNewCarModel == nil {
                                        self.selectedNewCarModel = self.newCarModels?.first
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.typesView.tblTypes.reloadData()
                                    }
                                    
                                    
                                    if (self.newCarModels?.count ?? 0) >= 3 {
                                        let height = 3 * 75
                                        self.typesView.containerDefaultHeight = CGFloat(186 + height)
                                        self.typesView.containerCurrentHeight = CGFloat(186 + height)
                                        self.typesView.containerHeightConstraint?.constant = CGFloat(186 + height)
                                     
                                    } else {
                                        let height = (self.newCarModels?.count ?? 0) * 75
                                        self.typesView.containerDefaultHeight = CGFloat(186 + height)
                                        self.typesView.containerCurrentHeight = CGFloat(186 + height)
                                        self.typesView.containerHeightConstraint?.constant = CGFloat(186 + height)
                                     
                                    }
                                     
                                }
                            }
                        }
                    } else {
                        self.typesView.errorView.isHidden = false
                        if response.response?.statusCode == 401 {
                            self.forceLogout()
                        }else if response.response?.statusCode == 400 {
                            self.typesView.lblErrorMsg.text = "txt_bad_request"
                        } else if response.response?.statusCode == 403 {
                            self.typesView.lblErrorMsg.text = "txt_you_are_blocked".localize()
                                .uppercased()
                        } else {
                            self.typesView.lblErrorMsg.text = "txt_no_service_available"
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
            paramDict["payment_opt"] = self.selectedPaymentType
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
                                        vc.callback = {[unowned self] tripData, isAccepted in
                                            if isAccepted {
                                                self.deinitialize()
                                                let vc = TripVC()
                                                vc.tripstatusfromripdict = tripData
                                                if self.navigationController?.topViewController is TypesVC {
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                }
                                            } else {
                                                self.view.showToast("txt_no_driver_found".localize())
                                            }
                                        }
                                        self.present(vc, animated: true, completion: nil)
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
                case .failure(_):
                    self.view.showToast("txt_sry_unable_to_process_request".localize())
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
            
            paramDict["pick_lat"] = self.selectedPickUpLocation?.latitude
            paramDict["pick_lng"] = self.selectedPickUpLocation?.longitude
            paramDict["pick_address"] = self.selectedPickUpLocation?.placeId
            paramDict["drop_lat"] = self.selectedDropLocation?.latitude
            paramDict["drop_lng"] = self.selectedDropLocation?.longitude
            paramDict["drop_address"] = self.selectedDropLocation?.placeId
            paramDict["vehicle_type"] = self.selectedNewCarModel?.typeId
            paramDict["payment_opt"] = self.selectedPaymentType
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = dateFormatter.string(from: date)
            paramDict["trip_start_time"] = dateStr
            
            paramDict["is_later"] = "1"
            if self.selectedStopLocationParam?.count != 0 {
                do {
                    let jsonData = try JSONEncoder().encode(self.selectedStopLocationParam)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        paramDict["stops"] = jsonString
                    }
                } catch { print(error) }
            }
            
            let url = APIHelper.shared.BASEURL + APIHelper.createRequest
            
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any, response.response?.statusCode as Any)
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
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first,let legs = route["legs"] as? [[String:AnyObject]], let legFirst = legs.first, let data = legFirst["distance"] as? [String: AnyObject] {
                            if let distance = data["text"] as? String {
                                self.dropMarkerView.viewDistance.isHidden = false
                                self.dropMarkerView.lblDistance.text = distance
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
                                self.dropMarkerView.viewDistance.isHidden = false
                                self.dropMarkerView.lblDistance.text = distance
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
        
        self.animatedPolyline = AnimatedPolyLine(points,repeats:true)
        
        let path = GMSPath(fromEncodedPath: points)
        let bounds = GMSCoordinateBounds(path: path!)
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 20, left: 70, bottom: 20, right: 70))
        self.typesView.mapview.moveCamera(update)
        self.animatedPolyline?.map = self.typesView.mapview
        
        let psth = GMSPath(fromEncodedPath: points)
        
        if let path = psth {
            let distanceInKm = GMSGeometryLength(path) / 1000.0
            self.dropMarkerView.viewDistance.isHidden = false
            self.dropMarkerView.lblDistance.text = String(format: "%.1f", distanceInKm) + " km"
        }
        if let coord1 = path?.coordinate(at: 0) {
            let marker = GMSMarker()
            marker.position = coord1
            
            self.pickupMarkerView.lblPickupAddress.text = self.selectedPickUpLocation?.placeId
            marker.isTappable = true
            marker.iconView = self.pickupMarkerView
            marker.isFlat = true
            marker.map = self.typesView.mapview
            
        }
        if let coord2 = path?.coordinate(at: (psth?.count() ?? 0)-1) {
            let marker = GMSMarker()
            marker.position = coord2
            
            self.dropMarkerView.lblDropAddress.text = self.selectedDropLocation?.placeId
            marker.iconView = self.dropMarkerView
            marker.isFlat = true
            marker.map = self.typesView.mapview
            
        }
        
        if self.selectedStopLocation != nil {
            let stopMarker = GMSMarker()
            if let location = self.selectedStopLocation {
                stopMarker.position = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            }
            stopMarker.title = self.selectedStopLocation?.placeId
            stopMarker.map = typesView.mapview
            typesView.mapview.selectedMarker = stopMarker
        }
    }
    
    func setMapBoundsWithoutPath() {
        
        var markers = [GMSMarker]()
        if let coord1 = self.selectedPickUpLocation?.coordinate {
            let marker = GMSMarker()
            marker.position = coord1
            
            self.pickupMarkerView.lblPickupAddress.text = self.selectedPickUpLocation?.placeId
            marker.isTappable = true
            marker.iconView = self.pickupMarkerView
            marker.isFlat = true
            marker.map = self.typesView.mapview
            
            markers.append(marker)
        }
        if let coord2 = self.selectedDropLocation?.coordinate {
            let marker = GMSMarker()
            marker.position = coord2
            
            self.dropMarkerView.lblDropAddress.text = self.selectedDropLocation?.placeId
            marker.iconView = self.dropMarkerView
            marker.isFlat = true
            marker.map = self.typesView.mapview
            markers.append(marker)
        }
        
        if self.selectedStopLocation != nil {
            let stopMarker = GMSMarker()
            if let location = self.selectedStopLocation {
                stopMarker.position = CLLocationCoordinate2D(latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
            }
            stopMarker.title = self.selectedStopLocation?.placeId
            stopMarker.map = typesView.mapview
            typesView.mapview.selectedMarker = stopMarker
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

// MARK:- response received from firebase observers
extension TypesVC: MyFirebaseDelegate {
    
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
           
            showFirebaseCarMarkers()
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
            
            showFirebaseCarMarkers()
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
                        
                        showFirebaseCarMarkers()
                    }
                  
                }

            }
            calculateEtaForType()
        }
    }
    
    func showFirebaseCarMarkers() {
        self.driverPins.forEach({
            $0.value.map = nil
            FirebaseObserver.shared.removeObserverFor($0.key)
        })
        
        self.driverPins.forEach({
            let driverId = $0.key
            let driverData = driverDatas[driverId]!
            
            if let typeId = driverData["type"] {
                let typeIdInt = "\(typeId)"
                if self.selectedNewCarModel != nil {
                    
                    if self.selectedNewCarModel?.typeId == typeIdInt {
                        let driverPinNow = $0.value
                        driverPinNow.map = typesView.mapview
                        
                        FirebaseObserver.shared.addObserverFor(driverId)
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
                   let typedIdInt = "\(typeId)"
                    if typedIdInt == self.selectedNewCarModel?.typeId {
                    
                        let driverLocation = driverData["l"] as? [Double]
                        let driver_lat = driverLocation![0]
                        let driver_lng = driverLocation![1]
                        
                        let driverLoc = CLLocation(latitude: driver_lat, longitude: driver_lng)
                        
                       
                        let pickLocation = CLLocation.init(latitude: self.selectedPickUpLocation?.coordinate?.latitude ?? 0, longitude: self.selectedPickUpLocation?.coordinate?.longitude ?? 0)
                        
                        let distance = driverLoc.distance(from: pickLocation)/1000
                        
                        let time = distance/50
                        let arrivalTime = time*60
                        let actualTime = arrivalTime.rounded()
                        
                        timeList.append(Int(actualTime))
                       
                        if let minTime = timeList.min() {
                            
                            if minTime <= 1 {
                                let mins = " " + "1 " + "txt_min".localize()
                                self.pickupMarkerView.lblEta.text = mins
                            } else if minTime < 60 {
                                let mins = " " + "\(minTime)" + " " + "txt_min".localize()
                                self.pickupMarkerView.lblEta.text = mins
                                
                            } else {
                                let hours = minTime / 60
                                let minutes = minTime % 60
                                
                                let mins = " " + "\(hours) " + "txt_hr".localize() +  "\(minutes) " + "txt_min".localize()
                                self.pickupMarkerView.lblEta.text = mins
                            }
                            
                        }
                        
                    } 
                }
                
            })
        }

    }
    
}

//MARK:- MARKER DELEGATES

extension TypesVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker == self.pickupMarkerView {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        return true
    }
}

/*
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
*/
