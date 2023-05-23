//
//  EnableLocationView.swift
//  Taxiappz
//
//  Created by Apple on 06/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit

class EnableLocationView: UIView {
    
    let viewContent = UIView()
    
    let btnClose = UIButton()
    
    let imgview = UIImageView()
    let lblTitle = UILabel()
    let lblHint = UILabel()
    
    let btnCancel = UIButton()
    let btnConfirm = UIButton()

    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        viewContent.layer.cornerRadius = 30
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        btnClose.setImage(UIImage(named: "ic_close"), for: .normal)
        layoutDict["btnClose"] = btnClose
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnClose)
        
        imgview.image = UIImage(named: "img_loc_enable")
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgview)
      
        lblTitle.text = APIHelper.shared.appName?.uppercased()
        lblTitle.textColor = .txtColor
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.appSemiBold(ofSize: 30)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        
        lblHint.text = "txt_disclosure".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .hexToColor("#9B9B9B")
        lblHint.textAlignment = .center
        lblHint.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblHint)
        
        btnCancel.setTitle("txt_not_now".localize(), for: .normal)
        btnCancel.setTitleColor(.txtColor, for: .normal)
        btnCancel.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnCancel.backgroundColor = .hexToColor("D9D9D9")
        layoutDict["btnCancel"] = btnCancel
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnCancel)
        
        
        btnConfirm.setTitle("txt_plain_enable".localize(), for: .normal)
        btnConfirm.setTitleColor(.themeTxtColor, for: .normal)
        btnConfirm.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnConfirm.backgroundColor = .themeColor
        layoutDict["btnConfirm"] = btnConfirm
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnConfirm)
        
      
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
       
        imgview.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        imgview.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[btnClose(30)]-8-[imgview(80)]-12-[lblTitle(30)]-20-[lblHint]-20-[btnConfirm(45)]-15-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnClose(30)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[lblHint]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnCancel]-16-[btnConfirm(==btnCancel)]-16-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        
    }
    
 
}
