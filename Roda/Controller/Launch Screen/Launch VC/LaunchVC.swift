//
//  LaunchVC.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import Alamofire
import SWRevealViewController
import NVActivityIndicatorView
import SwiftyGif
import FirebaseDatabase
import IQKeyboardManagerSwift

class LaunchVC: UIViewController , SwiftyGifDelegate {

    private let launchView = LaunchView()
    private var ref: DatabaseReference!
    
    var availableLanguage = [AvailableLanguageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.setupTarget()
        self.getAvailLanguages()
       
    }
    
    func setupViews() {
        launchView.setupViews(Base: self.view)
    }

    func setupTarget() {
        launchView.logoImgView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.launchView.logoImgView.startAnimatingGif()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(networkCheck), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.launchView.logoImgView.stopAnimatingGif()
        NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)

    }
    
    @objc func networkCheck() {
        if availableLanguage.isEmpty {
            self.getAvailLanguages()
        }
    }
}


//MARK: API'S

extension LaunchVC {
    func getAvailLanguages() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            var paramDict = Dictionary<String, Any>()
            paramDict["code"] = APIHelper.appBaseCode
            
            let url = APIHelper.shared.BASEURL + APIHelper.getAppCountryLangData
            
            print("URL and Param For AvailLanguages",url, paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                print("reponse get AvailLanguages",response.result.value as Any)
                
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let placesKey = data["places_api_key"] as? String {
                                    APIHelper.shared.gmsPlacesKey = placesKey
                                }
                                if let directionKey = data["directional_api_key"] as? String {
                                    APIHelper.shared.gmsDirectionKey = directionKey
                                }
                                if let gmsServiceKey = data["geo_coder_api_key"] as? String {
                                    APIHelper.shared.gmsServiceKey = gmsServiceKey
                                }
                                if let languageAvailable = data["languages"] as? [[String: AnyObject]] {
                                    
                                    self.availableLanguage = languageAvailable.compactMap({AvailableLanguageModel($0)})
                                    
                                    RJKLocalize.shared.availableLanguages = self.availableLanguage.map({ ($0.code ?? "") })
                                    
                                    RJKLocalize.shared.availableLanguages.sort(by: <)
                                    
                                    if let currentLang = self.availableLanguage.first(where: {$0.code == APIHelper.currentAppLanguage}) {
                                        if currentLang.updateTime ?? 0.00 > APIHelper.shared.currentLangDate {
                                            APIHelper.shared.currentLangDate = currentLang.updateTime ?? 0.00
                                            self.getSelectLanguage(LangCode: APIHelper.currentAppLanguage)
                                            
                                        } else {
                                            self.redirect()
                                        }
                                    } else {
                                        self.redirect()
                                    }
                                }
                            }
                        } else {
                            if response.response?.statusCode == 426 {
                                self.navigationController?.pushViewController(UpdateVersionVC(), animated: true)
                            } else {
                                self.view.showToast("txt_sry_try_again".localize())
                            }
                            
                        }
                    }
                }
            }
        } else {
            self.showAlert("txt_NoInternet".localize(),message: "txt_NoInternet_title".localize())
        }
    }
    
    func getSelectLanguage(LangCode: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            let url = APIHelper.shared.BASEURL + APIHelper.getAppCountryLangData + "/" + LangCode
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    print("response for languages",response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: String] {
                                    print(data.count)
                                    if let json = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                                        let fileUrl = documentDirectoryUrl.appendingPathComponent("lang-\(LangCode).json")
                                        try? json.write(to: fileUrl, options: [])
                                        print(fileUrl)
                                    }
                                    RJKLocalize.shared.details = [:]
                                    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
                                    self.redirect()
                                    
                                }
                            } else {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
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
        } else {
            self.showAlert("txt_NoInternet".localize(),message: "txt_NoInternet_title".localize())
        }
    }
}


extension LaunchVC {
    func redirect() {
       
        if APIHelper.shared.userDetails != nil {
            
            let firstvc = Initialvc()
            let mainViewController = UINavigationController(rootViewController: firstvc)
            mainViewController.interactivePopGestureRecognizer?.isEnabled = false
            mainViewController.navigationBar.isHidden = true
            
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
            pickupVC.navigationController?.navigationBar.isHidden = true
            mainViewController.setViewControllers([firstvc, revealVC], animated: false)
            
            UIApplication.shared.windows.first?.rootViewController = mainViewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        } else {
            if APIHelper.shared.landingPage == "login" {
                let firstvc = Initialvc()
                firstvc.navigationController?.navigationBar.isHidden = true
                self.navigationController?.pushViewController(firstvc, animated: false)
            } else {
                let showCase = SelectLanguageVC() //PageVC()
                showCase.availableLanguage = self.availableLanguage
                let navVC = UINavigationController(rootViewController: showCase)
                navVC.interactivePopGestureRecognizer?.isEnabled = false
                showCase.navigationController?.navigationBar.isHidden = true
                self.navigationController?.pushViewController(showCase, animated: false)
            }
        }
       
    }
}



