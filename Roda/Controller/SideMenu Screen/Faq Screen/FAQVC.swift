//
//  FAQVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 30/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class FAQVC: UIViewController {
    
    private let faqView = FAQView()
    
    private var faqList:[FAQ]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getFAQLists()
        self.setupViews()
        self.setupTarget()
    }
    
    func setupViews() {
        faqView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        faqView.faqTb.delegate = self
        faqView.faqTb.dataSource = self
        faqView.faqTb.register(FAQCell.self, forCellReuseIdentifier: "FAQCell")
        faqView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
    }
    
    @objc func backBtnAction(_ sender: UIButton){
        self.faqList = nil
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table view data source
extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell") as? FAQCell ?? FAQCell()
        cell.selectionStyle = .none
        cell.questionLbl.text = faqList?[indexPath.row].question
        cell.answerLbl.isHidden = !(faqList?[indexPath.row].isExpanded ?? false)
        if !(faqList?[indexPath.row].isExpanded ?? false) {
            cell.expandBtn.setImage(UIImage(named: "downArrowLight"), for:.normal)
        } else {
            cell.expandBtn.setImage(UIImage(named: "upArrow"), for:.normal)
        }
        
        cell.expandBtn.tag = indexPath.row
        cell.expandBtn.addTarget(self, action: #selector(expandBtnAction(_:)), for: .touchUpInside)
        cell.answerLbl.text = faqList?[indexPath.row].answer
        return cell
    }
    
    @objc func expandBtnAction(_ sender: UIButton) {
        if var selectedFaq = self.faqList?[sender.tag] {
            selectedFaq.isExpanded = !(selectedFaq.isExpanded)
            self.faqList?[sender.tag] = selectedFaq
            self.faqView.faqTb.reloadData()
        }
        
    }
    
}

//MARK:- API'S
extension FAQVC {
    
    func getFAQLists() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.getFAQList
            print(url,APIHelper.shared.authHeader)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let faqList  = data["faq"] as? [[String: AnyObject]] {
                                self.faqList = faqList.compactMap({ FAQ($0) })
                                DispatchQueue.main.async {
                                    self.faqView.faqTb.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func forceLogout() {
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
    
}

