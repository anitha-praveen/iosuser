//
//  ProfileVC.swift
//  Taxiappz
//
//  Created by NPlus Technologies on 02/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Kingfisher
import AWSS3
import AWSCore
import AWSCognito
class ProfileVC: UIViewController {
    
    private let profileView = ProfileView()
    private let picker = UIImagePickerController()
    
    var favouriteLocationList = [SearchLocation]()
    
    var currentLayoutDirection = APIHelper.appLanguageDirection
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if currentLayoutDirection != APIHelper.appLanguageDirection {
            profileView.setupViews(Base: self.view)
            currentLayoutDirection = APIHelper.appLanguageDirection
        }
        getFavouriteListApi()
        self.setupData()
    }
    
    func setupViews() {
        profileView.setupViews(Base: self.view)
        profileView.txtFirstName.delegate = self
        profileView.txtEmail.delegate = self
        setupTarget()
    }
   
    func setupTarget() {
        
        profileView.tblFavourites.delegate = self
        profileView.tblFavourites.dataSource = self
        profileView.tblFavourites.register(FavouriteLocationsCell.self, forCellReuseIdentifier: "FavouriteLocationsCell")
        
        profileView.txtFirstName.addTarget(self, action: #selector(txtValueChanged(_ :)), for: .editingChanged)
        profileView.txtEmail.addTarget(self, action: #selector(txtValueChanged(_ :)), for: .editingChanged)
     
        profileView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        profileView.profpicBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
        profileView.profpicEditBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
        profileView.btnLogout.addTarget(self, action: #selector(logoutPressed(_ :)), for: .touchUpInside)
        profileView.btnDeleteAccount.addTarget(self, action: #selector(deleteAccountPressed(_ :)), for: .touchUpInside)
        
        profileView.btnSave.addTarget(self, action: #selector(btnSavePressed(_ :)), for: .touchUpInside)
        
        profileView.btnAddHome.addTarget(self, action: #selector(btnAddFavouritePressed(_ :)), for: .touchUpInside)
        profileView.btnAddWork.addTarget(self, action: #selector(btnAddFavouritePressed(_ :)), for: .touchUpInside)
        profileView.btnAddOther.addTarget(self, action: #selector(btnAddFavouritePressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
    
        if let fname = APIHelper.shared.userDetails?.firstName {
            self.profileView.txtFirstName.text = fname
        }
    
        if let email = APIHelper.shared.userDetails?.email {
            self.profileView.txtEmail.text = email
        }
        if let mobile = APIHelper.shared.userDetails?.phone {
            self.profileView.txtPhoneNumber.text = mobile
        }
        
        if let imgStr = APIHelper.shared.userDetails?.profilePictureUrl, let url = URL(string: imgStr) {
            let resource = ImageResource(downloadURL: url)
            self.profileView.profpicBtn.kf.setImage(with: resource,for: .normal, placeholder:UIImage(named: "signup_profile_img"))
        } else {
            self.profileView.profpicBtn.setImage(UIImage(named: "signup_profile_img"), for: .normal)
        }
    }
    
    @objc func txtValueChanged(_ sender: UITextField) {
        if sender == self.profileView.txtFirstName {
            if (sender.text?.count ?? 0) > 0 && sender.text != APIHelper.shared.userDetails?.firstName {
                
                self.profileView.btnSave.isEnabled = true
                self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
                self.profileView.btnSave.backgroundColor = UIColor.themeColor
            } else {
                if self.profileView.txtEmail.text != APIHelper.shared.userDetails?.email {
                    self.profileView.btnSave.isEnabled = true
                    self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
                    self.profileView.btnSave.backgroundColor = UIColor.themeColor
                } else {
                    self.profileView.btnSave.setTitleColor(.gray, for: .normal)
                    self.profileView.btnSave.backgroundColor = UIColor.themeColor.withAlphaComponent(0.4)
                    self.profileView.btnSave.isEnabled = false
                }
            }
        } else if sender == self.profileView.txtEmail {
            if (sender.text?.count ?? 0) > 0 && sender.text != APIHelper.shared.userDetails?.email {
                self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
                self.profileView.btnSave.backgroundColor = UIColor.themeColor
                self.profileView.btnSave.isEnabled = true
            } else {
                if self.profileView.txtFirstName.text != APIHelper.shared.userDetails?.firstName {
                    self.profileView.btnSave.isEnabled = true
                    self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
                    self.profileView.btnSave.backgroundColor = UIColor.themeColor
                } else {
                    self.profileView.btnSave.setTitleColor(.gray, for: .normal)
                    self.profileView.btnSave.backgroundColor = UIColor.themeColor.withAlphaComponent(0.4)
                    self.profileView.btnSave.isEnabled = false
                }
            }
        }
    }
    
}
//MARK:- Target Action's
extension ProfileVC {
  
    @objc func proPicBtnPressed(_ sender: UIButton) {
        guard let title = APIHelper.shared.appName else {
            return
        }
        let alert = UIAlertController(title: title, message: "text_Please_Select_an_Option".localize(), preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.bounds
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
    
    @objc func logoutPressed(_ sender: UIButton) {
        let vc = LogoutVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.deleteAccount = false
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func deleteAccountPressed(_ sender: UIButton) {
        let vc = LogoutVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.deleteAccount = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSavePressed(_ sender: UIButton) {
        self.updateUserProfile()
    }
    
    @objc func btnAddFavouritePressed(_ sender: UIButton) {
        let vc = SearchLocationVC()
        vc.titleText = sender.titleLabel?.text ?? ""
        vc.selectedLocation = {[unowned self] location in
            if sender == self.profileView.btnAddHome {
                self.savefavouriteapicall(title: "Home", location: location)
            } else if sender == self.profileView.btnAddWork {
                self.savefavouriteapicall(title: "Work", location: location)
            } else {
                self.savefavouriteapicall(title: "Other", location: location)
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- ImagePicker Delegate

extension ProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            profileView.profpicBtn.setImage(orientationImg, for: .normal)
           
            self.updateprofileapicall()
        } else if let selectedImage = info[.editedImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            profileView.profpicBtn.setImage(orientationImg, for: .normal)
           
            self.updateprofileapicall()
        }
        picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- API - Get Profile
extension ProfileVC {
    
    func updateprofileapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            
            paramDict["email"] = APIHelper.shared.userDetails?.email
           // paramDict["lastname"] = APIHelper.shared.userDetails?.lastName
            paramDict["firstname"] = APIHelper.shared.userDetails?.firstName
            paramDict["phone_number"] = APIHelper.shared.userDetails?.phone
            
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.getUserProfile, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
            
            var newImage: UIImage? = nil
          
                if let btnImg = self.profileView.profpicBtn.imageView?.image, !btnImg.isEqual(UIImage(named: "signup_profile_img")) {
                    newImage = self.profileView.profpicBtn.imageView?.image
                }
           
            while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                newImage = newImage?.resized(withPercentage: 0.5)
            }
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let image = newImage, let imgData = image.pngData() {
                    multipartFormData.append(imgData, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
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
                        }
                        else if case .success = response.result {
                            
                            if let result = response.result.value as? [String: AnyObject] {
                                if let statusCode = response.response?.statusCode {
                                    if statusCode == 200 {
                                        if let data = result["data"] as? [String:AnyObject] {
                                            if let userdetails = data["user"] as? [String:AnyObject] {
                                                APIHelper.shared.updateUserDetails(userdetails)
                                            }
                                        }
                                        if let msg = result["success_message"] as? String {
                                            self.view.showToast(msg)
                                        }
                                        
                                        if let imgStr = APIHelper.shared.userDetails?.profilePictureUrl, let url = URL(string: imgStr) {
                                            let resource = ImageResource(downloadURL: url)
                                            self.profileView.profpicBtn.kf.setImage(with: resource,for: .normal, placeholder:UIImage(named: "signup_profile_img"))
                                        } else {
                                            self.profileView.profpicBtn.setImage(UIImage(named: "signup_profile_img"), for: .normal)
                                        }
                                   
                                    } else {
                                        
                                        if let msg = result["error_message"] as? String {
                                            self.view.showToast(msg)
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
    
    func updateUserProfile() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            
            paramDict["firstname"] = self.profileView.txtFirstName.text
            paramDict["email"] = self.profileView.txtEmail.text
         
            let url = APIHelper.shared.BASEURL + APIHelper.getUserProfile
            
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                switch response.result {
                
                case .success(_):
                    
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode, statusCode == 200 {
                            if let data = result["data"] as? [String:AnyObject] {
                                if let user = data["user"] as? [String: AnyObject] {
                                    APIHelper.shared.updateUserDetails(user)
                                    self.view.showToast("txt_profile_updated_successfully".localize())
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
                    self.view.showToast("txt_sry_for_inconvinience".localize())
                }
            }
        }
    }
    
    
    
    func getFavouriteListApi() {

        if ConnectionCheck.isConnectedToNetwork() {
           
            let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let favPlaces = data["FavouriteList"] as? [[String:AnyObject]] {
                                        self.favouriteLocationList = favPlaces.compactMap({ SearchLocation($0) })
                                        
                                        if !self.favouriteLocationList.isEmpty {
                                            self.profileView.tblFavourites.reloadData()
                                            
                                            self.profileView.tblHeightConstraint?.constant =  self.profileView.tblFavourites.contentSize.height
                                            
                                            self.view.setNeedsLayout()
                                            self.view.layoutIfNeeded()
                                            
                                            if (self.favouriteLocationList.first(where: {$0.nickName?.contains("Home") ?? false}) != nil) {
                                                self.profileView.btnAddHome.setTitleColor(.hexToColor("DADADA"), for: .normal)
                                                self.profileView.btnAddHome.isEnabled = false
                                            } else {
                                                self.profileView.btnAddHome.setTitleColor(.txtColor, for: .normal)
                                                self.profileView.btnAddHome.isEnabled = true
                                            }
                                            if (self.favouriteLocationList.first(where: {$0.nickName?.contains("Work") ?? false}) != nil) {
                                                self.profileView.btnAddHome.setTitleColor(.gray, for: .normal)
                                                if (self.favouriteLocationList.first(where: {$0.nickName?.contains("Home") ?? false}) != nil) {
                                                    self.profileView.viewHomeWork.isHidden = true
                                                } else {
                                                    self.profileView.viewHomeWork.isHidden = false
                                                }
                                            } else {
                                                self.profileView.viewHomeWork.isHidden = false
                                            }
                                        } else {
                                            self.profileView.tblHeightConstraint?.constant =  0
                                        }
                                        
                                    } else {
                                        self.profileView.tblHeightConstraint?.constant =  0
                                    }
                               
                                }
                            }
                        }
                    }
            }
        }
    }
    
    
    func savefavouriteapicall(title name: String, location: SearchLocation) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String, Any>()

            paramDict["title"] = name
            paramDict["address"] = location.placeId
            paramDict["latitude"] = location.latitude
            paramDict["longitude"] = location.longitude
           

            let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    
                                    self.navigationController?.view.showToast("txt_Fav_Add".localize())
                                    self.getFavouriteListApi()
                                }
                            } else {
                                
                                self.view.showToast("text_someting_went_wrong".localize())
                            }
                        }
                    }
            }
        }
    }
    
    func deleteFavourite(_ slug: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            let url = APIHelper.shared.BASEURL + APIHelper.deleteFavourite + "/" + slug
            print(url)
            Alamofire.request(url, method: .post, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        print(result)
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                self.getFavouriteListApi()
                            } else {
                                self.view.showToast("txt_Fav_list_no_data".localize())
                            }
                        }

                    } else {
                        self.view.showToast("text_someting_went_wrong".localize())
                    }
            }
        }
    }
    
}

extension ProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == self.profileView.txtFirstName {
            
            let maxLength = 15
            let currentString = textField.text! as NSString
            let newString =
            currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        
        }
        return true
    }
}

//MARK: - Favourite Table Delegate
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteLocationsCell") as? FavouriteLocationsCell ?? FavouriteLocationsCell()
        cell.placenameLbl.text = favouriteLocationList[indexPath.row].nickName
        cell.placeaddLbl.text = favouriteLocationList[indexPath.row].placeId
        if let imageset = self.favouriteLocationList[indexPath.row].nickName {
            if imageset == "Home" {
                cell.placeImv.image = UIImage(named: "favHome")
            } else if imageset == "Work"{
                cell.placeImv.image = UIImage(named: "favWork")
            } else {
                cell.placeImv.image = UIImage(named: "favorOthers")
            }
        }
       
        cell.favDeleteBtn.isHidden = false
        cell.deleteAction = {[weak self] in
            self?.deleteFavourite(self?.favouriteLocationList[indexPath.row].slug ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// To resize the captured image
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}






/*
 // Using S3
 class ProfileVC: UIViewController {
 
 private let profileView = ProfileView()
 private let picker = UIImagePickerController()
 
 var favouriteLocationList = [SearchLocation]()
 
 var currentLayoutDirection = APIHelper.appLanguageDirection
 override func viewDidLoad() {
 super.viewDidLoad()
 
 setupViews()
 
 }
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(true)
 if currentLayoutDirection != APIHelper.appLanguageDirection {
 profileView.setupViews(Base: self.view)
 currentLayoutDirection = APIHelper.appLanguageDirection
 }
 getFavouriteListApi()
 self.setupData()
 }
 
 func setupViews() {
 profileView.setupViews(Base: self.view)
 profileView.txtFirstName.delegate = self
 profileView.txtEmail.delegate = self
 setupTarget()
 }
 
 func setupTarget() {
 
 profileView.tblFavourites.delegate = self
 profileView.tblFavourites.dataSource = self
 profileView.tblFavourites.register(FavouriteLocationsCell.self, forCellReuseIdentifier: "FavouriteLocationsCell")
 
 profileView.txtFirstName.addTarget(self, action: #selector(txtValueChanged(_ :)), for: .editingChanged)
 profileView.txtEmail.addTarget(self, action: #selector(txtValueChanged(_ :)), for: .editingChanged)
 
 profileView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
 profileView.profpicBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
 profileView.profpicEditBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
 profileView.btnLogout.addTarget(self, action: #selector(logoutPressed(_ :)), for: .touchUpInside)
 profileView.btnDeleteAccount.addTarget(self, action: #selector(deleteAccountPressed(_ :)), for: .touchUpInside)
 
 profileView.btnSave.addTarget(self, action: #selector(btnSavePressed(_ :)), for: .touchUpInside)
 
 profileView.btnAddHome.addTarget(self, action: #selector(btnAddFavouritePressed(_ :)), for: .touchUpInside)
 profileView.btnAddWork.addTarget(self, action: #selector(btnAddFavouritePressed(_ :)), for: .touchUpInside)
 profileView.btnAddOther.addTarget(self, action: #selector(btnAddFavouritePressed(_ :)), for: .touchUpInside)
 }
 
 func setupData() {
 
 if let fname = APIHelper.shared.userDetails?.firstName {
 self.profileView.txtFirstName.text = fname
 }
 
 if let email = APIHelper.shared.userDetails?.email {
 self.profileView.txtEmail.text = email
 }
 if let mobile = APIHelper.shared.userDetails?.phone {
 self.profileView.txtPhoneNumber.text = mobile
 }
 
 // ------S3 Bucket
 if LocalDB.profilePicData != nil {
 self.profileView.profpicBtn.setImage(UIImage(data: LocalDB.profilePicData ?? Data()), for: .normal)
 } else {
 if let imgStr = APIHelper.shared.userDetails?.profilePictureUrl {
 self.profileView.activityIndicator.startAnimating()
 self.retriveImg(key: imgStr) { data in
 self.profileView.activityIndicator.stopAnimating()
 self.profileView.profpicBtn.setImage(UIImage(data: data), for: .normal)
 }
 } else {
 self.profileView.activityIndicator.stopAnimating()
 self.profileView.profpicBtn.setImage(UIImage(named: "signup_profile_img"), for: .normal)
 }
 }
 
 }
 
 @objc func txtValueChanged(_ sender: UITextField) {
 if sender == self.profileView.txtFirstName {
 if (sender.text?.count ?? 0) > 0 && sender.text != APIHelper.shared.userDetails?.firstName {
 
 self.profileView.btnSave.isEnabled = true
 self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
 self.profileView.btnSave.backgroundColor = UIColor.themeColor
 } else {
 if self.profileView.txtEmail.text != APIHelper.shared.userDetails?.email {
 self.profileView.btnSave.isEnabled = true
 self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
 self.profileView.btnSave.backgroundColor = UIColor.themeColor
 } else {
 self.profileView.btnSave.setTitleColor(.gray, for: .normal)
 self.profileView.btnSave.backgroundColor = UIColor.themeColor.withAlphaComponent(0.4)
 self.profileView.btnSave.isEnabled = false
 }
 }
 } else if sender == self.profileView.txtEmail {
 if (sender.text?.count ?? 0) > 0 && sender.text != APIHelper.shared.userDetails?.email {
 self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
 self.profileView.btnSave.backgroundColor = UIColor.themeColor
 self.profileView.btnSave.isEnabled = true
 } else {
 if self.profileView.txtFirstName.text != APIHelper.shared.userDetails?.firstName {
 self.profileView.btnSave.isEnabled = true
 self.profileView.btnSave.setTitleColor(.themeTxtColor, for: .normal)
 self.profileView.btnSave.backgroundColor = UIColor.themeColor
 } else {
 self.profileView.btnSave.setTitleColor(.gray, for: .normal)
 self.profileView.btnSave.backgroundColor = UIColor.themeColor.withAlphaComponent(0.4)
 self.profileView.btnSave.isEnabled = false
 }
 }
 }
 }
 
 }
 //MARK:- Target Action's
 extension ProfileVC {
 
 @objc func proPicBtnPressed(_ sender: UIButton) {
 guard let title = APIHelper.shared.appName else {
 return
 }
 let alert = UIAlertController(title: title, message: "text_Please_Select_an_Option".localize(), preferredStyle: .actionSheet)
 alert.popoverPresentationController?.sourceView = sender
 alert.popoverPresentationController?.sourceRect = sender.bounds
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
 
 @objc func logoutPressed(_ sender: UIButton) {
 let vc = LogoutVC()
 vc.modalPresentationStyle = .overCurrentContext
 vc.deleteAccount = false
 self.present(vc, animated: true, completion: nil)
 }
 
 @objc func deleteAccountPressed(_ sender: UIButton) {
 let vc = LogoutVC()
 vc.modalPresentationStyle = .overCurrentContext
 vc.deleteAccount = true
 self.present(vc, animated: true, completion: nil)
 }
 
 @objc func backBtnPressed(_ sender: UIButton) {
 self.navigationController?.popViewController(animated: true)
 }
 
 @objc func btnSavePressed(_ sender: UIButton) {
 self.updateUserProfile()
 }
 
 @objc func btnAddFavouritePressed(_ sender: UIButton) {
 let vc = SearchLocationVC()
 vc.titleText = sender.titleLabel?.text ?? ""
 vc.selectedLocation = {[unowned self] location in
 if sender == self.profileView.btnAddHome {
 self.savefavouriteapicall(title: "Home", location: location)
 } else if sender == self.profileView.btnAddWork {
 self.savefavouriteapicall(title: "Work", location: location)
 } else {
 self.savefavouriteapicall(title: "Other", location: location)
 }
 
 }
 self.navigationController?.pushViewController(vc, animated: true)
 }
 }
 
 //MARK:- ImagePicker Delegate
 
 extension ProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 if let selectedImage = info[.originalImage] as? UIImage {
 
 let orientationImg = selectedImage.fixedOrientation()
 profileView.profpicBtn.setImage(orientationImg, for: .normal)
 
 self.updateprofileapicall()
 } else if let selectedImage = info[.editedImage] as? UIImage {
 
 let orientationImg = selectedImage.fixedOrientation()
 profileView.profpicBtn.setImage(orientationImg, for: .normal)
 
 self.updateprofileapicall()
 }
 picker.dismiss(animated: true, completion: nil)
 }
 
 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
 picker.dismiss(animated: true, completion: nil)
 }
 
 }
 
 //MARK:- API - Get Profile
 extension ProfileVC {
 
 func updateprofileapicall() {
 if ConnectionCheck.isConnectedToNetwork() {
 
 NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
 
 var paramDict = Dictionary<String, Any>()
 
 paramDict["email"] = APIHelper.shared.userDetails?.email
 // paramDict["lastname"] = APIHelper.shared.userDetails?.lastName
 paramDict["firstname"] = APIHelper.shared.userDetails?.firstName
 paramDict["phone_number"] = APIHelper.shared.userDetails?.phone
 
 guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.getUserProfile, method: .post, headers: APIHelper.shared.authHeader) else {
 return
 }
 
 var newImage: UIImage? = nil
 
 if let btnImg = self.profileView.profpicBtn.imageView?.image, !btnImg.isEqual(UIImage(named: "signup_profile_img")) {
 newImage = self.profileView.profpicBtn.imageView?.image
 }
 
 while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
 newImage = newImage?.resized(withPercentage: 0.5)
 }
 Alamofire.upload(multipartFormData: { multipartFormData in
 if let image = newImage, let imgData = image.pngData() {
 multipartFormData.append(imgData, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
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
 }
 else if case .success = response.result {
 
 if let result = response.result.value as? [String: AnyObject] {
 if let statusCode = response.response?.statusCode {
 if statusCode == 200 {
 if let data = result["data"] as? [String:AnyObject] {
 if let userdetails = data["user"] as? [String:AnyObject] {
 APIHelper.shared.updateUserDetails(userdetails)
 }
 }
 if let msg = result["success_message"] as? String {
 self.view.showToast(msg)
 }
 // ------S3 Bucket
 
 if let imgStr = APIHelper.shared.userDetails?.profilePictureUrl {
 self.profileView.activityIndicator.startAnimating()
 self.retriveImg(key: imgStr) { data in
 self.profileView.activityIndicator.stopAnimating()
 LocalDB.profilePicData = data
 self.profileView.profpicBtn.setImage(UIImage(data: data), for: .normal)
 }
 } else {
 self.profileView.activityIndicator.stopAnimating()
 self.profileView.profpicBtn.setImage(UIImage(named: "signup_profile_img"), for: .normal)
 }
 
 } else {
 
 if let msg = result["error_message"] as? String {
 self.view.showToast(msg)
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
 
 
 func updateUserProfile() {
 if ConnectionCheck.isConnectedToNetwork() {
 NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
 
 var paramDict = Dictionary<String, Any>()
 
 paramDict["firstname"] = self.profileView.txtFirstName.text
 paramDict["email"] = self.profileView.txtEmail.text
 
 let url = APIHelper.shared.BASEURL + APIHelper.getUserProfile
 
 print(url,paramDict)
 Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
 NKActivityLoader.sharedInstance.hide()
 print(response.result.value as Any)
 switch response.result {
 
 case .success(_):
 
 if let result = response.result.value as? [String: AnyObject] {
 if let statusCode = response.response?.statusCode, statusCode == 200 {
 if let data = result["data"] as? [String:AnyObject] {
 if let user = data["user"] as? [String: AnyObject] {
 APIHelper.shared.updateUserDetails(user)
 self.view.showToast("txt_profile_updated_successfully".localize())
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
 self.view.showToast("txt_sry_try_again".localize())
 }
 }
 }
 }
 
 
 func getFavouriteListApi() {
 
 if ConnectionCheck.isConnectedToNetwork() {
 
 let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
 print(url)
 Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
 .responseJSON { response in
 print(response.result.value as AnyObject)
 if let result = response.result.value as? [String: AnyObject] {
 if let statusCode = response.response?.statusCode {
 if statusCode == 200 {
 if let data = result["data"] as? [String: AnyObject] {
 if let favPlaces = data["FavouriteList"] as? [[String:AnyObject]] {
 self.favouriteLocationList = favPlaces.compactMap({ SearchLocation($0) })
 
 if !self.favouriteLocationList.isEmpty {
 self.profileView.tblFavourites.reloadData()
 
 self.profileView.tblHeightConstraint?.constant =  self.profileView.tblFavourites.contentSize.height
 
 self.view.setNeedsLayout()
 self.view.layoutIfNeeded()
 
 if (self.favouriteLocationList.first(where: {$0.nickName?.contains("Home") ?? false}) != nil) {
 self.profileView.btnAddHome.setTitleColor(.hexToColor("DADADA"), for: .normal)
 self.profileView.btnAddHome.isEnabled = false
 } else {
 self.profileView.btnAddHome.setTitleColor(.txtColor, for: .normal)
 self.profileView.btnAddHome.isEnabled = true
 }
 if (self.favouriteLocationList.first(where: {$0.nickName?.contains("Work") ?? false}) != nil) {
 self.profileView.btnAddHome.setTitleColor(.gray, for: .normal)
 if (self.favouriteLocationList.first(where: {$0.nickName?.contains("Home") ?? false}) != nil) {
 self.profileView.viewHomeWork.isHidden = true
 } else {
 self.profileView.viewHomeWork.isHidden = false
 }
 } else {
 self.profileView.viewHomeWork.isHidden = false
 }
 } else {
 self.profileView.tblHeightConstraint?.constant =  0
 }
 
 } else {
 self.profileView.tblHeightConstraint?.constant =  0
 }
 
 }
 }
 }
 }
 }
 }
 }
 
 
 func savefavouriteapicall(title name: String, location: SearchLocation) {
 if ConnectionCheck.isConnectedToNetwork() {
 NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
 var paramDict = Dictionary<String, Any>()
 
 paramDict["title"] = name
 paramDict["address"] = location.placeId
 paramDict["latitude"] = location.latitude
 paramDict["longitude"] = location.longitude
 
 
 let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
 print(url,paramDict)
 Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
 .responseJSON { response in
 NKActivityLoader.sharedInstance.hide()
 print(response.result.value as AnyObject)
 if let result = response.result.value as? [String: AnyObject] {
 if let statusCode = response.response?.statusCode {
 if statusCode == 200 {
 if let data = result["data"] as? [String: AnyObject] {
 
 self.navigationController?.view.showToast("txt_Fav_Add".localize())
 self.getFavouriteListApi()
 }
 } else {
 
 self.view.showToast("text_someting_went_wrong".localize())
 }
 }
 }
 }
 }
 }
 
 func deleteFavourite(_ slug: String) {
 if ConnectionCheck.isConnectedToNetwork() {
 NKActivityLoader.sharedInstance.show()
 let url = APIHelper.shared.BASEURL + APIHelper.deleteFavourite + "/" + slug
 print(url)
 Alamofire.request(url, method: .post, parameters: nil, headers: APIHelper.shared.authHeader)
 .responseJSON { response in
 NKActivityLoader.sharedInstance.hide()
 print(response.result.value as AnyObject)
 if let result = response.result.value as? [String: AnyObject] {
 print(result)
 if let statusCode = response.response?.statusCode {
 if statusCode == 200 {
 self.getFavouriteListApi()
 } else {
 self.view.showToast("txt_Fav_list_no_data".localize())
 }
 }
 
 } else {
 self.view.showToast("text_someting_went_wrong".localize())
 }
 }
 }
 }
 
 }
 
 extension ProfileVC: UITextFieldDelegate {
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
 replacementString string: String) -> Bool {
 if textField == self.profileView.txtFirstName {
 
 let maxLength = 15
 let currentString = textField.text! as NSString
 let newString =
 currentString.replacingCharacters(in: range, with: string)
 return newString.count <= maxLength
 
 }
 return true
 }
 }
 
 //MARK: - Favourite Table Delegate
 extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return self.favouriteLocationList.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteLocationsCell") as? FavouriteLocationsCell ?? FavouriteLocationsCell()
 cell.placenameLbl.text = favouriteLocationList[indexPath.row].nickName
 cell.placeaddLbl.text = favouriteLocationList[indexPath.row].placeId
 if let imageset = self.favouriteLocationList[indexPath.row].nickName {
 if imageset == "Home" {
 cell.placeImv.image = UIImage(named: "favHome")
 } else if imageset == "Work"{
 cell.placeImv.image = UIImage(named: "favWork")
 } else {
 cell.placeImv.image = UIImage(named: "favorOthers")
 }
 }
 
 cell.favDeleteBtn.isHidden = false
 cell.deleteAction = {[weak self] in
 self?.deleteFavourite(self?.favouriteLocationList[indexPath.row].slug ?? "")
 }
 return cell
 }
 
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 return UITableView.automaticDimension
 }
 
 func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
 return 60
 }
 }
 
 // To resize the captured image
 extension UIImage {
 func resized(withPercentage percentage: CGFloat) -> UIImage? {
 let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
 UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
 defer { UIGraphicsEndImageContext() }
 draw(in: CGRect(origin: .zero, size: canvasSize))
 return UIGraphicsGetImageFromCurrentImageContext()
 }
 func resized(toWidth width: CGFloat) -> UIImage? {
 let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
 UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
 defer { UIGraphicsEndImageContext() }
 draw(in: CGRect(origin: .zero, size: canvasSize))
 return UIGraphicsGetImageFromCurrentImageContext()
 }
 }
 */
