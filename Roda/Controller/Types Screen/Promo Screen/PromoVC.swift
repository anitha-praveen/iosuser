//
//  PromoVC.swift
//  Petra Ride
//
//  Created by Spextrum on 17/06/19.
//  Copyright © 2019 Mohammed Arshad. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher
import Alamofire
class PromoVC: UIViewController {
    
    var promoView = PromoView()
    
    var callBack: ((String)->Void)?
    var promoCancelledClouser: ((Bool) ->Void)?
    
    var promoList = [PromoList]()
    var selectedPromo: String?
    var isPromoCancelled = false
    
    var tripType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPromoList()
        setupViews()
        setupTarget()
    }
    
    func setupViews() {
        promoView.setupViews(Base: self.view)
       
        if self.selectedPromo != nil {
            self.promoView.textField.text = self.selectedPromo
            self.promoView.textField.isUserInteractionEnabled = false
            self.promoView.applyBtn.isHidden = true
            self.promoView.promoCancelBtn.isHidden = false
            
            self.promoView.blurredView.isHidden = false
            
        } else {
            self.promoView.textField.text = ""
            self.promoView.textField.isUserInteractionEnabled = true
            self.promoView.applyBtn.isHidden = false
            self.promoView.promoCancelBtn.isHidden = true
            
            self.promoView.blurredView.isHidden = true
        }
        
    }
    
    func setupTarget() {
        promoView.tblAvailablePromo.delegate = self
        promoView.tblAvailablePromo.dataSource = self
        promoView.tblAvailablePromo.register(AvailablePromoCell.self, forCellReuseIdentifier: "AvailablePromoCell")
        promoView.applyBtn.addTarget(self, action: #selector(promoApplybtnAction(_ :)), for: .touchUpInside)
        promoView.textField.addTarget(self, action: #selector(textFieldValueChanged(_ :)), for: .editingChanged)
        promoView.promoCancelBtn.addTarget(self, action: #selector(promoCancelbtnAction(_ :)), for: .touchUpInside)
        promoView.btnBack.addTarget(self, action: #selector(btnBackAction(_ :)), for: .touchUpInside)
        promoView.btnYAY.addTarget(self, action: #selector(btnYAYAction(_ :)), for: .touchUpInside)
    }
    
    @objc func promoApplybtnAction(_ sender: UIButton) {
        self.applyPromo(self.promoView.textField.text ?? "")
    }
    
    @objc func textFieldValueChanged(_ sender: UITextField) {
        if sender.text?.count ?? 0 > 0 {
            self.promoView.applyBtn.isEnabled = true
            
        } else {
            self.promoView.applyBtn.isEnabled = false
           
        }
    }
    
    @objc func promoCancelbtnAction(_ sender: UIButton) {
        self.selectedPromo = nil
        self.isPromoCancelled = true
        self.promoView.textField.text = ""
        self.promoView.textField.isUserInteractionEnabled = true
        self.promoView.applyBtn.isHidden = false
        self.promoView.promoCancelBtn.isHidden = true
        
        self.promoView.blurredView.isHidden = true
        
        self.promoView.tblAvailablePromo.reloadData()
    }
    
    @objc func btnYAYAction(_ sender: UIButton) {
        if let promo = self.selectedPromo {
            self.callBack?(promo)
        } else {
            self.callBack?(self.promoView.textField.text ?? "")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnBackAction(_ sender: UIButton) {
        if self.isPromoCancelled {
            self.promoCancelledClouser?(true)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TABLEVIEW DELEGATE
extension PromoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.promoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailablePromoCell") as? AvailablePromoCell ?? AvailablePromoCell()
        cell.lblPromo.text = self.promoList[indexPath.row].promoCode
        cell.lblShortDesc.text = self.promoList[indexPath.row].offerTitle
        cell.lblDescription.text = self.promoList[indexPath.row].description
        
        if self.promoList[indexPath.row].promoType == "1" {
            cell.lblOfferAmount.text = "( " + "txt_upto".localize() + " " + (self.promoList[indexPath.row].currency ?? "") + (self.promoList[indexPath.row].amount ?? "") + " )"
        } else {
            cell.lblOfferAmount.text = "( " + "txt_upto".localize() + " " + (self.promoList[indexPath.row].percentage ?? "") + "% )"
        }
        
        if let imgStr = self.promoList[indexPath.row].icon, let url = URL(string: imgStr) {
            let resource = ImageResource(downloadURL: url)
            cell.imgPromo.kf.setImage(with: resource,placeholder:UIImage(named: "bell"))
        } else {
            cell.imgPromo.image = UIImage(named: "bell")
        }
        
        if self.selectedPromo != nil {
            cell.applyBtn.isEnabled = false
        } else {
            cell.applyBtn.isEnabled = true
            cell.applyAction = {
                self.selectedPromo = self.promoList[indexPath.row].promoCode
                self.applyPromo(self.promoList[indexPath.row].promoCode ?? "")
            }
        }
        
        
        return cell
    }
   
}

//MARK: API's
extension PromoVC {
    func getPromoList() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show()
          
            
            let url = APIHelper.shared.BASEURL + APIHelper.getPromoList + "?type=\(self.tripType)"
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as AnyObject)
                if let result = response.result.value as? [String:AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            
                            if let promoList = data["promocode"] as? [[String: AnyObject]] {
                                self.promoList = promoList.compactMap({PromoList($0)})
                                
                                DispatchQueue.main.async {
                                    if !self.promoList.isEmpty {
                                        self.promoView.tblAvailablePromo.reloadData()
                                        self.promoView.tblAvailablePromo.isHidden = false
                                    }
                                }
                                
                            }
                            
                        }
                    } else {
                       
                        self.promoView.tblAvailablePromo.isHidden = true
                    }
                }
            }
        }
    }
    
    
    func applyPromo(_ code: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show()
            var paramDict = Dictionary<String, Any>()
            paramDict["promo_code"] = code
            paramDict["trip_type"] = self.tripType
            
            let url = APIHelper.shared.BASEURL + APIHelper.applyPromoCode
            print(url, paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as AnyObject)
                if let result = response.result.value as? [String:AnyObject] {
                    print("PROMO",result)
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        
                        self.promoView.lblAppliedPromoCode.text = "'" + code + "'"
                       
                        self.promoView.successTransparentView.isHidden = false
                        if let data = result["data"] as? [String:Any], let user = data["user"] as? [String:Any] {
                            if let promoType = user["promo_type"] {
                                let type = "\(promoType)"
                                if type == "1" {
                                    if let amount = user["amount"],let currency = user["currency"] as? String  {
                                        self.promoView.lblAppliedAmount.text = currency + " " + "\(amount)"
                                    }
                                } else {
                                    if let percentage = user["percentage"] {
                                        self.promoView.lblAppliedAmount.text = "\(percentage) %"
                                    }
                                }
                            } else {
                                if let amount = user["amount"],let currency = user["currency"] as? String  {
                                    self.promoView.lblAppliedAmount.text = currency + " " + "\(amount)"
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


