//
//  LogoutVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 26/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class LogoutVC: UIViewController {
    
    private let viewContent = UIView()
    private let appNameLbl = UILabel()
    private let textLbl = UILabel()
    private let cancelBtn = UIButton()
    private let okBtn = UIButton()
        
    var layoutDic = [String: AnyObject]()
    
    var deleteAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.7)
        
        viewContent.backgroundColor = .secondaryColor
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewContent"] = viewContent
        self.view.addSubview(viewContent)
        
        appNameLbl.text = APIHelper.shared.appName?.uppercased()
        appNameLbl.textAlignment = .center
        appNameLbl.font = UIFont.appSemiBold(ofSize: 28)
        appNameLbl.textColor = .txtColor
        appNameLbl.backgroundColor = .secondaryColor
        appNameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["appNameLbl"] = appNameLbl
        viewContent.addSubview(appNameLbl)
        
        if deleteAccount {
            textLbl.text = "txt_delete_account_desc".localize()
        } else {
            textLbl.text = "text_desc_logout".localize()
        }
        textLbl.numberOfLines = 0
        textLbl.lineBreakMode = .byWordWrapping
        textLbl.textAlignment = .center
        textLbl.font = UIFont.appRegularFont(ofSize: 18)
        textLbl.textColor = .txtColor
        textLbl.backgroundColor = .secondaryColor
        textLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["textLbl"] = textLbl
        viewContent.addSubview(textLbl)
        
        cancelBtn.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        cancelBtn.backgroundColor = .hexToColor("D9D9D9")
        cancelBtn.layer.cornerRadius = 8
        cancelBtn.setTitleColor(.txtColor, for: .normal)
        cancelBtn.setTitle("text_cancel".localize(), for: .normal)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cancelBtn"] = cancelBtn
        viewContent.addSubview(cancelBtn)
        
        
        okBtn.setTitle("text_ok".localize().uppercased(), for: .normal)
        okBtn.layer.cornerRadius = 8
        okBtn.addTarget(self, action: #selector(okBtnAction(_ :)), for: .touchUpInside)
        okBtn.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        okBtn.setTitleColor(.themeTxtColor, for: .normal)
        okBtn.backgroundColor = .themeColor
        okBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["okBtn"] = okBtn
        viewContent.addSubview(okBtn)
        
       
        viewContent.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[appNameLbl(30)]-(15)-[textLbl]-(20)-[cancelBtn(35)]-15-|", options: [], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[appNameLbl]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[textLbl]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[cancelBtn]-(10)-[okBtn(==cancelBtn)]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        
    }
    
    @objc func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func okBtnAction(_ sender: UIButton) {
        self.logoutapicall()
    }
    
    func logoutapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_logging _out".localize())
           
            var url = ""
            if deleteAccount {
                url = APIHelper.shared.BASEURL + APIHelper.deleteAccount
            } else {
                url = APIHelper.shared.BASEURL + APIHelper.logoutUser
            }
            
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    
                    NKActivityLoader.sharedInstance.hide()
                    switch response.result {
                    case .failure(_):
                        self.view.showToast("txt_sry_unable_logout".localize())
                    case .success(_):
                        print(response.result.value as AnyObject)
                        if response.response?.statusCode == 200 {
                            AppLocationManager.shared.stopTracking()
                            APIHelper.shared.deleteUser()
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
                    
                    }
                
            }
        } else {
           
            self.showAlert( "txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func forceLogout() {
        if let root = self.revealViewController().navigationController {
            
            let firstvc = Initialvc()
            root.setViewControllers([firstvc], animated: false)
            
        }
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
    
}
