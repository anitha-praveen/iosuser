//
//  SuggestionVC.swift
//  Taxiappz
//
//  Created by Apple on 23/12/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SuggestionVC: UIViewController {
    
    private let suggestionView = SuggestionView()

    private var selectedSuggestionType: Complaint?
    
    private var complaintsList: [Complaint]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.getSuggestionList()
        self.setUpViews()
        
    }

    func setUpViews() {
        suggestionView.setupViews(Base: self.view)
        suggestionView.tblSuggestionList.delegate = self
        suggestionView.tblSuggestionList.dataSource = self
        suggestionView.tblSuggestionList.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionReasonCell")
        self.setupTarget()
    }

    func setupTarget() {
        suggestionView.suggestiontxtView.delegate = self
        suggestionView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        suggestionView.submitBtn.addTarget(self, action: #selector(submitBtnPressed(_ :)), for: .touchUpInside)
        suggestionView.viewSuggestionType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewComplaintTypePressed(_ :))))

       
        
    }
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.complaintsList = nil
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func viewComplaintTypePressed(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if self.complaintsList?.count == 0 {
            self.showAlert("text_Alert".localize(), message:"text_no_suggestionType".localize())
        } else {
            suggestionView.blurView.isHidden = false
        }
    }
    
    @objc func submitBtnPressed(_ sender: UIButton) {
        if selectedSuggestionType == nil {
            self.showAlert("", message: "txt_select_type_sugg".localize())
        } else if self.suggestionView.suggestiontxtView.text.count == 0 {
            self.showAlert("", message: "text_sugg_txt_type".localize())
        } else {
            self.saveSuggesstion()
        }
    }
}

extension SuggestionVC {
    
    func getSuggestionList() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.getSuggestionList
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let complaintList  = data["suggestion"] as? [[String: AnyObject]] {
                                self.complaintsList = complaintList.compactMap({Complaint($0)})
                                
                                self.suggestionView.tblSuggestionList.reloadData()
                                
                                if self.suggestionView.tblSuggestionList.contentSize.height > self.suggestionView.tblCoverView.frame.size.height {
                                    
                                    self.suggestionView.tblSuggestionList.heightAnchor.constraint(equalToConstant: self.suggestionView.tblCoverView.frame.size.height).isActive = true
                                    
                                } else {
                                    self.suggestionView.tblSuggestionList.heightAnchor.constraint(equalToConstant: self.suggestionView.tblSuggestionList.contentSize.height).isActive = true
                                }
                               
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
            }
        }
    }

    func saveSuggesstion() {
        
    }
    
}

//MARK:- TABLE DELEGATES
extension SuggestionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.complaintsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionReasonCell") ?? UITableViewCell()
        cell.textLabel?.text = self.complaintsList?[indexPath.row].title
        
        if self.selectedSuggestionType?.slug == self.complaintsList?[indexPath.row].slug {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSuggestionType = self.complaintsList?[indexPath.row]
        self.suggestionView.lblSuggestionType.text = self.selectedSuggestionType?.title
        self.suggestionView.tblSuggestionList.reloadData()
        self.suggestionView.blurView.isHidden = true
    }
    
}

extension SuggestionVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (self.suggestionView.suggestiontxtView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 200
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


