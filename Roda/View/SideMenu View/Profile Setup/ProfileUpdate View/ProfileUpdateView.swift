//
//  ProfileUpdateView.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class ProfileUpdateView: UIView {

    let backBtn = UIButton()
    let titleLbl = UILabel()
    let textTfd = UITextField()
    let cancelBtn = UIButton()
    let descriptionLbl = UILabel()
    let updateBtn = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    var bottomSpace: NSLayoutConstraint!

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
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        baseView.addSubview(backBtn)
        
        titleLbl.font = .appSemiBold(ofSize: 21)
        titleLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleLbl)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        cancelBtn.setImage(UIImage(named: "cancelLightGray"), for: .normal)
        cancelBtn.imageView?.contentMode = .scaleToFill
        cancelBtn.sizeToFit()
        rightView.addSubview(cancelBtn)
//        textTfd.rightView = rightView
//        textTfd.rightViewMode = .always
        
        textTfd.clearButtonMode = .always
        textTfd.autocorrectionType = .no
        textTfd.autocapitalizationType = .none
        textTfd.font = UIFont.appRegularFont(ofSize: 21)
        textTfd.addBorder(edges: .bottom , colour: .themeColor , thickness: 2)
        textTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["textTfd"] = textTfd
        baseView.addSubview(textTfd)
        
        
        descriptionLbl.font = .appRegularFont(ofSize: 15)
        descriptionLbl.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1)
        descriptionLbl.numberOfLines = 0
        descriptionLbl.lineBreakMode = .byWordWrapping
        descriptionLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["descriptionLbl"] = descriptionLbl
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(descriptionLbl)
        
        updateBtn.setTitle("txt_update".localize().uppercased(), for: .normal)
        updateBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 19)
        updateBtn.setTitleColor(.secondaryColor, for: .normal)
        updateBtn.backgroundColor = .themeColor
        updateBtn.layer.cornerRadius = 5
        updateBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["updateBtn"] = updateBtn
        baseView.addSubview(updateBtn)
        
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor , constant: 20).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-10-[titleLbl(30)]-15-[textTfd(40)]-10-[descriptionLbl]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textTfd]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[descriptionLbl]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        updateBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.bottomSpace = updateBtn.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        self.bottomSpace.isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[updateBtn]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }
}
