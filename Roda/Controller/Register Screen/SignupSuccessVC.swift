//
//  SignupSuccessVC.swift
//  Taxiappz
//
//  Created by Apple on 26/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import SWRevealViewController
import CoreLocation

class SignupSuccessVC: UIViewController {
    
    private let imgView = UIImageView()
    private let lblHint = UILabel()
    private let lblDescription = UILabel()
    private let btnGetStarted = UIButton()

    var layoutDict = [String: AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    func setupViews() {
        
        self.view.backgroundColor = .hexToColor("FD6F70")
    
        imgView.image = UIImage(named: "success")
        imgView.contentMode = .scaleAspectFit
        layoutDict["imgView"] = imgView
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imgView)
        
        lblHint.textAlignment = .center
        lblHint.text = "txt_ready_go".localize()
        lblHint.textColor = .txtColor
        lblHint.font = UIFont.appSemiBold(ofSize: 30)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblHint)
        
        lblDescription.textAlignment = .center
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.text = "txt_thanks_create".localize()
        lblDescription.textColor = .txtColor
        lblDescription.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["lblDescription"] = lblDescription
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lblDescription)
        
        btnGetStarted.layer.cornerRadius = 5
        btnGetStarted.addTarget(self, action: #selector(btnGetStartedPressed(_ :)), for: .touchUpInside)
        btnGetStarted.setTitle("txt_get_start".localize().uppercased(), for: .normal)
        btnGetStarted.setTitleColor(.themeColor, for: .normal)
        btnGetStarted.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnGetStarted.backgroundColor = .secondaryColor
        layoutDict["btnGetStarted"] = btnGetStarted
        btnGetStarted.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnGetStarted)
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[imgView(100)]-23-[lblHint(40)]-16-[lblDescription]-50-[btnGetStarted(50)]", options: [], metrics: nil, views: layoutDict))
        

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
         self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblDescription]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        imgView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        btnGetStarted.widthAnchor.constraint(equalToConstant: 210).isActive = true
        btnGetStarted.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
    }

    @objc func btnGetStartedPressed(_ sender: UIButton) {
        self.redirect()
    }
    
    func redirect() {

        AppLocationManager.shared.startTracking()
        MySocketManager.shared.establishConnection()
        
        let revealVC = SWRevealViewController()
        revealVC.panGestureRecognizer().isEnabled = false
       
        let menuVC = MenuViewController()
                    
        let pickupVC = TaxiPickupVC()
        revealVC.frontViewController = UINavigationController(rootViewController: pickupVC)
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            revealVC.rearViewController = menuVC
            revealVC.rightViewController = nil
        } else {
            revealVC.rearViewController = nil
            revealVC.rightViewController = menuVC
        }
        pickupVC.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setViewControllers([revealVC], animated: true)
    }
}
