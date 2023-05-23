//
//  NotificationVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 18/05/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher
import DSGradientProgressView
class NotificationVC: UIViewController {
    
    private let notificationView = NotificationView()

    private var notificationList:[NotificationList]? = []
    
    private var currentPage = 1
    private var totalPages = 1
    
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        getNotification()
    }
    
    func setupViews() {
        notificationView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        notificationView.setupViews(Base: self.view, controller: self)
        notificationView.tblNotification.delegate = self
        notificationView.tblNotification.dataSource = self
        notificationView.tblNotification.register(NotificationTableCell.self, forCellReuseIdentifier: "notificationcell")
    }

    @objc func backBtnAction(_ sender: UIButton){
        self.notificationList = nil
        self.navigationController?.popViewController(animated: true)
    }
}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationcell") as? NotificationTableCell ?? NotificationTableCell()
        cell.lblTitle.text = self.notificationList?[indexPath.row].title
        cell.lblMsg.text = self.notificationList?[indexPath.row].message
        cell.lblDate.text = self.notificationList?[indexPath.row].date
        if let imgStr = self.notificationList?[indexPath.row].image, let url = URL(string: imgStr) {
            let resource = ImageResource(downloadURL: url)
            cell.imgview.kf.setImage(with: resource,placeholder: UIImage(named: "bell"))
        } else {
            cell.imgview.image = UIImage(named: "bell")
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let value = scrollView.contentOffset.y
        if value > (self.notificationView.tblNotification.contentSize.height - 150 - scrollView.frame.size.height) {
            if currentPage < totalPages && !isLoading {
                self.notificationView.tblNotification.tableFooterView = createSpinner()
                self.currentPage += 1
                
                self.getNotification()
                
            }
        } else {
            
            self.notificationView.tblNotification.tableFooterView = nil
        }
    }
    
    func createSpinner() -> UIView {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: notificationView.tblNotification.frame.width, height: 50))
        customView.backgroundColor = UIColor.clear
        let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:customView.frame.width,height:50))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.appRegularFont(ofSize: 14)
        titleLabel.text  = "txt_loading".localize()
        customView.addSubview(titleLabel)
        
        return customView
    }
}

// MARK: - API'S
extension NotificationVC {
    func getNotification() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            notificationView.progressView.wait()
            self.isLoading = true
          
            let url = APIHelper.shared.BASEURL + APIHelper.getNotificationList + "?page=\(currentPage)"
            print("URL",url)
           
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                self.notificationView.progressView.signal()
                switch response.result {
                
                case .success(_):
                    print(response.result.value as Any)
                    
                    if response.response?.statusCode == 200 {
                        if let result = response.result.value as? [String:Any] {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let notificationData = data["data"] as? [[String: AnyObject]] {
                                    
                                    self.notificationList?.append(contentsOf: notificationData.compactMap({NotificationList($0)}))
                                    if self.notificationList?.count == 0 {
                                        self.setupNote()
                                    } else {
                                        DispatchQueue.main.async {
                                            self.notificationView.tblNotification.reloadData()
                                            self.notificationView.tblNotification.tableFooterView = nil
                                            self.isLoading = false
                                        }
                                        
                                    }
                                    if let totalPages = data["last_page"] as? Int {
                                        self.totalPages = totalPages
                                    }
                                    
                                }
                            }
                         }
                    } else {
                        self.setupNote()
                    }
                    
                case .failure(let error):
                    self.view.showToast(error.localizedDescription)
                    self.setupNote()
                }
                
            }
        } else {
           
            self.showAlert( "txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func setupNote() {
        self.notificationView.msgView.isHidden = false
        
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

struct NotificationList {
    var title: String?
    var subTitle: String?
    var message: String?
    var image: String?
    var date: String?
    init(_ dict: [String: AnyObject]) {
        if let title = dict["title"] as? String {
            self.title = title
        }
        if let subTitle = dict["sub_title"] as? String {
            self.subTitle = subTitle
        }
        if let msg = dict["message"] as? String {
            self.message = msg
        }
        if let image = dict["images1"] as? String {
            self.image = image
        }
        if let date = dict["date"] as? String {
            self.date = date
        }
    }
}
