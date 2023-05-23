//
//  ProfileUpdateVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 29/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView


class ProfileUpdateVC: UIViewController {
    
    private let profileUpdateView = ProfileUpdateView()
    
    var profileField: ProfileUpdateType?
    
    var originalName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        initialSetup()
        setupTarget()
    }
    
    func setUpViews() {
        profileUpdateView.setupViews(Base: self.view)
        profileUpdateView.updateBtn.isEnabled = false
        self.profileUpdateView.updateBtn.alpha = 0.3
        
        if self.profileField == .firstName {
            originalName = APIHelper.shared.userDetails?.firstName
        } else if self.profileField == .lastName {
            originalName = APIHelper.shared.userDetails?.lastName
        } else if self.profileField == .email {
            originalName = APIHelper.shared.userDetails?.email
        }
    }
    
    func setupTarget() {
        profileUpdateView.cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_ :)), for: .touchUpInside)
        profileUpdateView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        profileUpdateView.updateBtn.addTarget(self, action: #selector(updateBtnAction(_ :)), for: .touchUpInside)
        profileUpdateView.textTfd.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

extension ProfileUpdateVC {
    func initialSetup() {
        if self.self.profileField == .firstName {
            profileUpdateView.titleLbl.text = "txt_update_first_name".localize()
            if let fname = APIHelper.shared.userDetails?.firstName {
                profileUpdateView.textTfd.text = fname
            }
            profileUpdateView.descriptionLbl.text = "txt_update_first_name_desc".localize()
        } else if self.profileField == .lastName {
            profileUpdateView.titleLbl.text = "txt_update_last_name".localize()
            if let lname = APIHelper.shared.userDetails?.lastName {
                profileUpdateView.textTfd.text = lname
            }
            profileUpdateView.descriptionLbl.text = "txt_update_last_name_desc".localize()
        } else if self.profileField == .email {
            profileUpdateView.titleLbl.text = "txt_update_email".localize()
            if let email = APIHelper.shared.userDetails?.email {
                profileUpdateView.textTfd.text = email
            }
            profileUpdateView.descriptionLbl.text = "txt_update_email_desc".localize()
        }
    }
}
extension ProfileUpdateVC {
    @objc func keyboardShown(_ sender:Notification) {
        if let keyBoardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size {
            self.profileUpdateView.bottomSpace.constant = -keyBoardSize.height
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardHidden(_ sender:Notification) {
        self.profileUpdateView.bottomSpace.constant = -20
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
  
    @objc func backBtnAction(_ sender: UIButton){
        self.profileField = nil
        self.originalName = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelBtnAction(_ sender: UIButton){
        self.profileUpdateView.textTfd.text = ""
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        
        if sender.text == self.originalName {
            self.profileUpdateView.updateBtn.isEnabled = false
            self.profileUpdateView.updateBtn.alpha = 0.3
        } else if sender.text == "" {
            self.profileUpdateView.updateBtn.isEnabled = false
            self.profileUpdateView.updateBtn.alpha = 0.3
        } else {
            self.profileUpdateView.updateBtn.isEnabled = true
            self.profileUpdateView.updateBtn.alpha = 1
        }
        
    }
    
    @objc func updateBtnAction(_ sender: UIButton){
        var errmsg = ""
        
        if self.profileField == .firstName && self.profileUpdateView.textTfd.text == "" {
            errmsg = "Validate_FirstName".localize()
        } else if self.profileField == .lastName && self.profileUpdateView.textTfd.text == "" {
            errmsg = "Validate_LastName".localize()
        } else if self.profileField == .email && self.profileUpdateView.textTfd.text == "" {
            errmsg = "Validate_Email".localize()
        } else if self.profileField == .email && !(profileUpdateView.textTfd.text?.isValidEmail ?? false) {
            errmsg = "text_error_email_valid".localize()
        }
        
        if errmsg.count > 0 {
            self.showAlert(errmsg)
        } else {
          
            self.updateUserProfile()
        }
    }

}
extension ProfileUpdateVC {
    
    func updateUserProfile() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            if self.profileField == .firstName {
                paramDict["firstname"] = self.profileUpdateView.textTfd.text
            } else if self.profileField == .lastName {
                paramDict["lastname"] = self.profileUpdateView.textTfd.text
            } else if self.profileField == .email {
                paramDict["email"] = self.profileUpdateView.textTfd.text
            }
            
            let url = APIHelper.shared.BASEURL + APIHelper.getUserProfile
            
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let user = data["user"] as? [String: AnyObject] {
                                APIHelper.shared.updateUserDetails(user)
                                self.profileField = nil
                                self.originalName = nil
                                self.navigationController?.popViewController(animated: true)
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
extension ProfileUpdateVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if self.profileField == .firstName || self.profileField == .lastName {
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                let maxLength = 15
                let currentString = self.profileUpdateView.textTfd.text! as NSString
                let newString =
                    currentString.replacingCharacters(in: range, with: string)
                return newString.count <= maxLength
               
            } else {
                return false
            }
        }
        return true
    }
}
