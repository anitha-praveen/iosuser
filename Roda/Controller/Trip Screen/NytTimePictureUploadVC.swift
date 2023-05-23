//
//  NytTimePictureUploadVC.swift
//  Roda
//
//  Created by Apple on 07/07/22.
//

import UIKit
import Alamofire
import Kingfisher
class NytTimePictureUploadVC: UIViewController {
    
    let pictureUploadView = NytTimePictureUploadView()
    
    var driverImage = ""
    var requestID = ""
    
    var retakePhoto = false
    override func viewDidLoad() {
        
        MySocketManager.shared.socketDelegate = self
        pictureUploadView.setupViews(Base: self.view)
        
    
        if retakePhoto {
            self.pictureUploadView.driverImage.isHidden = true
            self.pictureUploadView.btnRetake.isHidden = true
            
            self.pictureUploadView.lblUploadPhotoHint.text = "txt_retake_desc_user".localize()
          
        } else {
            self.pictureUploadView.driverImage.isHidden = false
            self.pictureUploadView.btnRetake.isHidden = false
            
            if driverImage != "" {
                if let url = URL(string: driverImage) {
                    let resource = ImageResource(downloadURL: url)
                    pictureUploadView.driverImage.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"))
                }
            }
        }
        setupTarget()
    }
    
    func setupTarget() {
        pictureUploadView.btnProceed.addTarget(self, action: #selector(takePicture(_ :)), for: .touchUpInside)
        pictureUploadView.btnRetake.addTarget(self, action: #selector(btnRetakePressed(_ :)), for: .touchUpInside)
    }
    
    @objc func takePicture(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            self.present(picker,animated: true,completion: nil)
        }
    }
    
    @objc func btnRetakePressed(_ sender: UIButton) {
        self.requestRetakeDriverPicture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true)
        }
    }
    
}

//MARK: -ImagePicker
extension NytTimePictureUploadVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            self.uploadPhoto(orientationImg)
            
        } else if let selectedImage = info[.editedImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            self.uploadPhoto(orientationImg)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: -API'S
extension NytTimePictureUploadVC {
    
    func uploadPhoto(_ originalImage: UIImage) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = self.requestID
            
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.uploadNytTimePhoto, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
           
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let imgData = originalImage.pngData() {
                    multipartFormData.append(imgData, withName: "images", fileName: "picture.png", mimeType: "image/png")
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
                        print("RESPONSE",response.result.value as Any, response.response?.statusCode as Any)
                        if case .failure(let error) = response.result {
                            print("ERROR",error.localizedDescription)
                            self.view.showToast(error.localizedDescription)
                        }
                        else if case .success = response.result {
                            
                            if let result = response.result.value as? [String: AnyObject] {
                                if let statusCode = response.response?.statusCode {
                                    if statusCode == 200 {
                                        self.dismiss(animated: true)
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
                case .failure(let encodingError):
                    
                    NKActivityLoader.sharedInstance.hide()
                    self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                }
            })
            
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    
    func requestRetakeDriverPicture() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "")
            
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = self.requestID
         
            let url = APIHelper.shared.BASEURL + APIHelper.retakeDriverPhoto
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                
                switch response.result {
                case .success(_):
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode,statusCode == 200 {
                            
                            self.view.showToast("Request submited!")
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
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
}

//MARK: -SOCKET DELEGATE
extension NytTimePictureUploadVC: MySocketManagerDelegate {
    func nytTimePhotoSkipped(_ response: [String : AnyObject]) {
        print("nytTimePhotoSkipped",response)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploaduserPhoto(_ response: [String : AnyObject]) {
        print("Upload User photo",response)
        if let result = response["result"] as? [String: AnyObject] {
            if let uploadStatus = result["upload_status"] as? Bool, uploadStatus {
                
                if let driverImg = result["upload_image_url"] as? String {
                    self.driverImage = driverImg
                    if let url = URL(string: driverImage) {
                        let resource = ImageResource(downloadURL: url)
                        pictureUploadView.driverImage.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"))
                    }
                }

            }
        }
    }
}

