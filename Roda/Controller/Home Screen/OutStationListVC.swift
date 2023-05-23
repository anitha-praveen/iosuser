//
//  OutStationListVC.swift
//  Roda
//
//  Created by Apple on 20/04/22.
//

import UIKit
import Alamofire
import GoogleMaps
import Kingfisher
class OutStationListVC: UIViewController {

    private let outStationView = OutStationListView()
    
    var selectedLocation: SearchLocation?
    
    private var outStationList = [OutstationList]()
    private var filteredOutstationList = [OutstationList]()
    
    var selectedOutstation: OutstationList?
    
    var outStationTypes = [OutstationTypes]()
    var selectedStationType: OutstationTypes?
    
    var selectedPromo: String?
    var rideLaterDate: Date?
    var rideLaterFromDate: Date?
    var rideLaterReturnDate: Date?
    var selectedPaymentType = "CASH"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        outStationView.setupViews(Base: self.view)
        setupMap()
        setupDelegates()
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getOutStationList()
    }
    
    func setupTarget() {
        outStationView.btnBack.addTarget(self, action: #selector(backBtnPressed(_:)), for: .touchUpInside)
        
        outStationView.btnOneWayRide.addTarget(self, action: #selector(btnRideTypePressed(_:)), for: .touchUpInside)
        outStationView.btnReturnRide.addTarget(self, action: #selector(btnRideTypePressed(_:)), for: .touchUpInside)
        
        outStationView.btnDropDown.addTarget(self, action: #selector(showLists), for: .touchUpInside)
        outStationView.dropTxt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLists)))
        
        outStationView.txtTitle.addTarget(self, action: #selector(searchCities(_ :)), for: .editingChanged)
        
        outStationView.btnEditLocation.addTarget(self, action: #selector(btnEditLocationPressed(_ :)), for: .touchUpInside)
        outStationView.btnApplyPromo.addTarget(self, action:#selector(gotoPromo(_ :)) , for: .touchUpInside)
        
        outStationView.viewBookRide.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookRideRequestPressed(_ :))))
        outStationView.viewDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnCalenderPressed(_ :))))
        outStationView.btnPaymentMode.addTarget(self, action: #selector(changePayment(_ :)), for: .touchUpInside)
        outStationView.btnFareDetail.addTarget(self, action: #selector(btnFareDetailPressed(_ :)), for: .touchUpInside)
        
        
        outStationView.lblFromDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseDate(_ :))))
        outStationView.lblReturnDate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseDate(_ :))))
    }
    
    func setupDelegates() {
        outStationView.tblOutstationList.delegate = self
        outStationView.tblOutstationList.dataSource = self
        outStationView.tblOutstationList.register(UITableViewCell.self, forCellReuseIdentifier: "outstationcell")
        
        
        outStationView.collectionvw.delegate = self
        outStationView.collectionvw.dataSource = self
        outStationView.collectionvw.register(OutStationTypesCollectionCell.self, forCellWithReuseIdentifier: "OutStationTypesCollectionCell")
    }
    
    func setupMap() {
        self.outStationView.txtLocation.text = self.selectedLocation?.placeId
        if let selectedLoc = self.selectedLocation?.coordinate {
            let camera = GMSCameraPosition.camera(withTarget: selectedLoc, zoom: 15)
            self.outStationView.mapview.camera = camera
            
        }
    }

}

//MARK: - TARGET ACTIONS
extension OutStationListVC {
    @objc func backBtnPressed(_ sender: UIButton) {
        if self.outStationView.listView.isHidden == false {
            UIView.animate(withDuration: 1) {
                self.outStationView.txtTitle.isUserInteractionEnabled = false
                self.outStationView.txtTitle.text = "txt_outstation".localize()
                self.outStationView.listView.isHidden = true
            }
        } else if self.outStationView.viewContent.isHidden == false && self.outStationView.txtTitle.isUserInteractionEnabled == true {
            UIView.animate(withDuration: 1) {
                self.outStationView.txtTitle.isUserInteractionEnabled = false
                self.outStationView.txtTitle.text = "txt_outstation".localize()
                self.outStationView.viewContent.isHidden = true
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func btnRideTypePressed(_ sender: UIButton) {
        sender.isSelected = true
        if sender == outStationView.btnOneWayRide {
            
            outStationView.btnOneWayRide.backgroundColor = .themeColor
            outStationView.btnReturnRide.backgroundColor = .hexToColor("F4F4F4")
            outStationView.btnReturnRide.isSelected = false
            
            self.outStationView.viewTripDate.isHidden = true
            
            self.getOutstaionTypes(self.selectedOutstation?.id ?? "")
        } else {
            outStationView.btnReturnRide.backgroundColor = .themeColor
            outStationView.btnOneWayRide.backgroundColor = .hexToColor("F4F4F4")
            outStationView.btnOneWayRide.isSelected = false
            
            self.outStationView.viewTripDate.isHidden = false
            
            self.rideLaterFromDate = Date().addingTimeInterval(TimeInterval(30 * 60))
            let currDate = Date().addingTimeInterval(TimeInterval(30 * 60))
            let dFormatter = DateFormatter()
            dFormatter.dateFormat = "MMM,dd hh:mm a"
            self.outStationView.lblFromDate.text = dFormatter.string(from: currDate)
            
            self.rideLaterReturnDate = Date().addingTimeInterval(TimeInterval(180 * 60))
            let date = Date().addingTimeInterval(TimeInterval(180 * 60))
            dFormatter.dateFormat = "MMM,dd"
            self.outStationView.lblReturnDate.text = "-- " + dFormatter.string(from: date) + " (Return date)"
            
            self.getOutstaionTypes(self.selectedOutstation?.id ?? "")
            
        }
        
    }
    
    @objc func showLists() {
        UIView.animate(withDuration: 1) {
            self.outStationView.txtTitle.isUserInteractionEnabled = true
            self.outStationView.txtTitle.text = ""
            self.outStationView.listView.isHidden = false
        }
    }
    
    @objc func searchCities(_ sender: UITextField) {
        
        if let searchText = sender.text {
            if searchText == "" {
                self.filteredOutstationList = self.outStationList
                self.outStationView.tblOutstationList.reloadData()
            } else {
                self.filteredOutstationList = self.outStationList.filter({($0.cityName?.localizedCaseInsensitiveContains(searchText) ?? false)})
                self.outStationView.tblOutstationList.reloadData()
            }
        }
    }
    
    @objc func btnEditLocationPressed(_ sender: UIButton) {
        let vc = SearchLocationVC()
        vc.titleText = "txt_choose_pickup".localize()
        vc.selectedLocation = { [weak self] selectedSearchLoc in
            self?.selectedLocation = selectedSearchLoc
            self?.outStationView.txtLocation.text = selectedSearchLoc.placeId
            if let lat = selectedSearchLoc.latitude, let long = selectedSearchLoc.longitude {
                self?.outStationView.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
            }
            self?.getOutstaionTypes(self?.selectedOutstation?.id ?? "")
        }
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    @objc func changePayment(_ sender: UIButton) {

        self.view.showToast("txt_only_cashmode_available".localize())
    }
    
    @objc func gotoPromo(_ sender: UIButton) {
        let promoVC = PromoVC()
        promoVC.selectedPromo = self.selectedPromo
        promoVC.tripType = "OUTSTATION"
        promoVC.callBack = { [unowned self] selectedPromo in
            self.selectedPromo = selectedPromo
            self.getOutstaionTypes(self.selectedOutstation?.id ?? "")
            self.outStationView.btnApplyPromo.setTitle("text_promo_applied".localize(), for: .normal)
            
        }
        promoVC.promoCancelledClouser = {[weak self] cancelled in
            if cancelled {
                self?.selectedPromo = nil
                self?.getOutstaionTypes(self?.selectedOutstation?.id ?? "")
                self?.outStationView.btnApplyPromo.setTitle("txt_coupon".localize().localize(), for: .normal)
            }
            
        }
        self.navigationController?.pushViewController(promoVC, animated: true)
    }
    
    @objc func btnFareDetailPressed(_ sender: UIButton) {
        let vc = OutstationFareDetailsVC()
        vc.selectedStation = self.selectedOutstation
        vc.selectedStationTypes = self.selectedStationType
        vc.isTwoWayTrip = self.outStationView.btnReturnRide.isSelected
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func bookRideRequestPressed(_ sender: UITapGestureRecognizer) {
        if self.outStationView.btnOneWayRide.isSelected {
            if self.rideLaterDate == nil {
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
                        
                        self?.outStationView.lblBookRide.textAlignment = APIHelper.appTextAlignment
                        self?.outStationView.viewDate.isHidden = false
                        
                        self?.outStationView.lblDate.text = dateStr + "\n" + timeStr
                        
                        self?.getOutstaionTypes(self?.selectedOutstation?.id ?? "")
                        
                        self?.outStationView.lblBookRide.text = "text_schedule".localize() + " " + (self?.selectedStationType?.vehicleName ?? "")
                        
                    } else if type == .now {
                        self?.rideLaterDate = nil
                        
                        self?.outStationView.lblDate.text = "txt_now".localize()
                        self?.outStationView.lblBookRide.text = "txt_book_now".localize() + " " + (self?.selectedStationType?.vehicleName ?? "")
                        self?.outStationView.lblBookRide.textAlignment = .center
                        self?.outStationView.viewDate.isHidden = true
                    }
                    
                }
                
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                /*
                let alert = UIAlertController(title: "txt_info".localize(), message: "txt_both_up_down_desc".localize(), preferredStyle: .actionSheet)
                let okbtn = UIAlertAction(title: "text_ok".localize().uppercased(), style: .default) { action in
                    self.rideLaterRequest()
                }
                let cancelbtn = UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil)
                alert.addAction(okbtn)
                alert.addAction(cancelbtn)
                self.present(alert, animated: true, completion: nil)
                */
                self.rideLaterRequest()
            }
        } else {
            if self.rideLaterReturnDate == nil {
                self.showAlert("", message: "Choose return date")
            } else {
                self.rideLaterRequest()
            }
        }
    }
    
    @objc func chooseDate(_ sender: UITapGestureRecognizer) {
        let vc = RideDatePickerVC()
        if sender.view == outStationView.lblFromDate {
            if let date = self.rideLaterFromDate {
                vc.selectedDate = date
            }
        } else if sender.view == outStationView.lblReturnDate {
            if let date = self.rideLaterReturnDate {
                vc.selectedDate = date
                vc.isForReturnDate = true
            }
        }
        
        vc.callBack = {[weak self] date, type in
            
            if type == .later {
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM,dd"
                let dateStr = dateFormatter.string(from: date)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm a"
                let timeStr = timeFormatter.string(from: date)
                
              
                if sender.view == self?.outStationView.lblFromDate {
                    self?.rideLaterFromDate = date
                    self?.outStationView.lblFromDate.text = dateStr + " " + timeStr
                    
                } else if sender.view == self?.outStationView.lblReturnDate {
                    self?.rideLaterReturnDate = date
                    self?.outStationView.lblReturnDate.text = "--   " + dateStr + " " + timeStr
                    
                    self?.getOutstaionTypes(self?.selectedOutstation?.id ?? "")
                }
                
            } else if type == .now {
                
                if sender.view == self?.outStationView.lblFromDate {
                    self?.rideLaterFromDate = Date().addingTimeInterval(TimeInterval(30 * 60))
                    let dFormatter = DateFormatter()
                    dFormatter.dateFormat = "MMM,dd hh:mm a"
                    self?.outStationView.lblFromDate.text = dFormatter.string(from: Date().addingTimeInterval(TimeInterval(30 * 60)))
                    
                } else if sender.view == self?.outStationView.lblReturnDate {
                    self?.rideLaterReturnDate = nil
                    self?.outStationView.lblReturnDate.text = "--   Return Date"
                    
                    
                }
            }
            
        }
        vc.modalPresentationStyle = .overFullScreen
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
                
                self?.outStationView.lblBookRide.textAlignment = APIHelper.appTextAlignment
                self?.outStationView.viewDate.isHidden = false
                
                
                self?.outStationView.lblDate.text = dateStr + "\n" + timeStr
                
                self?.getOutstaionTypes(self?.selectedOutstation?.id ?? "")
                
                self?.outStationView.lblBookRide.text = "text_schedule".localize() + " " + (self?.selectedStationType?.vehicleName ?? "")
                
            } else if type == .now {
                self?.rideLaterDate = nil
                
                self?.outStationView.lblDate.text = "txt_now".localize()
                self?.outStationView.lblBookRide.text = "text_schedule".localize() + " " + (self?.selectedStationType?.vehicleName ?? "")
                self?.outStationView.lblBookRide.textAlignment = .center
                self?.outStationView.viewDate.isHidden = true
            }
            
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - COLLECTION DELEGATES
extension OutStationListVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.outStationTypes.count == 0 {
            let noData = UILabel()
            noData.textColor = .txtColor
            noData.textAlignment = .center
            noData.text = "txt_no_vehicle_types_found".localize()
            collectionView.backgroundView = noData
        } else {
            collectionView.backgroundView = nil
        }
        return self.outStationTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutStationTypesCollectionCell", for: indexPath) as? OutStationTypesCollectionCell ?? OutStationTypesCollectionCell()
        
        let types = self.outStationTypes[indexPath.row]
        
        cell.lblTypeName.text = types.vehicleName
        if self.outStationView.btnReturnRide.isSelected {
            cell.lblFare.text = (types.currency ?? "") + (types.twoWayDistancePrice ?? "") + "/" + "kms".localize()
        } else {
            cell.lblFare.text = (types.currency ?? "") + (types.distancePrice ?? "") + "/" + "kms".localize()
        }
        
        if self.selectedStationType?.slug == types.slug {
            cell.colorBackground.backgroundColor = .hexToColor("#FDEEAE")
            cell.lblTypeName.textColor = .txtColor
            cell.lblFare.textColor = .txtColor
            if let imgStr = types.vehicleHighlightedImage, let url = URL(string: imgStr) {
                let resource = ImageResource(downloadURL: url)
                cell.imgview.kf.setImage(with: resource)
            }
        } else {
            cell.colorBackground.backgroundColor = .hexToColor("#F4F4F4")
            cell.lblTypeName.textColor = .hexToColor("DADADA")
            cell.lblFare.textColor = .hexToColor("DADADA")
            if let imgStr = types.vehicleImage, let url = URL(string: imgStr) {
                let resource = ImageResource(downloadURL: url)
                cell.imgview.kf.setImage(with: resource)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/4, height: 80)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedStationType = self.outStationTypes[indexPath.row]
        self.outStationView.collectionvw.reloadData()
        if self.rideLaterDate != nil {
            self.outStationView.lblBookRide.text = "text_schedule".localize() + " " + (self.selectedStationType?.vehicleName ?? "")
        } else {
            self.outStationView.lblBookRide.text = "txt_book_now".localize() + " " + (self.selectedStationType?.vehicleName ?? "")
        }
        
        self.setupFareData()
    }
    
}

//MARK: - TABLE DELEGATES
extension OutStationListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredOutstationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "outstationcell") ?? UITableViewCell()
        cell.textLabel?.text = self.filteredOutstationList[indexPath.row].cityName
        if self.selectedOutstation?.id == self.filteredOutstationList[indexPath.row].id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedOutstation = self.filteredOutstationList[indexPath.row]
        self.filteredOutstationList = self.outStationList
        self.outStationView.tblOutstationList.reloadData()
        self.getOutstaionTypes(self.selectedOutstation?.id ?? "")
        
        self.outStationView.viewDistanceDetails.isHidden = false
        self.outStationView.collectionvw.isHidden = false
        self.outStationView.viewRideType.isHidden = false
        setupFareData()
        UIView.animate(withDuration: 1) {
            self.outStationView.txtTitle.isUserInteractionEnabled = false
            self.outStationView.txtTitle.text = "txt_outstation".localize()
            self.outStationView.listView.isHidden = true
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func setupFareData() {
        self.outStationView.dropTxt.text = self.selectedOutstation?.cityName
        self.outStationView.lblDistance.text = "txt_distance".localize() + ": " + (self.selectedStationType?.distance ?? "") + "kms".localize()
        let distanceString = "txt_distance".localize() + ": " + (self.selectedStationType?.distance ?? "") + "kms".localize()
        if self.outStationView.btnReturnRide.isSelected {
            self.outStationView.lblDistance.text = distanceString + " (" + (self.selectedStationType?.twoWayDistancePrice ?? "") + "/" + "kms".localize() + " )"
        } else {
            self.outStationView.lblDistance.text = distanceString + " (" + (self.selectedStationType?.distancePrice ?? "") + "/" + "kms".localize() + " )"
        }
        
        if self.selectedStationType?.isPromoApplied ?? false {
            if let amt = self.selectedStationType?.promoTotalAmount {
                self.outStationView.promoHint.isHidden = true
                self.outStationView.lblPromoAmount.isHidden = false
                self.outStationView.lblPromoAmount.font = UIFont.appSemiBold(ofSize: 25)
                self.outStationView.lblAmount.font = UIFont.appSemiBold(ofSize: 13)
                self.outStationView.lblPromoAmount.text = (self.selectedStationType?.currency ?? "") + " " + amt
                let attributedText = NSAttributedString(
                    string: (self.selectedStationType?.currency ?? "") + " " + (self.selectedStationType?.totalAmount ?? ""),
                    attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,.strikethroughColor:UIColor.red]
                )
                self.outStationView.lblAmount.attributedText = attributedText
            } else {
                self.outStationView.promoHint.isHidden = false
                self.outStationView.lblPromoAmount.text = ""
                self.outStationView.lblPromoAmount.isHidden = true
                let attrText = NSAttributedString(string: (self.selectedStationType?.currency ?? "") + " " + (self.selectedStationType?.totalAmount ?? ""), attributes: nil)
                self.outStationView.lblAmount.attributedText = attrText
                self.outStationView.lblAmount.font = UIFont.appSemiBold(ofSize: 25)
            }
        } else {
            self.outStationView.promoHint.isHidden = true
            self.outStationView.lblPromoAmount.text = ""
            self.outStationView.lblPromoAmount.isHidden = true
            self.outStationView.lblAmount.text = (self.selectedStationType?.currency ?? "") + " " + (self.selectedStationType?.totalAmount ?? "")
            self.outStationView.lblAmount.font = UIFont.appSemiBold(ofSize: 25)
        }
        
    }

}

//MARK: - API'S
extension OutStationListVC {
    
    @objc func getOutStationList() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            let url = APIHelper.shared.BASEURL + APIHelper.getOutStationList
           
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    print("Out station list",response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [[String: AnyObject]] {
                            self.outStationList = data.compactMap({OutstationList($0)})
                            self.filteredOutstationList = self.outStationList
                            DispatchQueue.main.async {
                                self.outStationView.tblOutstationList.reloadData()
                            }
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    @objc func getOutstaionTypes(_ id: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String,Any>()
            paramDict["pick_lat"] = self.selectedLocation?.latitude
            paramDict["pick_lng"] = self.selectedLocation?.longitude
            paramDict["outstation_id"] = id
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
            }
            paramDict["trip_way_type"] = self.outStationView.btnReturnRide.isSelected == true ? "TWO" : "ONE"
            
            if self.outStationView.btnReturnRide.isSelected {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = rideLaterFromDate {
                    let dateStr = dateFormatter.string(from: date)
                    paramDict["from_date"] = dateStr
                }
                if let enddate = rideLaterReturnDate {
                    let dateStr = dateFormatter.string(from: enddate)
                    paramDict["to_date"] = dateStr
                }
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = rideLaterDate {
                    let dateStr = dateFormatter.string(from: date)
                    paramDict["from_date"] = dateStr
                    paramDict["to_date"] = dateStr
                } else {
                    let dateStr = dateFormatter.string(from: Date())
                    paramDict["from_date"] = dateStr
                    paramDict["to_date"] = dateStr
                }
            }
            
            let url = APIHelper.shared.BASEURL + APIHelper.getOutStationTypes
           print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                switch response.result {
                case .success(_):
                    print("Out station Types",response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [[String: AnyObject]] {
                            self.outStationTypes = data.compactMap({OutstationTypes($0)})
                            if !self.outStationTypes.isEmpty {
                                if self.selectedStationType == nil {
                                    self.selectedStationType = self.outStationTypes.first
                                    self.setupFareData()
                                } else if self.selectedStationType != nil {
                                    self.selectedStationType = self.outStationTypes.first(where: {$0.slug == self.selectedStationType?.slug})
                                    
                                    self.setupFareData()
                                }
                                
                            }
                            DispatchQueue.main.async {
                                self.outStationView.collectionvw.reloadData()
                            }
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    func rideLaterRequest() {
        
        if ConnectionCheck.isConnectedToNetwork() {

            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            
            paramDict["pick_lat"] = self.selectedLocation?.latitude
            paramDict["pick_lng"] = self.selectedLocation?.longitude
            paramDict["pick_address"] = self.selectedLocation?.placeId
            paramDict["drop_lat"] = self.selectedOutstation?.dropLat
            paramDict["drop_lng"] = self.selectedOutstation?.dropLong
            paramDict["drop_address"] = self.selectedOutstation?.cityName
            paramDict["outstation_id"] = self.selectedOutstation?.id
            paramDict["vehicle_type"] = self.selectedStationType?.slug
            paramDict["payment_opt"] = self.selectedPaymentType
            paramDict["ride_type"] = "OUTSTATION"
            if self.selectedPromo != nil {
                paramDict["promo_code"] = self.selectedPromo
            }
            paramDict["is_later"] = "1"
            paramDict["trip_way_type"] = self.outStationView.btnReturnRide.isSelected == true ? "TWO" : "ONE"
            
            if self.outStationView.btnReturnRide.isSelected {
                if let date = rideLaterFromDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateStr = dateFormatter.string(from: date)
                    paramDict["trip_start_time"] = dateStr
                }
                
                if let enddate = rideLaterReturnDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateStr = dateFormatter.string(from: enddate)
                    paramDict["trip_end_time"] = dateStr
                }
            } else {
                if let date = rideLaterDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateStr = dateFormatter.string(from: date)
                    paramDict["trip_start_time"] = dateStr
                }
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
                            self.callForInstantBooking()
                            /*
                            if let error = result["data"] as? [String:[String]] {
                                let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                self.showAlert("", message: errMsg)
                            } else if let errMsg = result["error_message"] as? String {
                                self.showAlert("", message: errMsg)
                            } else if let msg = result["message"] as? String {
                                self.showAlert("", message: msg)
                            }
                            */
                        }
                    }
                case .failure(_):
                    self.callForInstantBooking()
                }
            }
        } else {
            self.showAlert("", message: "txt_NoInternet_title".localize())
        }
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
