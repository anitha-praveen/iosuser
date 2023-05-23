//
//  InvoiceVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 07/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Kingfisher
import HCSStarRatingView
import Razorpay

class InvoiceVC: UIViewController {
    
    let invoiceView = InvoiceView()
    var currency: String = ""
    var tripinvoicedetdict = [String:AnyObject]()
    
    var invoiceDetails:[(key:String,value:String,note:String?,textColor:UIColor)] = []
    
    var totalAmount = Double()
    var requestId: String?
    var razorpay: RazorpayCheckout?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
      
        self.setUpViews()
        self.setupData()
        setupDriverData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MySocketManager.shared.socketDelegate = self
    }
    
    
    func setUpViews() {
        invoiceView.setupViews(Base: self.view)
        invoiceView.conformBtn.addTarget(self, action: #selector(conformBtnPressed(_ :)), for: .touchUpInside)
        invoiceView.payBtn.addTarget(self, action: #selector(payBtnPressed(_ :)), for: .touchUpInside)
    }
    
}

extension InvoiceVC {
    func setupData() {
        
        if let reqId = tripinvoicedetdict["id"] as? String {
            self.requestId = reqId
        }
        
        if  let invoicedict = tripinvoicedetdict["requestBill"] as? [String:AnyObject], let invoiceData = invoicedict["data"] as? [String: AnyObject], let currency = invoiceData["requested_currency_symbol"] as? String {
            
            if let total = invoiceData["total_amount"] {
                self.totalAmount = Double("\(total)") ?? 0
            }
            
            if let serviceCategory = tripinvoicedetdict["service_category"] as? String, serviceCategory == "OUTSTATION" {
                if let baseprice = invoiceData.getInAmountFormat(str: "base_price") {
                    if let tripType = tripinvoicedetdict["outstation_trip_type"] as? String, tripType == "ONE" {
                        invoiceDetails.append((key: "txt_driver_beta".localize(), value: currency + " " + baseprice, note: nil, textColor: .hexToColor("525151")))
                    } else {
                        invoiceDetails.append((key: "txt_day_rent".localize(), value: currency + " " + baseprice, note: nil, textColor: .hexToColor("525151")))
                    }
                    
                }
                
                if let distancecost = invoiceData.getInAmountFormat(str: "distance_price"){
                    if let totalkm = invoiceData.getInAmountFormat(str: "total_distance"), let pricePerDist = invoiceData.getInAmountFormat(str: "price_per_distance") {
                        
                        if let tripType = tripinvoicedetdict["outstation_trip_type"] as? String, tripType == "ONE" {
                            invoiceDetails.append((key: "text_distance_cost".localize(),
                                                   value: currency + " " +  distancecost,
                                                   note: "(\(totalkm) km * \(pricePerDist))", textColor: .hexToColor("525151")))
                        } else {
                            invoiceDetails.append((key: "text_distance_cost".localize(),
                                                   value: currency + " " +  distancecost,
                                                   note: "(\(totalkm) km * \(pricePerDist))", textColor: .hexToColor("525151")))
                        }
                        
                    } else {
                        invoiceDetails.append((key: "text_distance_cost".localize(),
                                               value: currency + " " +  distancecost,
                                               note: nil, textColor: .hexToColor("525151")))
                    }
                    
                }
                
                if let timecost = invoiceData.getInAmountFormat(str: "time_price") {
                    invoiceDetails.append((key: "text_time_cost".localize(),
                                           value: currency + " " + timecost,
                                           note: nil, textColor: .hexToColor("525151")))
                    
                }
            } else if let serviceCategory = tripinvoicedetdict["service_category"] as? String, serviceCategory == "RENTAL" {
                if let baseprice = invoiceData.getInAmountFormat(str: "base_price") {
                    if let hrs = invoiceData["package_hours"], let kms = invoiceData["package_km"] {
                        invoiceDetails.append((key: "txt_package_cost".localize(), value: currency + " " + baseprice, note: "(\(hrs) hr \(kms) km)", textColor: .hexToColor("525151")))
                    } else {
                        invoiceDetails.append((key: "txt_package_cost".localize(), value: currency + " " + baseprice, note: nil, textColor: .hexToColor("525151")))
                    }
                }
                
                if let distancecost = invoiceData.getInAmountFormat(str: "distance_price"){
                    if let pendingKm = invoiceData["pending_km"], let pricePerDist = invoiceData["price_per_distance"] {
                        invoiceDetails.append((key: "txt_extra_distance_cost".localize(),
                                               value: currency + " " +  distancecost,
                                               note: "(\(pendingKm) km * \(pricePerDist))", textColor: .hexToColor("525151")))
                    } else {
                        invoiceDetails.append((key: "text_distance_cost".localize(),
                                               value: currency + " " +  distancecost,
                                               note: nil, textColor: .hexToColor("525151")))
                    }
                }
                
                if let timecost = invoiceData.getInAmountFormat(str: "time_price") {
                    invoiceDetails.append((key: "txt_extra_time_cost".localize(),
                                           value: currency + " " + timecost,
                                           note: nil, textColor: .hexToColor("525151")))
                    
                }
            } else {
                if let baseprice = invoiceData.getInAmountFormat(str: "base_price") {
                    invoiceDetails.append((key: "text_base_price".localize(), value: currency + " " + baseprice, note: nil, textColor: .hexToColor("525151")))
                }
                
                if let distancecost = invoiceData.getInAmountFormat(str: "distance_price"){
                    invoiceDetails.append((key: "text_distance_cost".localize(),
                                           value: currency + " " +  distancecost,
                                           note: nil, textColor: .hexToColor("525151")))
                }
                
                if let timecost = invoiceData.getInAmountFormat(str: "time_price") {
                    invoiceDetails.append((key: "text_time_cost".localize(),
                                           value: currency + " " + timecost,
                                           note: nil, textColor: .hexToColor("525151")))
                    
                }
            }


            
           
            if let waitingprice = invoiceData.getInAmountFormat(str: "waiting_charge") {
                invoiceDetails.append((key: "waiting_time_price".localize(), value: currency + " "  + waitingprice, note: nil, textColor: .hexToColor("525151")))
            }
            
            if let hillPrice = invoiceData.getInAmountFormat(str: "hill_station_price") {
                invoiceDetails.append((key: "txt_hill_price".localize(), value: currency + " "  + hillPrice, note: nil, textColor: .hexToColor("525151")))
            }
            
            if let referralbonus = invoiceData.getInAmountFormat(str: "referral_amount") {
                invoiceDetails.append((key: "text_referral_bonus".localize(), value: "- \(currency) " + referralbonus, note: nil, textColor: UIColor.red))
            }
            if let promobonus = invoiceData.getInAmountFormat(str: "promo_discount") {
                invoiceDetails.append((key: "text_promo_bonus".localize(),
                                       value: "- \(currency) " + promobonus, note: nil, textColor: UIColor.red))
            }
            if let outZone = invoiceData.getInAmountFormat(str: "out_of_zone_price") {
                invoiceDetails.append((key: "text_zone_fees".localize(),
                                       value: currency + " " + outZone, note: nil, textColor: .hexToColor("525151")))
            }
            if let bookingFee = invoiceData.getInAmountFormat(str: "booking_fees") {
                invoiceDetails.append((key: "txt_booking_fee".localize(),
                                       value: currency + " " + bookingFee, note: nil, textColor: .hexToColor("525151")))
            }
            
            
            if let cancellationFeeStr = invoiceData.getInAmountFormat(str: "cancellation_fee") , let cancellationFee = Double("\(cancellationFeeStr)") {
                if  let total = invoiceData["total_amount"] as? Double {
                    let val = total - cancellationFee
                    
                    invoiceDetails.append((key:"text_total_feeCost".localize(),
                                           value: currency + " " +  String(format: "%.2f", val) + " +", note: nil, textColor:.hexToColor("525151")))
                }
                invoiceDetails.append((key:"text_cancellation_fee".localize(),
                                       value: currency + " " +  String(format: "%.2f", cancellationFee), note: nil, textColor:UIColor.darkGreen))
                
            }
            if let servicetax = invoiceData.getInAmountFormat(str: "service_tax") {
                invoiceDetails.append((key: "text_setvice_tax".localize() + "txt_includes".localize(),
                                       value: currency + " " + servicetax, note: nil, textColor: .hexToColor("525151")))
            }
            
            if let paymenttype = tripinvoicedetdict["payment_opt"] as? String {
                
                if paymenttype == "Wallet" {
                    if let walletAmount = invoicedict["wallet_amount"] as? Double {
                        invoiceDetails.append((key: "txt_wallet_deduction".localize(), value: currency + String(format: "%.2f", walletAmount), note: nil, textColor: UIColor.darkGray))
                    }
                }
            }
            
            if let picklocation = tripinvoicedetdict["pick_address"] as? String {
                self.invoiceView.pickupaddrlbl.text = picklocation
            }
            if let droplocation = tripinvoicedetdict["drop_address"] as? String {
                self.invoiceView.dropupaddrlbl.text = droplocation
            }
          
            
            if let distance = tripinvoicedetdict["total_distance"], let unit = tripinvoicedetdict["unit"] as? String {
                self.invoiceView.lblDistance.text = "\(distance)" + unit
            }
            if let time = tripinvoicedetdict["total_time"]  {
                
                if let minTime = Int("\(time)") {
                    if minTime <= 1 {
                        let mins = " " + "1 " + "txt_min".localize()
                        self.invoiceView.tripTimeLbl.text = mins
                    } else if minTime < 60 {
                        let mins = " " + "\(minTime) " + "txt_min".localize()
                        self.invoiceView.tripTimeLbl.text = mins
                        
                    } else {
                        let hours = minTime / 60
                        let minutes = minTime % 60
                        
                        let mins = " " + "\(hours) " + "txt_hr".localize() + "\(minutes) " + "txt_min".localize()
                        self.invoiceView.tripTimeLbl.text = mins
                    }
                } else {
                    self.invoiceView.tripTimeLbl.text = "\(time)" + "txt_min".localize()
                }
            }
            if let time = tripinvoicedetdict["trip_start_time"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                if let date = dateFormatter.date(from: time) {
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    self.invoiceView.dateLbl.text = dateFormatter.string(from: date)
                    dateFormatter.dateFormat = "hh:mm a"
                    self.invoiceView.timeLbl.text = dateFormatter.string(from: date)
                
                }
            }
            
            if let endTime = tripinvoicedetdict["completed_at"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                if let date = dateFormatter.date(from: endTime) {
                    dateFormatter.dateFormat = "hh:mm a"
                    self.invoiceView.endTimeLbl.text = dateFormatter.string(from: date)
                }
                
                if let serviceCategory = tripinvoicedetdict["service_category"] as? String, serviceCategory == "OUTSTATION" {
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    if let date = dateFormatter.date(from: endTime) {
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        self.invoiceView.endTimeLbl.text = dateFormatter.string(from: date)
                        dateFormatter.dateFormat = "hh:mm a"
                        self.invoiceView.tripTimeLbl.text = dateFormatter.string(from: date)
                        
                    }
                }
            }
            
            if let total = invoiceData.getInAmountFormat(str: "total_amount"), let currency = invoiceData["requested_currency_symbol"] as? String {
                
                invoiceView.totalValueLbl.text = currency + " " + total
                invoiceView.lblTripAmount.text = currency + " " + total
            }
            
            
        }
       
        self.invoiceDetails.forEach({
            let viewData = UIView()
            let lbl = UILabel()
            lbl.text = $0.key
            lbl.textColor = $0.textColor
            lbl.font = UIFont.appRegularFont(ofSize: 14)
            lbl.textAlignment = APIHelper.appTextAlignment
            lbl.translatesAutoresizingMaskIntoConstraints = false
            viewData.addSubview(lbl)
            
            let lblValue = UILabel()
            lblValue.text = $0.value
            lblValue.textColor = $0.textColor
            lblValue.font = UIFont.appBoldFont(ofSize: 16)
            lblValue.textAlignment = APIHelper.appTextAlignment
            lblValue.translatesAutoresizingMaskIntoConstraints = false
            viewData.addSubview(lblValue)
            
            
            if $0.note != nil {
                
                let stackNote = UIStackView()
                stackNote.axis = .vertical
                stackNote.distribution = .fill
                stackNote.translatesAutoresizingMaskIntoConstraints = false
                viewData.addSubview(stackNote)
                
                let lblNote = UILabel()
                if $0.note != nil {
                    lblNote.text = $0.note
                    lblNote.isHidden = false
                } else {
                    lblNote.isHidden = true
                }
                lblNote.textColor = $0.textColor
                lblNote.font = UIFont.appRegularFont(ofSize: 13)
                lblNote.textAlignment = APIHelper.appTextAlignment
                lblNote.translatesAutoresizingMaskIntoConstraints = false
                stackNote.addArrangedSubview(lblNote)
            
                self.invoiceView.stackBill.addArrangedSubview(viewData)
                
                viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lbl]-8-[lblValue]-8-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
                lblValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl(30)][stackNote]-8-|", options: [], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue,"stackNote":stackNote]))
                
                viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[stackNote]-8-|", options: [], metrics: nil, views: ["stackNote":stackNote]))
                
                lblNote.heightAnchor.constraint(equalToConstant: 20).isActive = true
            } else {
                
                self.invoiceView.stackBill.addArrangedSubview(viewData)
                
                viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lbl]-8-[lblValue]-8-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
                lblValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl(30)]-8-|", options: [], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
                
            }
            
            
        })
        
        if let serviceCategory = tripinvoicedetdict["service_category"] as? String, serviceCategory == "OUTSTATION" || serviceCategory == "RENTAL" {
            if let startkm = tripinvoicedetdict["start_km"] {
                self.invoiceView.lblOutstationStartkmValue.text = "\(startkm)"
            }
            if let endkm = tripinvoicedetdict["end_km"] {
                self.invoiceView.lblOutstationEndkmValue.text = "\(endkm)"
            }
            self.invoiceView.viewOutstationDetail.isHidden = false
        } else {
            self.invoiceView.viewOutstationDetail.isHidden = true
        }
    }
    
    func setupDriverData() {
        
        if let driverdictdet = tripinvoicedetdict["driver"] as? [String:AnyObject] {
            if let firstName = driverdictdet["firstname"] as? String{
                let str = firstName
                self.invoiceView.drivernamelbl.text = str.localizedCapitalized
            }
 
            if let imgStr = driverdictdet["profile_pic"] as? String, let url = URL(string: imgStr) {
                self.invoiceView.driverprofilepicture.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                self.invoiceView.driverprofilepicture.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                self.invoiceView.driverprofilepicture.image = UIImage(named: "profilePlaceHolder")
            }
            
// Using S3
//            if let imgStr = driverdictdet["profile_pic"] as? String {
//                self.retriveImg(key: imgStr) { data in
//                    self.invoiceView.driverprofilepicture.image = UIImage(data: data)
//                }
//            } else {
//                self.invoiceView.driverprofilepicture.image = UIImage(named: "theme_profile_placeholder")
//            }
        }
        
        if let typeName = tripinvoicedetdict["vehicle_name"] as? String {
            self.invoiceView.lblVehicleTypeName.text = typeName
        }
        if let vehicleNum = tripinvoicedetdict["vehicle_number"] as? String {
            self.invoiceView.lblVehicleNumber.text =  vehicleNum.localizedCapitalized
        }
        
        if let vehicleImage = tripinvoicedetdict["vehicle_highlight_image"] as? String {
            if let url = URL(string: vehicleImage) {
                let resource = ImageResource(downloadURL: url)
                self.invoiceView.vehicleImageView.kf.setImage(with: resource)
            }
        }
        
        if let review = tripinvoicedetdict["driver_overall_rating"] {
            if let rating = Double("\(review)") {
                self.invoiceView.ratingLbl.set(text: String(format: "%.2f", rating), with: UIImage(named: "star"))
            }
        }
        
        if let paymentOpt = tripinvoicedetdict["payment_opt"] as? String, paymentOpt == "CARD" {
            if let isPaid = tripinvoicedetdict["is_paid"] as? Bool, !isPaid {
                self.invoiceView.conformBtn.isHidden = true
                self.invoiceView.payBtn.isHidden = false
            }
        }
    }
}

//MARK: - Actions
extension InvoiceVC {
   
    @objc func conformBtnPressed(_ sender: UIButton) {
        let vc = FeedBackRatingVC()
        vc.tripinvoicedetdict = tripinvoicedetdict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func payBtnPressed(_ sender: UIButton) {
        self.getOrderID()
    }
}

//MARK: - PAYMENT PROCESS
extension InvoiceVC {
    func getOrderID() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "")
            
            var paramDict = Dictionary<String,Any>()
            paramDict["amount"] = self.totalAmount * 100
            paramDict["currency"] = "INR"
            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.createOrderID
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                if response.response?.statusCode == 200 {
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let orders = data["orders"] as? [String: AnyObject] {
                                if let amount = orders["amount"], let currency = orders["currency"] as? String, let orderId = orders["order_id"] as? String, let keyId = orders["key_id"] as? String {
                                    self.showPaymentForm(razorKey: keyId, amount: "\(amount)", currency: currency, orderId: orderId)
                                }
                            }
                        }
                    }
                } else {
                    self.view.showToast("Sorry for the inconvenience. Please try again later")
                }
            }
        } else {
            self.showAlert("", message: "No internet connection found. please turn on your internet connection")
        }
    }
    
    internal func showPaymentForm(razorKey key: String, amount: String, currency: String, orderId: String){
        
        razorpay = RazorpayCheckout.initWithKey(key, andDelegate: self)
        let options: [String:Any] = [
                    "amount": amount, //This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": currency,
                    "description": "Total ride amount",
                    "order_id": orderId,
                    "image": "https://url-to-image.jpg",
                    "name": APIHelper.shared.appName as Any,
                    "confirm_close": true,
                    "prefill": [
                        "contact": APIHelper.shared.userDetails?.phone,
                        "email": APIHelper.shared.userDetails?.email,
                        "name": APIHelper.shared.userDetails?.firstName
                    ],
                    "theme": [
                        "color": "#ffd60b"
                    ],
                    
                ]
        razorpay?.open(options,displayController: self)
    }
    
    func updatePaymentStatus(payment id: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "")
            
            var paramDict = Dictionary<String,Any>()
            paramDict["request_id"] = self.requestId
            paramDict["payment_id"] = id
            paramDict["amount"] = self.totalAmount
            
            let url = APIHelper.shared.BASEURL + APIHelper.updatePaymentStatus
            print(paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                if response.response?.statusCode == 200 {
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let paymentSTatus = result["payment_status"] as? [String: AnyObject] {
                                if let isPaid = result["is_paid"] as? Bool, isPaid {
                                    
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.showAlert("", message: "No internet connection found. please turn on your internet connection")
        }
    }
    
    
    func changePaymentToCash() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "")
            
            var paramDict = Dictionary<String,Any>()
            paramDict["request_id"] = self.requestId
            paramDict["payment_opt"] = "CASH"
            
            let url = APIHelper.shared.BASEURL + APIHelper.changePaymentMode
            print(paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                switch response.result {
                case .success(_):
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            self.invoiceView.conformBtn.isHidden = false
                            self.invoiceView.payBtn.isHidden = true
                        } else {
                            if let err = result["error_message"] as? String {
                                self.showAlert("", message: err)
                            } else if let msg = result["message"] as? String {
                                self.showAlert("", message: msg)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert("", message: error.localizedDescription)
                }
               
            }
        } else {
            self.showAlert("", message: "No internet connection found. please turn on your internet connection")
        }
    }
}

//MARK: - PAYMENT CALLBACKS

extension InvoiceVC : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
       
        let alert = UIAlertController(title: "ALERT!", message: str + "\nUnable to process the payment. You can change the payment mode cash", preferredStyle: .actionSheet)
        let btnRetry = UIAlertAction(title: "RETRY", style: .default, handler: nil)
        let btnChange = UIAlertAction(title: "Change payment mode to cash", style: .default) { action in
            print("pay mode changed")
            self.changePaymentToCash()
        }
        alert.addAction(btnRetry)
        alert.addAction(btnChange)
        self.present(alert, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
       
        self.updatePaymentStatus(payment: payment_id)
        let vc = FeedBackRatingVC()
        vc.tripinvoicedetdict = tripinvoicedetdict
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - Socket Delegate
extension InvoiceVC: MySocketManagerDelegate {
    func paymentProcessed(_ response: [String : AnyObject]) {
        print("payment processed",response)
    }
}
