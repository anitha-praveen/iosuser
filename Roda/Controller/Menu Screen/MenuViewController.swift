//
//  menuViewController.swift
//  tapngo
//
//  Created by Mohammed Arshad on 05/10/17.
//  Copyright © 2017 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher

class MenuViewController: UIViewController {

    private let menuView = MenuView()
    
    private var menuList = [MenuType]()
    
    var currentAppDirection = APIHelper.appLanguageDirection

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
        menuList = MenuType.allCases
        
        self.setUpViews()
        self.setupTarget()
        
    }

    func setUpViews() {
        menuView.setupViews(Base: self.view, controller: self)
        menuView.greetingsLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfile(_ :))))
        menuView.btnSos.addTarget(self, action: #selector(btnSosPressed(_ :)), for: .touchUpInside)
    }
    
    func setupTarget() {
        menuView.menulistTableview.delegate = self
        menuView.menulistTableview.dataSource = self
        menuView.menulistTableview.register(MenuTVCell.self, forCellReuseIdentifier: "MenuTVCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentAppDirection != APIHelper.appLanguageDirection {
            currentAppDirection = APIHelper.appLanguageDirection
            
            setUpViews()
            self.menuView.menulistTableview.reloadData()
        }
      
        self.getuserdetails()

        self.menuView.menulistTableview.reloadData()
        if let frontVC = self.revealViewController().frontViewController as? UINavigationController {
            if let topVC = frontVC.topViewController as? TaxiPickupVC {
                topVC.sideMenuHideBtn.isHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let frontVC = self.revealViewController().frontViewController as? UINavigationController, let topVC = frontVC.viewControllers.first(where: { $0 is TaxiPickupVC }) as? TaxiPickupVC {
            topVC.sideMenuHideBtn.isHidden = true
        }
    }
}

extension MenuViewController {
    
    func getuserdetails() {
        // ------S3 Bucket
//        if LocalDB.profilePicData != nil {
//            self.menuView.profilepictureiv.image = UIImage(data: LocalDB.profilePicData ?? Data())
//        } else {
//            if let imgStr = APIHelper.shared.userDetails?.profilePictureUrl {
//                self.menuView.activityIndicator.startAnimating()
//                self.retriveImg(key: imgStr) { data in
//                    self.menuView.activityIndicator.stopAnimating()
//                    LocalDB.profilePicData = data
//                    self.menuView.profilepictureiv.image = UIImage(data: data)
//                }
//            } else {
//                self.menuView.activityIndicator.stopAnimating()
//                self.menuView.profilepictureiv.image = UIImage(named: "signup_profile_img")
//            }
//        }
        
        if let imgStr = APIHelper.shared.userDetails?.profilePictureUrl, let url = URL(string: imgStr) {
            self.menuView.profilepictureiv.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            self.menuView.profilepictureiv.kf.setImage(with: resource, placeholder: UIImage(named: "signup_profile_img"), options: nil, progressBlock: nil, completionHandler: nil)
           
        } else {
            self.menuView.profilepictureiv.image = UIImage(named: "signup_profile_img")
        }
        
        
        
        if let fn = APIHelper.shared.userDetails?.firstName {
            self.menuView.profileusernamelbl.text = fn
            self.menuView.profileusernamelbl.sizeToFit()
        }
        
    }
    
    @objc func goToProfile(_ sender: UITapGestureRecognizer) {
        guard let frontVC = self.revealViewController().frontViewController as? UINavigationController, let topVC = frontVC.topViewController else {
            return
        }
        APIHelper.appLanguageDirection == .directionLeftToRight ? self.revealViewController().revealToggle(animated: true) : self.revealViewController().rightRevealToggle(animated: true)

        topVC.view.isUserInteractionEnabled = true

        self.navigationController?.pushViewController(ProfileVC(), animated: true)
    }
    
    @objc func btnSosPressed(_ sender: UIButton) {
        guard let frontVC = self.revealViewController().frontViewController as? UINavigationController, let topVC = frontVC.topViewController else {
            return
        }
        APIHelper.appLanguageDirection == .directionLeftToRight ? self.revealViewController().revealToggle(animated: true) : self.revealViewController().rightRevealToggle(animated: true)

        topVC.view.isUserInteractionEnabled = true

        self.navigationController?.pushViewController(SOSViewController(), animated: true)
    }
   
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Tableview delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell") as? MenuTVCell ?? MenuTVCell()
        
        cell.selectionStyle = .none
        cell.setUpViews()
        cell.lblname.text = menuList[indexPath.row].title
        cell.img.image = menuList[indexPath.row].icon
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let frontVC = self.revealViewController().frontViewController as? UINavigationController, let topVC = frontVC.topViewController else {
            return
        }
        APIHelper.appLanguageDirection == .directionLeftToRight ? self.revealViewController().revealToggle(animated: true) : self.revealViewController().rightRevealToggle(animated: true)

        topVC.view.isUserInteractionEnabled = true

        if menuList[indexPath.row] == .history {
            
            frontVC.pushViewController(HistoryVC(), animated: true)
        }
//        else if menuList[indexPath.row] == .wallet {
//
//            frontVC.pushViewController(WalletVC(), animated: true)
//        }
        else if menuList[indexPath.row] == .notification {
            frontVC.pushViewController(NotificationVC(), animated: true)

        } else if menuList[indexPath.row] == .support {
            
            frontVC.pushViewController(SupportVC(), animated: true)
           
        }
//        else if menuList[indexPath.row] == .suggestion {
//
//            frontVC.pushViewController(SuggestionVC(), animated: true)
//
//        }
        else if menuList[indexPath.row] == .referral {
            
            frontVC.pushViewController(ReferralVC(), animated: true)
            
        } else if menuList[indexPath.row] == .selectLanguages {
            
            frontVC.pushViewController(SetLanguageVC(), animated: true)
            
        } else if menuList[indexPath.row] == .aboutus {
            
            frontVC.pushViewController(AboutusVC(), animated: true)
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
