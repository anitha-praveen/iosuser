//
//  SupportVC.swift
//  Taxiappz
//
//  Created by spextrum on 29/12/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
class SupportVC: UIViewController {
    
    private let supportView = SupportView()
    
    private var supportList:[SupportMenuType]? = []
    
    private var contactNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.supportList = SupportMenuType.allCases
        setupViews()
        getAdminContact()
    }
    
    func setupViews() {
        supportView.setupViews(Base: self.view)
        supportView.tblSupport.delegate = self
        supportView.tblSupport.dataSource = self
        supportView.tblSupport.register(SupportCell.self, forCellReuseIdentifier: "SupportCell")
        supportView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        supportView.btnCallAdmin.addTarget(self, action: #selector(callBtnAction(_:)), for: .touchUpInside)
        
        supportView.tblSupport.reloadData()
        supportView.tblSupport.heightAnchor.constraint(equalToConstant: supportView.tblSupport.contentSize.height).isActive = true
    }
   
    @objc func backBtnPressed(_ sender: UIButton) {
        self.supportList = nil
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func callBtnAction(_ sender: UIButton) {
        let phNo = String((self.contactNumber ?? "").filter { !" \n\t\r".contains($0)})
        if let phoneCallURL = URL(string: "tel://" + phNo) {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

}
extension SupportVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.supportList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell") as? SupportCell ?? SupportCell()
        if let supportList = self.supportList?[indexPath.row] {
            cell.lblName.text = supportList.title
            cell.imgview.image = supportList.icon?.withRenderingMode(.alwaysTemplate)
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.supportList?[indexPath.row] == .complaint {
            let vc = ComplaintVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if self.supportList?[indexPath.row] == .sos {
            let vc = SOSViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        else if self.supportList?[indexPath.row] == .faq {
//            let vc = FAQVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

//MARK: - API'S
extension SupportVC {
    func getAdminContact() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            
            let url = APIHelper.shared.BASEURL + APIHelper.getAdminContact
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                if response.response?.statusCode == 200 {
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let contactNum = data["customer_care_number"] as? String {
                                self.contactNumber = contactNum
                                self.supportView.viewAdmin.isHidden = false
                            } else {
                                self.supportView.viewAdmin.isHidden = true
                            }
                        }
                     }
                }
             
            }
        }
    }
}
