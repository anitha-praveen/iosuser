//
//  InitialvcViewController.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import FirebaseAuth
import Alamofire
class Initialvc: UIViewController {

    private let initialView = Initialview()
    
    private var countryList = [CountryList]()
    private var selectedCountry: CountryList?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        getCountryList()
        setupViews()
    }
    
    func setupViews() {
        initialView.setupViews(Base: self.view)
        initialView.phonenumberTfd.delegate = self
        initialView.termsAndConditionView.delegate = self
        
        initialView.viewPhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryPicker(_ :))))
        initialView.btnLogin.addTarget(self, action: #selector(btnLoginSignUpPressed(_ :)), for: .touchUpInside)
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    
        
        MySocketManager.shared.socket.disconnect()
       
        self.initialView.phonenumberTfd.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupData() {
        initialView.imgCountry.image = UIImage(named: self.selectedCountry?.isoCode ?? "")
        initialView.lblCountry.text = self.selectedCountry?.dialCode
        
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
    }

}

//MARK: TARGET ACTIION'S
extension Initialvc {
    
    @objc func showCountryPicker(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let vc = SelectCountryVC()
        vc.countryList = self.countryList
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    @objc func btnLoginSignUpPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.selectedCountry?.dialCode == nil {
            self.showAlert("", message: "text_select_countrycode".localize())
        } else if self.initialView.phonenumberTfd.text?.count == 0 {
            self.showAlert("", message: "text_enter_phonenumber".localize())
        } else if (self.initialView.phonenumberTfd.text?.count ?? 0) < 6 {
            self.showAlert("", message: "txt_enter_valid_phone_number".localize())
        } else {
            
            self.sendOTP()
//            let vc = OTPVC()
//            vc.selectedCountry = self.selectedCountry
//            vc.givenPhoneNumber = self.initialView.phonenumberTfd.text ?? ""
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getFirebaseOTP() {
        
        if let dialCode = self.selectedCountry?.dialCode {
            var phNumber = self.initialView.phonenumberTfd.text!
            while phNumber.starts(with: "0") {
                phNumber = String(phNumber.dropFirst())
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
            
            PhoneAuthProvider.provider().verifyPhoneNumber(dialCode + phNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    print(error.localizedDescription)
                    self.view.showToast(error.localizedDescription)
                    return
                }
                if let verificationId = verificationID {
                    APIHelper.firebaseVerificationCode = verificationId
                }
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                let vc = OTPVC()
                vc.selectedCountry = self.selectedCountry
                vc.givenPhoneNumber = self.initialView.phonenumberTfd.text ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
}

// MARK: COUNTRY PICKER DELEGATE

extension Initialvc: CountryPickerDelegate {
    func selectedCountry(_ country: CountryList) {
        self.selectedCountry = country
        self.initialView.lblCountry.text = self.selectedCountry?.dialCode
        self.initialView.imgCountry.image = self.selectedCountry?.flag
    }
}

//MARK:- DELEGATES

extension Initialvc: UITextFieldDelegate,UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == initialView.termsAndConditionsURL) {
            let vc = TermsAndConditionVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (URL.absoluteString == initialView.privacyURL) {
            let vc = PrivacyPolicyVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == self.initialView.phonenumberTfd {
            
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            if string == filtered {
                let maxLength = 12
                let currentString: NSString = self.initialView.phonenumberTfd.text! as NSString
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

//MARK: API'S
extension Initialvc {
    
    func sendOTP() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
            var paramDict = Dictionary<String,Any>()
            paramDict["phone_number"] = self.initialView.phonenumberTfd.text
            paramDict["country_code"] = self.selectedCountry?.id
            
            let url = APIHelper.shared.BASEURL + APIHelper.sendOTP
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                switch response.result {
                case .success(_):
                    print(response.result.value as Any)
                    if response.response?.statusCode == 200 {
                        let vc = OTPVC()
                        vc.selectedCountry = self.selectedCountry
                        vc.givenPhoneNumber = self.initialView.phonenumberTfd.text ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func getCountryList() {
        if ConnectionCheck.isConnectedToNetwork() {
           
            var paramDict = Dictionary<String, Any>()
            paramDict["code"] = APIHelper.appBaseCode
            
            let url = APIHelper.shared.BASEURL + APIHelper.getAppCountryLangData
            
            print("URL and Param For AvailLanguages",url, paramDict)
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
               
                print(response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let countryData = data["country"] as? [[String: AnyObject]] {
                                self.countryList = countryData.compactMap({CountryList($0)})
                                
                                if let country = Locale.current.regionCode {
                                    
                                    if let selectedCountry = self.countryList.first(where: {$0.isoCode == country}) {
                                        self.selectedCountry = selectedCountry
                                        self.initialView.lblCountry.text = self.selectedCountry?.dialCode
                                        self.initialView.imgCountry.image = self.selectedCountry?.flag
                                    }else {
                                        self.selectedCountry = self.countryList.first
                                        self.initialView.lblCountry.text = self.selectedCountry?.dialCode
                                        self.initialView.imgCountry.image = self.selectedCountry?.flag
                                    }
                                } else {
                                    self.selectedCountry = self.countryList.first
                                    self.initialView.lblCountry.text = self.selectedCountry?.dialCode
                                    self.initialView.imgCountry.image = self.selectedCountry?.flag
                                }
                            }
                        }
                    } else {
                        if let error = result["data"] as? [String:[String]] {
                            let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                            self.showAlert("", message: errMsg)
                        } else if let error = result["error_message"] as? String {
                            self.showAlert("", message: error)
                        } else if let errMsg = result["message"] as? String {
                            self.showAlert("", message: errMsg)
                        }
                    }
                    
                }
            }
        }
    }
}
