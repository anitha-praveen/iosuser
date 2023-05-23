//
//  UserBlockedVC.swift
//  Petra Ride
//
//  Created by NPlus Technologies on 27/08/19.
//  Copyright © 2019 Mohammed Arshad. All rights reserved.
//

import UIKit

class UserBlockedVC: UIViewController {
    
    let viewContent = UIView()
    let lblHeader = UILabel()
    let lblDescription = UILabel()
    let btnOK = UIButton()
    
    var layoutDict = [String: AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

       setupViews()
    }
    
    func setupViews() { // adding ui elements to superview
        
        self.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.7)
        
        viewContent.backgroundColor = .secondaryColor
        viewContent.layer.cornerRadius = 5.0
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewContent)
        
        lblHeader.text = APIHelper.shared.appName?.uppercased()
        lblHeader.textColor = .themeColor
        lblHeader.font = UIFont.appBoldFont(ofSize: 26)
        lblHeader.textAlignment = .center
        layoutDict["lblHeader"] = lblHeader
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewContent.addSubview(lblHeader)
        
        lblDescription.text = "user_blocked_text".localize()
        lblDescription.textColor = .txtColor
        lblDescription.textAlignment = .center
        lblDescription.font = UIFont.appBoldTitleFont(ofSize: 26)
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byWordWrapping
        layoutDict["lblDescription"] = lblDescription
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(lblDescription)
        
        btnOK.layer.cornerRadius = 5.0
        btnOK.addTarget(self, action: #selector(btnOkPressed(_ :)), for: .touchUpInside)
        btnOK.setTitle("text_ok".localize(), for: .normal)
        btnOK.backgroundColor = .themeColor
        btnOK.setTitleColor(.themeTxtColor, for: .normal)
        btnOK.titleLabel?.font = UIFont.appBoldTitleFont(ofSize: 24)
        layoutDict["btnOK"] = btnOK
        btnOK.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnOK)
        

        self.viewContent.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[viewContent]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[lblDescription]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[lblHeader]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[lblHeader(40)]-20-[lblDescription(50)]-20-|", options: [], metrics: nil, views: layoutDict))
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[btnOK]-(32)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewContent]-20-[btnOK(40)]", options: [], metrics: nil, views: layoutDict))
        
    }
    
    @objc func btnOkPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
