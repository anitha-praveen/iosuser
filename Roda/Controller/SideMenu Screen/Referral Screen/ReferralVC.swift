//
//  ReferralVC.swift
//  Roda
//
//  Created by Apple on 26/04/22.
//

import UIKit
import Alamofire
class ReferralVC: UIViewController {

    private let referralView = ReferralView()
    
    private var currency = ""
    private var referralCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        referralView.setupViews(Base: self.view)
        getReferralDetails()
        setupTarget()
        
    }
    
    func setupTarget() {
        self.referralView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        self.referralView.btnShare.addTarget(self, action: #selector(btnSharePressed(_ :)), for: .touchUpInside)
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSharePressed(_ sender: UIButton) {
        let someText:String = "txt_use_my_referral".localize() + " \(self.referralCode)"
        let objectsToShare:URL = URL(string: "www.example.com")!
        
        let activityViewController = UIActivityViewController(activityItems: [someText as Any,objectsToShare as Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}

//MARK: - API's
extension ReferralVC {
    func getReferralDetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            let url = APIHelper.shared.BASEURL + APIHelper.getReferralDetails
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                switch response.result {
                case .success(_):
                    print(response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let currency = data["currency_symbol"] as? String {
                                self.currency = currency
                            }
                            
                            if let referAmount = data["refer_by_user_amount"] {
                                self.referralView.lblInviteHint.text = "txt_invite_content".localize() + " \(self.currency) \(referAmount)"
                            }
                            
                            if let totalAmt = data["referral_amount"] {
                                self.referralView.lblTotalAmount.text = self.currency + "\(totalAmt)"
                            }
                            if let code = data["referral_code"] as? String {
                                self.referralCode = code
                                self.referralView.lblRefferalCode.text = code
                            }
                        }
                    }
                case .failure(let error):
                    self.view.showToast(error.localizedDescription)
                    
                }
            }
        }
    }
}
