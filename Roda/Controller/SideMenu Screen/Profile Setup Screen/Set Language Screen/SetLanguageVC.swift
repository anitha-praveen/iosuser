//
//  SetLanguageVC.swift
//  Taxiappz
//
//  Created by NPlus Technologies on 02/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SetLanguageVC: UIViewController {
    
    private let langView = SetLanguageView()
    
    typealias Option = (text: String, identifier: String,from: String)
    private var availableLanguageList: [Option]?
    private var selectedIndex: Int?
    private var selectedLanguage: Option?
    
    var currentLayoutDirection = APIHelper.appLanguageDirection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupData()
    }
    
    func setupViews() {
        langView.setupViews(Base: self.view)
        langView.tblLanguage.delegate = self
        langView.tblLanguage.dataSource = self
        langView.tblLanguage.register(SelectLanguageCell.self, forCellReuseIdentifier: "SelectLanguageCell")
        langView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        langView.btnSetLanguage.addTarget(self, action: #selector(btnSetLanguagePressed(_:)), for: .touchUpInside)
        
    }
    
    func setupData() {
        langView.lblTitle.text = "txt_choose_language".localize()
        langView.btnSetLanguage.setTitle("txt_set_lang".localize().uppercased(), for: .normal)
        
        self.availableLanguageList = RJKLocalize.shared.availableLanguages.compactMap ({
            let locale = NSLocale(localeIdentifier: $0)
            if let name = locale.displayName(forKey: NSLocale.Key.identifier, value: $0) {
                return (text: name,identifier:$0,from:"lang")
            } else {
                return nil
            }
        })
        
        if let languageList = self.availableLanguageList?.first(where: { $0.identifier == APIHelper.currentAppLanguage }) {
            self.selectedLanguage = languageList
            self.selectedIndex = availableLanguageList?.firstIndex(where: { $0 == languageList})
        }
        self.langView.tblLanguage.reloadData()
    }
}

extension SetLanguageVC {
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSetLanguagePressed(_ sender: UIButton) {
        //self.getLanguage(LangCode: selectedLanguage?.identifier ?? "")
        self.updateAppLanguage()
    }
}

extension SetLanguageVC {
    func getLanguage(LangCode: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            let url = APIHelper.shared.BASEURL + APIHelper.getAppCountryLangData + "/" + LangCode
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    print("response for languages",response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                APIHelper.currentAppLanguage = LangCode
                                if let data = result["data"] as? [String: String] {
                                    print(data.count)
                                    if let json = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                                        let fileUrl = documentDirectoryUrl.appendingPathComponent("lang-\(LangCode).json")
                                        try? json.write(to: fileUrl, options: [])
                                        print(fileUrl)
                                    }
                                    RJKLocalize.shared.details = [:]
                                    self.redirectSetupLayout()
                                    
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
            self.showAlert("txt_NoInternet".localize(), message: "txt_NoInternet_title".localize())
        }
    }
    
    func updateAppLanguage() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_updating".localize())
            var paramDict = Dictionary<String,Any>()
            paramDict["language"] = selectedLanguage?.identifier
            
            let url = APIHelper.shared.BASEURL + APIHelper.updateAppLanguage
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                switch response.result {
                case .success(_):
                    if response.response?.statusCode == 200 {
                        self.getLanguage(LangCode: self.selectedLanguage?.identifier ?? "")
                    } else {
                        self.showAlert("", message: "txt_sry_cant_change_appLang".localize())
                    }
                case .failure(_):
                    self.showAlert("", message: "txt_sry_cant_change_appLang".localize())
                }
                
            }
        }
    }
    
    func redirectSetupLayout() {
        if currentLayoutDirection != APIHelper.appLanguageDirection {
            currentLayoutDirection = APIHelper.appLanguageDirection
            if APIHelper.appLanguageDirection == .directionLeftToRight {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
            }
        }
        
        if let taxiPickupVC = self.navigationController?.viewControllers.first(where: { $0 is TaxiPickupVC }) as? TaxiPickupVC,
           let revealVC = taxiPickupVC.revealViewController() {
            if  APIHelper.appLanguageDirection == .directionLeftToRight {
                revealVC.rearViewController = MenuViewController()
                revealVC.rightViewController = nil
            } else {
                revealVC.rearViewController = nil
                revealVC.rightViewController = MenuViewController()
            }
        }
        UIApplication.shared.keyWindow?.rootViewController = LaunchVC()
//        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension SetLanguageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableLanguageList == nil ? 0 : availableLanguageList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLanguageCell") as? SelectLanguageCell ?? SelectLanguageCell()
        cell.selectionStyle = .none
        cell.lblLanguage.text = availableLanguageList![indexPath.row].text
        cell.lblIdentifier.text = " (" + (availableLanguageList?[indexPath.row].identifier)!.uppercased() + " )"
        if let option = self.selectedLanguage, option == (availableLanguageList?[indexPath.row])! {
            cell.btnCheck.image = UIImage(named: "ic_check")
        } else {
            cell.btnCheck.image = UIImage(named: "ic_uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = availableLanguageList![indexPath.row]
        tableView.reloadData()
    }
}

