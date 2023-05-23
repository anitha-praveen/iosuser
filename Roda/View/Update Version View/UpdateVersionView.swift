//
//  UpdateVersionView.swift
//  Taxiappz
//
//  Created by Apple on 22/02/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit

class UpdateVersionView: UIView {
    
    let imgAppLogo = UIImageView()
    let lblAppName = UILabel()
    let lblUpdateReq = UILabel()
    let lblDescription = UILabel()
    let btnSubmit = UIButton()

    var layoutDict = [String: AnyObject]()
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .themeColor
        
        imgAppLogo.layer.cornerRadius = 10
        imgAppLogo.clipsToBounds = true
        imgAppLogo.image = UIImage(named: "app_logo")
        imgAppLogo.contentMode = .scaleAspectFit
        imgAppLogo.backgroundColor = .themeColor
        layoutDict["imgAppLogo"] = imgAppLogo
        imgAppLogo.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(imgAppLogo)
        
        lblAppName.text = APIHelper.shared.appName?.uppercased()
        lblAppName.textAlignment = .center
        lblAppName.textColor = .secondaryColor
        lblAppName.font = .appSemiBold(ofSize: 25)
        layoutDict["lblAppName"] = lblAppName
        lblAppName.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblAppName)
        
        lblUpdateReq.text = "txt_app_update_required".localize()
        lblUpdateReq.textAlignment = .center
        lblUpdateReq.textColor = .secondaryColor
        lblUpdateReq.font = .appSemiBold(ofSize: 20)
        layoutDict["lblUpdateReq"] = lblUpdateReq
        lblUpdateReq.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblUpdateReq)
        
        lblDescription.text = "txt_updateapp_for_betterExp".localize()
        lblDescription.textAlignment = .center
        lblDescription.textColor = .secondaryColor
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.font = .appRegularFont(ofSize: 14)
        layoutDict["lblDescription"] = lblDescription
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblDescription)
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.borderColor = UIColor.secondaryColor.cgColor
        btnSubmit.setTitle("Continue", for: .normal)
        btnSubmit.titleLabel?.font = .appSemiBold(ofSize: 20)
        btnSubmit.setTitleColor(.themeTxtColor, for: .normal)
        btnSubmit.backgroundColor = .themeColor
        layoutDict["btnSubmit"] = btnSubmit
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnSubmit)
        
        
        lblAppName.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0).isActive = true
        btnSubmit.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        
        imgAppLogo.widthAnchor.constraint(equalToConstant: 118).isActive = true
        imgAppLogo.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgAppLogo(118)]-15-[lblAppName]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblAppName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblUpdateReq(23)]-5-[lblDescription(>=40)]-15-[btnSubmit(50)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[lblUpdateReq]-25-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[lblDescription]-25-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnSubmit]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
