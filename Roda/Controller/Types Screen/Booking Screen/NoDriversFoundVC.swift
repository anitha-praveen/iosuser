//
//  NoDriversFoundVC.swift
//  Roda
//
//  Created by Apple on 10/06/22.
//

import UIKit
import Alamofire
class NoDriversFoundVC: UIViewController {

    let noDriversView = NoDriversFoundView()
    
    var reqID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Your ride id",reqID)
        noDriversView.setupViews(Base: self.view)
        noDriversView.btnCallUs.addTarget(self, action: #selector(btnCallPressed(_ :)), for: .touchUpInside)
        noDriversView.btnClose.addTarget(self, action: #selector(btnClosePressed(_ :)), for: .touchUpInside)
        noDriversView.btnCancelTrip.addTarget(self, action: #selector(cancelBtnAction(_ :)), for: .touchUpInside)
    }
    
    @objc func btnCallPressed(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "tel://" + ("txt_admin_number".localize())) {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
   
    @objc func btnClosePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @objc func cancelBtnAction(_ sender: UIButton) {
        
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_cancelling_request".localize())
            var paramDict = Dictionary<String, Any>()
           
            paramDict["request_id"] = self.reqID
            paramDict["custom_reason"] = "User Cancelled"
            

            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.cancelRide
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            
                            self.dismiss(animated: true, completion: nil)
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
