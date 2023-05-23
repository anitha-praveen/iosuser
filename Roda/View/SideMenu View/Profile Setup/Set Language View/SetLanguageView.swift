//
//  SetLanguageView.swift
//  Taxiappz
//
//  Created by NPlus Technologies on 02/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class SetLanguageView: UIView {
    
    let backBtn = UIButton()
    let lblTitle = UILabel()
    let tblLanguage = UITableView()
    let btnSetLanguage = UIButton()

    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["backBtn"] = backBtn
        baseView.addSubview(backBtn)
        
        lblTitle.text = "text_select_language".localize()
        lblTitle.textAlignment = APIHelper.appTextAlignment
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appSemiBold(ofSize: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblTitle"] = lblTitle
        baseView.addSubview(lblTitle)
        
        tblLanguage.separatorStyle = .none
        tblLanguage.backgroundColor = .secondaryColor
        tblLanguage.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tblLanguage"] = tblLanguage
        baseView.addSubview(tblLanguage)
        
       
        btnSetLanguage.layer.cornerRadius = 5
        btnSetLanguage.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnSetLanguage.setTitleColor(.themeTxtColor, for: .normal)
        btnSetLanguage.backgroundColor = .themeColor
        layoutDict["btnSetLanguage"] = btnSetLanguage
        btnSetLanguage.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnSetLanguage)
        
        
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        btnSetLanguage.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-20-[lblTitle(30)]-20-[tblLanguage]-20-[btnSetLanguage(45)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[backBtn(30)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTitle]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblLanguage]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnSetLanguage]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }

}
