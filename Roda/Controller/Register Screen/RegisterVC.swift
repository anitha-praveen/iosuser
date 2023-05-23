//
//  RegisterView.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SWRevealViewController
class RegisterVC: UIViewController {

    private let registerView = RegisterView()
    private let picker = UIImagePickerController()
    var selectedCountry: CountryList?
    var givenPhoneNumber:String?
    
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    func setupViews() {
        registerView.setupViews(Base: self.view)
        registerView.firstnameTfd.delegate = self
        registerView.emailTfd.delegate = self
        setupTarget()
    }
    
    func setupTarget() {
        registerView.signupBtn.addTarget(self, action: #selector(signupBtnPressed(_ :)), for: .touchUpInside)
        registerView.viewProfileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseProfilePic(_ :))))
    }

}

//MARK: TARGET ACTIONS

extension RegisterVC {
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func chooseProfilePic(_ sender: UITapGestureRecognizer) {
        guard let title = APIHelper.shared.appName else {
            return
        }
        let alert = UIAlertController(title: title.uppercased(), message: "text_Please_Select_an_Option".localize(), preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = sender.view
        alert.popoverPresentationController?.sourceRect = sender.view?.bounds ?? CGRect()
        alert.addAction(UIAlertAction(title: "text_photoLib".localize(), style: .default, handler:{ _ in
           
            self.picker.delegate = self
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "text_camera".localize(), style: .default, handler:{ _ in
           
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraDevice = .front
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    @objc func signupBtnPressed(_ sender: UIButton) {
        self.validateFields { (error) in
            if error != "" {
                self.showAlert( "text_Alert".localize(), message: error)
            } else {
               
                self.registerUser(primary: false)
            }
        }
    }
}

//MARK:- ImagePicker Delegate

extension RegisterVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            registerView.imgProfile.image = orientationImg
            self.selectedImage = orientationImg
           
        } else if let selectedImage = info[.editedImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            registerView.imgProfile.image = orientationImg
            self.selectedImage = orientationImg
        }
        picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - API'S

extension RegisterVC {
    
    func validateFields(completion:@escaping(String)->Void) {
        var errmsg = ""
        if self.registerView.firstnameTfd.text!.isEmpty {

            errmsg = "txt_name_cannot_be_empty".localize()
        }  else if !(self.registerView.emailTfd.text?.isEmpty ?? false) && !(self.registerView.emailTfd.text?.isValidEmail ?? false) {
            errmsg = "text_error_email_valid".localize()
        }
        completion(errmsg)
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
                                APIHelper.shared.storeUserDetails(details, currentUser: nil)
                                
                                self.redirect()
                            }
                        }
                    }
                }
            }
        }
    }
    
   func registerUser(primary isPrimary: Bool) {
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
            paramDict["firstname"] = self.registerView.firstnameTfd.text ?? ""
          
            if self.registerView.emailTfd.text != "" {
                paramDict["email"] = self.registerView.emailTfd.text ?? ""
            }
            paramDict["device_info_hash"] = APIHelper.shared.deviceToken
            paramDict["device_type"] = "IOS"
            paramDict["is_primary"] = isPrimary ? "1":"0"
            if registerView.txtReferralCode.text != "" {
                paramDict["referral_code"] = registerView.txtReferralCode.text ?? ""
            }
        
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.signupUser, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
            print(urlRequest)
            var newImage: UIImage? = nil
          
            if let img = self.registerView.imgProfile.image {
                newImage = img
            }
            
            while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                newImage = newImage?.resized(withPercentage: 0.5)
            }
            Alamofire.upload(multipartFormData: { multipartFormData in
                if self.selectedImage != nil {
                    if let image = newImage, let imgData = image.pngData() {
                        multipartFormData.append(imgData, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
                    }
                }
            
                for (key, value) in paramDict {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
            }, with: urlRequest, encodingCompletion:{ encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        NKActivityLoader.sharedInstance.hide()
                        print(response.result.value as Any, response.response?.statusCode as Any)
                        if case .failure(let error) = response.result {
                            print(error.localizedDescription)
                            self.view.showToast(error.localizedDescription)
                        }
                        else if case .success = response.result {
                            
                            if let result = response.result.value as? [String: AnyObject] {
                                if let statusCode = response.response?.statusCode {
                                    if statusCode == 200 {
                                        if let data = result["data"] as? [String: AnyObject] {
                                           
                                            self.getAuthToken(data)
                                        }
                                    } else {
                                        if statusCode == 403 {
                                            if let data = result["data"] as? [String: AnyObject] {
                                                if let errCode = data["error_code"] as? Int, errCode == 1001 {
                                                    if let msg = result["message"] as? String {
                                                        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                                        let ok = UIAlertAction(title: "text_ok".localize(), style: .default) { (action) in
                                                            self.registerUser(primary: true)
                                                        }
                                                        let cancel = UIAlertAction(title: "text_cancel".localize().uppercased(), style: .default, handler: nil)
                                                        alert.addAction(cancel)
                                                        alert.addAction(ok)
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                } else {
                                                    if let msg = result["message"] as? String {
                                                        self.showAlert("", message: msg)
                                                    }
                                                }
                                            } else {
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
                case .failure(let encodingError):
                    
                    NKActivityLoader.sharedInstance.hide()
                    self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                }
            })
            
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
        revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            revealVC.rearViewController = menuVC
            revealVC.rightViewController = nil
        } else {
            revealVC.rearViewController = nil
            revealVC.rightViewController = menuVC
        }
        pickupVC.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setViewControllers([revealVC], animated: true)
    }
}

//MARK: - TEXTIELD DELEGATE

extension RegisterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == self.registerView.firstnameTfd {
            
            let maxLength = 15
            let currentString = self.registerView.firstnameTfd.text! as NSString
            let newString =
            currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
            
        }
        return true
    }
}
