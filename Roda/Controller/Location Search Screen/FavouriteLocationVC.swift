//
//  FavouriteLocationVC.swift
//  Roda
//
//  Created by Apple on 14/04/22.
//

import UIKit
import Alamofire
class FavouriteLocationVC: UIViewController {

    let favouriteView = FavouriteLocationView()
    
    var selectedLocation: SearchLocation?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        self.favouriteView.lblAddress.text = self.selectedLocation?.placeId
    }
    
    func setupViews() {
        favouriteView.setupViews(Base: self.view)
        favouriteView.btnHome.addTarget(self, action: #selector(btnFavTypePressed(_ :)), for: .touchUpInside)
        favouriteView.btnWork.addTarget(self, action: #selector(btnFavTypePressed(_ :)), for: .touchUpInside)
        favouriteView.btnOthers.addTarget(self, action: #selector(btnFavTypePressed(_ :)), for: .touchUpInside)
        favouriteView.btnCancel.addTarget(self, action: #selector(btnCancelPressed(_ :)), for: .touchUpInside)
        favouriteView.btnSave.addTarget(self, action: #selector(btnSavePressed(_ :)), for: .touchUpInside)
    }

    @objc func btnFavTypePressed(_ sender: UIButton) {
        self.favouriteView.btnHome.isSelected = false
        self.favouriteView.btnWork.isSelected = false
        self.favouriteView.btnOthers.isSelected = false
        if sender == self.favouriteView.btnOthers {
            
        }
        sender.isSelected = true
    }
    
    @objc func btnCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnSavePressed(_ sender: UIButton) {
        self.saveLocation()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - API'S
extension FavouriteLocationVC {
    
    func saveLocation() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String, Any>()

            if self.favouriteView.btnHome.isSelected {
                paramDict["title"] = "Home"
            } else if self.favouriteView.btnWork.isSelected {
                paramDict["title"] = "Work"
            } else {
                paramDict["title"] = "Other"
            }
            
            paramDict["address"] = self.selectedLocation?.placeId
            paramDict["latitude"] = self.selectedLocation?.latitude
            paramDict["longitude"] = self.selectedLocation?.longitude
           

            let url = APIHelper.shared.BASEURL + APIHelper.getFaourite
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                self.dismiss(animated: true) {
                                    self.navigationController?.view.showToast("txt_location_added_favoList".localize())
                                }
                            } else {
                                if let errMsg = result["error_message"] as? String {
                                    self.showAlert("", message: errMsg)
                                } else if let message = result["message"] as? String {
                                    self.showAlert("", message: message)
                                }
                            }
                        }
                    }
            }
        } else {
            
        }
    }
}
