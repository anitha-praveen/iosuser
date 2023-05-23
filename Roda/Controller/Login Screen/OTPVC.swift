//
//  OTPVC.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseDatabase
import SWRevealViewController
import NVActivityIndicatorView

class OTPVC: UIViewController {

    private let otpView = OTPView()
    
    var selectedCountry:CountryList?
    var givenPhoneNumber:String?
    private var seconds = 60
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        setupViews()
        runTimer()
    }
    
    func setupViews() {
       
        otpView.setupViews(Base: self.view)
        setupData()
        setupTarget()
    }

    func setupData() {
        otpView.lblVerify.text = "txt_chk_sms".localize() + " +91" + (givenPhoneNumber ?? "")
        otpView.textField.delegate = self
    }

    func setupTarget() {
        otpView.verifyotpBtn.addTarget(self, action: #selector(verifyBtnPressed(_ :)), for: .touchUpInside)
        otpView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        otpView.resendBtn.addTarget(self, action: #selector(resendOtpPressed(_ :)), for: .touchUpInside)
        otpView.textField.addTarget(self, action: #selector(textFiledValueChanged(_ :)), for: .editingChanged)
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        otpView.resendBtn.isHidden = true
        otpView.otpRecieveHint.isHidden = false
        otpView.lblGetAnotherCode.text = "txt_get_another_code".localize() + " " + "\(seconds)" + " " + "txt_sec".localize()
        if seconds == 0 {
            otpView.otpRecieveHint.isHidden = true
            otpView.resendBtn.isHidden = false
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func textFiledValueChanged(_ sender: UITextField) {
        if sender.text?.count == 4 {
            self.otpView.textField.resignFirstResponder()
        }
    }
    func notificationObserve() {
        NotificationCenter.default.addObserver( self,selector:#selector(autoCheckOtp(_ :)), name: UITextField.textDidChangeNotification, object: otpView.textField)
    }
}

//MARK: - TARGET ACTIONS

extension OTPVC {
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func autoCheckOtp(_ sender: UIButton) {
        if (self.otpView.textField.text?.count ?? 0) == 4 {
            self.loginUser(primary: false)
        }
    }
    
    
    @objc func verifyBtnPressed(_ sender: UIButton) {
        
        if (self.otpView.textField.text?.count ?? 0) < 4 {
            self.showAlert( "text_Alert".localize(), message: "text_otpsent_mobilenumber".localize())
        } else {
            self.loginUser(primary: false)
//            let vc = RegisterVC()
//            vc.selectedCountry = self.selectedCountry
//            vc.givenPhoneNumber = self.givenPhoneNumber
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func resendOtpPressed(_ sender: UIButton) {
        self.sendOTP()
    }
    
}


//MARK: API'S

extension OTPVC {
    
    func sendOTP() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
            var paramDict = Dictionary<String,Any>()
            paramDict["phone_number"] = self.givenPhoneNumber
            paramDict["country_code"] = self.selectedCountry?.id
            
            let url = APIHelper.shared.BASEURL + APIHelper.sendOTP
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                switch response.result {
                case .success(_):
                    print(response.result.value as Any)
                    if response.response?.statusCode == 200 {
                        self.seconds = 60
                        self.runTimer()
                    } else {
                        if let result = response.result.value as? [String: AnyObject] {
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
                    self.showAlert("", message: "txt_sry_unable_to_process_number".localize())
                }
            }
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func loginUser(primary isPrimary: Bool) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            
            if let countryId = self.selectedCountry?.id, var phone = self.givenPhoneNumber {
                while phone.starts(with: "0") {
                    phone = String(phone.dropFirst())
                }
                paramDict["phone_number"] = phone
                paramDict["country_code"] = countryId
            }
            paramDict["otp"] = self.otpView.textField.text
            paramDict["device_info_hash"] = APIHelper.shared.deviceToken
            paramDict["is_primary"] = isPrimary
            
            let url = APIHelper.shared.BASEURL + APIHelper.loginUser
            
            print(url,paramDict)
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let newUser = data["new_user"] as? Bool, newUser {
                                    let vc = RegisterVC()
                                    vc.selectedCountry = self.selectedCountry
                                    vc.givenPhoneNumber = self.givenPhoneNumber
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else {
                                    self.getAuthToken(data)
                                }
                            }
                        } else {
                            if statusCode == 403 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let errCode = data["error_code"] as? Int, errCode == 1001 {
                                        if let msg = result["message"] as? String {
                                            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                            let ok = UIAlertAction(title: "text_ok".localize(), style: .default) { [weak self] (action) in
                                                self?.loginUser(primary: true)
                                            }
                                            let cancel = UIAlertAction(title: "text_cancel".localize().uppercased(), style: .default, handler: nil)
                                            alert.addAction(cancel)
                                            alert.addAction(ok)
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                }else {
                                    if let msg = result["message"] as? String {
                                        self.showAlert("", message: msg)
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
    
    func getAuthToken(_ data: [String: AnyObject]) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            paramDict["grant_type"] = "client_credentials"
            paramDict.merge(data.mapValues({"\($0)"})) { (current, _) -> Any in
                current
            }
            let url = APIHelper.shared.BASEURL + APIHelper.authToken
            
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let accessToken = result["access_token"] as? String, let tokenType = result["token_type"] as? String {
                            let token = tokenType + " " + accessToken
                            self.getUserProfile(token)
                        }
                    }
                }
            }
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func getUserProfile(_ token: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.getUserProfile
            
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization":token]).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let user = data["user"] as? [String: AnyObject] {
                                var details = [String: AnyObject]()
                                
                                details = user
                                details["access_token"] = token as AnyObject
                                print("My Details",details)
                                APIHelper.shared.storeUserDetails(details, currentUser: nil)
                                
                                self.redirect()
                            }
                        }
                    }
                }
            }
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    
    func mobileChangeUpdateCall() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
           
            var paramDict = Dictionary<String, Any>()
            paramDict["phone_number"] = self.givenPhoneNumber
            
            let url = APIHelper.shared.BASEURL + APIHelper.getUserProfile
            
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String:AnyObject] {
                                    if let userdetails = data["user"] as? [String:AnyObject] {
                                        APIHelper.shared.updateUserDetails(userdetails)
                                    }
                                    self.navigationController?.pushViewController(ProfileVC(), animated: true)
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
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func redirect() {
        
        AppLocationManager.shared.startTracking()
        MySocketManager.shared.establishConnection()
        
        let revealVC = SWRevealViewController()
        revealVC.panGestureRecognizer().isEnabled = false
      
        let menuVC = MenuViewController()
                    
        let pickupVC = TaxiPickupVC()
        
        pickupVC.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            revealVC.rearViewController = menuVC
            revealVC.rightViewController = nil
        } else {
            revealVC.rearViewController = nil
            revealVC.rightViewController = menuVC
        }
    
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setViewControllers([revealVC], animated: true)
        
    }
}

//MARK: TEXTFIELD DELEGATE
extension OTPVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == self.otpView.textField {
            
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            if string == filtered {
                let maxLength = 4
                let currentString: NSString = self.otpView.textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                
                return newString.length <= maxLength
            } else {
                return false
            }
        
        }
        
        return true
    }
    
}
