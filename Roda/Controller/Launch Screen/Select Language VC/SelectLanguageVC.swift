//
//  SelectLanguageVC.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SelectLanguageVC: UIViewController {

    private let selectLanguageView = SelectLanguageView()
    
    private var selectedLang: AvailableLanguageModel?
    var availableLanguage = [AvailableLanguageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.setupData()
    }
    
    func setupViews() {
        self.selectLanguageView.setupViews(Base: self.view)
        self.setupTarget()
    }

    func setupTarget() {
        selectLanguageView.tblLanguages.delegate = self
        selectLanguageView.tblLanguages.dataSource = self
        selectLanguageView.tblLanguages.register(SelectLanguageCell.self, forCellReuseIdentifier: "languagecell")
        selectLanguageView.btnSetLanguage.addTarget(self, action: #selector(btnSetLanguagePressed(_ :)), for: .touchUpInside)

    }

    func setupData() {
        self.selectLanguageView.lblChooseLanguage.text = "txt_choose_language".localize()
        self.selectLanguageView.btnSetLanguage.setTitle("txt_set_lang".localize().uppercased(), for: .normal)
        self.selectedLang = self.availableLanguage.first
        self.selectLanguageView.tblLanguages.reloadData()
    }
}


extension SelectLanguageVC {
    
    @objc func btnSetLanguagePressed(_ sender: UIButton) {
        if let lang = self.selectedLang {
            APIHelper.shared.currentLangDate = lang.updateTime ?? 0.00
            self.getSelectLanguage(LangCode: lang.code ?? "")
        }
    }
}

extension SelectLanguageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languagecell") as? SelectLanguageCell ?? SelectLanguageCell()
        cell.selectionStyle = .none
        cell.lblLanguage.text = self.availableLanguage[indexPath.row].name
        if let langCode = self.availableLanguage[indexPath.row].code {
            cell.lblIdentifier.text = " ( " + langCode.uppercased()  + " )"
        }
      
        if self.selectedLang?.code == self.availableLanguage[indexPath.row].code {
            cell.btnCheck.image = UIImage(named: "ic_check")
        } else {
            cell.btnCheck.image = UIImage(named: "ic_uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLang = self.availableLanguage[indexPath.row]
        tableView.reloadData()
    }
}

extension SelectLanguageVC {
    func getSelectLanguage(LangCode: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            let url = APIHelper.shared.BASEURL + APIHelper.getAppCountryLangData + "/" + LangCode
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    print("response for languages",response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
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
                                    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
                                    NotificationCenter.default.post(name: NSNotification.Name("language files downloaded"), object: nil)
                                    self.navigationController?.pushViewController(PageVC(), animated: true)
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

