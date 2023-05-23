//
//  sosvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 02/01/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SOSViewController: UIViewController {
    
    private let sosView = SOSView()
    
    private var sosList:[SOSContact]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.getSosLists()
        self.setUpViews()
        self.setupTarget()
    }

    func setUpViews() {
        sosView.setupViews(Base: self.view)
        sosView.sosDetailPhoneNumTxtfld.delegate = self
        sosView.sosDetailTitleTxtFld.delegate = self
    }
    
    func setupTarget() {
        sosView.soslisttbv.delegate = self
        sosView.soslisttbv.dataSource = self
        sosView.soslisttbv.register(SOSListTableViewCell.self, forCellReuseIdentifier: "SOSListTableViewCell")
        sosView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        sosView.addBtn.addTarget(self, action: #selector(addBtnAction(_ :)), for: .touchUpInside)
        sosView.sosDetailSubmitBtn.addTarget(self, action: #selector(submitBtnAction(_ :)), for: .touchUpInside)
    }
    
    @objc func backBtnAction(_ sender: UIButton){
        self.sosList = nil
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addBtnAction(_ sender: UIButton) {
        self.sosView.transparentView.isHidden = false
    }
    @objc func submitBtnAction(_ sender: UIButton) {
        if self.sosView.sosDetailTitleTxtFld.text == "" {
            self.showAlert("text_Alert".localize(), message: "txt_title_sos".localize())
        } else if self.sosView.sosDetailPhoneNumTxtfld.text == "" {
            self.showAlert("text_Alert".localize(), message: "txt_phone_cannot_be_empty".localize())
        } else {
            self.addSOSNumber()
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == sosView.transparentView {
            self.sosView.transparentView.isHidden = true
        }
    }
}


extension SOSViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sosList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SOSListTableViewCell") as? SOSListTableViewCell ?? SOSListTableViewCell()
        cell.sosnameLbl.text = self.sosList?[indexPath.row].name
        cell.sosnumberLbl.text = self.sosList?[indexPath.row].number
        
        cell.callAction = {[unowned self] in
            self.callToNUm(indexPath.row)
        }
        if self.sosList?[indexPath.row].createdBy != nil {
            
            cell.sosDeleteBtn.isHidden = false
            cell.deleteAction = {[unowned self] in
                self.deleteSosNum(indexPath.row)
            }
        } else {
            cell.sosDeleteBtn.isHidden = true
        }
        return cell
    }

    func callToNUm(_ row: Int) {
        if let num = self.sosList?[row].number, let phoneCallURL = URL(string: "tel://"+num) {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

    func deleteSosNum(_ row: Int) {
        guard let title = APIHelper.shared.appName else { return }
        let alert = UIAlertController(title: title.uppercased(), message: "txt_are_you_Delete_sos".localize(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "text_yes".localize(), style: .default, handler:{ _ in
            self.deleteSos(deleteId: self.sosList?[row].slug ?? "")
        }))
        alert.addAction(UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- API'S
extension SOSViewController {
    
    func getSosLists() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.getSOSList
            print(url,APIHelper.shared.authHeader)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let sos  = data["sos"] as? [[String: AnyObject]] {
                                self.sosList = sos.compactMap({SOSContact($0)})
                                DispatchQueue.main.async {
                                    self.sosView.soslisttbv.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addSOSNumber() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.addSOSNumber
            
            var paramDict = Dictionary<String, Any>()
            paramDict["phone_number"] = self.sosView.sosDetailPhoneNumTxtfld.text
            
            paramDict["title"] = self.sosView.sosDetailTitleTxtFld.text

            print(url,paramDict,APIHelper.shared.authHeader)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        
                        DispatchQueue.main.async {
                            self.sosView.sosDetailTitleTxtFld.text = ""
                            self.sosView.sosDetailPhoneNumTxtfld.text = ""
                            
                            self.sosView.transparentView.isHidden = true
                            
                        }
                        self.getSosLists()
                       
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
    
    func deleteSos(deleteId: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.deleteSOS + deleteId
            
            print(url,APIHelper.shared.authHeader)
            Alamofire.request(url, method: .delete, parameters: nil, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        self.getSosLists()
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
    
    func forceLogout() {
        if let root = self.navigationController?.revealViewController().navigationController {
            let firstvc = Initialvc()
            root.view.showToast("text_already_login".localize())
            root.setViewControllers([firstvc], animated: false)
        }
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
    
}

//MARK: - TEXTFIELD DELEGATES

extension SOSViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.alphanumerics.inverted
        let components = string.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        if string == filtered {
            return true
        } else {
            return false
        }
        
    }
}
