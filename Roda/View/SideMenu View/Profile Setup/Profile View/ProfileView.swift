//
//  ProfileView.swift
//  Taxiappz
//
//  Created by NPlus Technologies on 02/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let profpicBtn = UIButton()
    let profpicEditBtn = UIButton()
    
    let activityIndicator = UIActivityIndicatorView()
    
    let lblFirstName = UILabel()
    let txtFirstName = UITextField()
    
    let lblEmail = UILabel()
    let txtEmail = UITextField()
    
    let lblPhoneNumber = UILabel()
    let txtPhoneNumber = UITextField()
    
    let stackSave = UIStackView()
    let btnSave = UIButton()
    
    let lblMyFavourites = UILabel()
    
    let tblFavourites = UITableView()
    let stackView = UIStackView()
    let viewHomeWork = UIView()
    let btnAddHome = UIButton()
    let btnAddWork = UIButton()
    let viewOthers = UIView()
    let btnAddOther = UIButton()
    
    let logoutSeparator = UIView()
    let logoutView = UIView()
    let imgLogout = UIButton()
    let btnLogout = UIButton()
    
    let imgDeleteAccount = UIButton()
    let btnDeleteAccount = UIButton()
    
    var tblHeightConstraint: NSLayoutConstraint?
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
//        baseView.subviews.forEach({
//            $0.removeAllConstraint()
//            $0.removeFromSuperview()
//        })
        
        baseView.backgroundColor = .secondaryColor
        
        backBtn.contentMode = .scaleAspectFit
        backBtn.setAppImage("backDark")
        backBtn.layer.cornerRadius = 20
        backBtn.addShadow()
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "txt_my_profile".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollView"] = scrollView
        baseView.addSubview(scrollView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        scrollView.addSubview(containerView)
        
        
        profpicBtn.layer.cornerRadius = 40
        profpicBtn.layer.masksToBounds = true
        profpicBtn.setImage(UIImage(named: "signup_profile_img"), for: .normal)
        profpicBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["profpicBtn"] = profpicBtn
        containerView.addSubview(profpicBtn)
        
        profpicEditBtn.setImage(UIImage(named: "signup_profile_edit"), for: .normal)
        profpicEditBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["profpicEditBtn"] = profpicEditBtn
        containerView.addSubview(profpicEditBtn)
        
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["activityIndicator"] = activityIndicator
        containerView.addSubview(activityIndicator)
        
        [lblFirstName,lblEmail,lblPhoneNumber].forEach({
            
            $0.font = UIFont.appRegularFont(ofSize: 12)
            $0.textColor = .hexToColor("636363")
            $0.textAlignment = APIHelper.appTextAlignment
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        })
        
        lblFirstName.text = "text_firstname".localize().capitalized
        layoutDict["lblFirstName"] = lblFirstName
        lblEmail.text = "email".localize().capitalized
        layoutDict["lblEmail"] = lblEmail
        lblPhoneNumber.text = "hint_phone_number".localize().capitalized
        layoutDict["lblPhoneNumber"] = lblPhoneNumber
       
        
        [txtFirstName,txtEmail].forEach({
            $0.clearButtonMode = .whileEditing
            $0.textColor = .txtColor
            $0.textAlignment = APIHelper.appTextAlignment
            $0.font = UIFont.appSemiBold(ofSize: 16)
            $0.addBorder(edges: .bottom, colour: .txtColor, thickness: 1)
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        })

        layoutDict["txtFirstName"] = txtFirstName
        layoutDict["txtEmail"] = txtEmail
        
        txtPhoneNumber.isUserInteractionEnabled = false
        txtPhoneNumber.textColor = .hexToColor("616161")
        txtPhoneNumber.textAlignment = APIHelper.appTextAlignment
        txtPhoneNumber.font = UIFont.appSemiBold(ofSize: 18)
        txtPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(txtPhoneNumber)
        layoutDict["txtPhoneNumber"] = txtPhoneNumber
        
        // ------------Save button
        
        stackSave.axis = .vertical
        stackSave.distribution = .fill
        stackSave.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackSave"] = stackSave
        containerView.addSubview(stackSave)
        
        btnSave.isEnabled = false
        btnSave.layer.cornerRadius = 8
        btnSave.setTitle("txt_save".localize(), for: .normal)
        btnSave.setTitleColor(.gray, for: .normal)
        btnSave.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        btnSave.backgroundColor = UIColor.themeColor.withAlphaComponent(0.4)
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnSave"] = btnSave
        stackSave.addArrangedSubview(btnSave)
        
        // ----------Favourites
        
        lblMyFavourites.text = "txt_my_fav".localize()
        lblMyFavourites.textAlignment = APIHelper.appTextAlignment
        lblMyFavourites.textColor = .txtColor
        lblMyFavourites.font = UIFont.appBoldFont(ofSize: 16)
        lblMyFavourites.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblMyFavourites"] = lblMyFavourites
        containerView.addSubview(lblMyFavourites)
        
        
        tblFavourites.alwaysBounceVertical = false
        tblFavourites.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tblFavourites"] = tblFavourites
        containerView.addSubview(tblFavourites)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackView"] = stackView
        containerView.addSubview(stackView)
        
        viewHomeWork.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewHomeWork"] = viewHomeWork
        stackView.addArrangedSubview(viewHomeWork)
        
        btnAddHome.layer.cornerRadius = 8
        btnAddHome.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnAddHome.setImage(UIImage(named: "favHome"), for: .normal)
        btnAddHome.setTitle("txt_add_home".localize(), for: .normal)
        btnAddHome.setTitleColor(.txtColor, for: .normal)
        btnAddHome.titleLabel?.font = UIFont.appRegularFont(ofSize: 14)
        btnAddHome.backgroundColor = .hexToColor("F4F4F4")
        btnAddHome.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnAddHome"] = btnAddHome
        viewHomeWork.addSubview(btnAddHome)
        
        btnAddWork.layer.cornerRadius = 8
        btnAddWork.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnAddWork.setImage(UIImage(named: "favWork"), for: .normal)
        btnAddWork.setTitle("txt_add_work".localize(), for: .normal)
        btnAddWork.setTitleColor(.txtColor, for: .normal)
        btnAddWork.titleLabel?.font = UIFont.appRegularFont(ofSize: 14)
        btnAddWork.backgroundColor = .hexToColor("F4F4F4")
        btnAddWork.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnAddWork"] = btnAddWork
        viewHomeWork.addSubview(btnAddWork)
        
        viewOthers.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewOthers"] = viewOthers
        stackView.addArrangedSubview(viewOthers)
        
        btnAddOther.layer.cornerRadius = 8
        btnAddOther.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnAddOther.setImage(UIImage(named: "favorOthers"), for: .normal)
        btnAddOther.setTitle("txt_add_other".localize(), for: .normal)
        btnAddOther.setTitleColor(.txtColor, for: .normal)
        btnAddOther.titleLabel?.font = UIFont.appRegularFont(ofSize: 14)
        btnAddOther.backgroundColor = .hexToColor("F4F4F4")
        btnAddOther.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnAddOther"] = btnAddOther
        viewOthers.addSubview(btnAddOther)
        
        // ----------Logout
        
        logoutSeparator.backgroundColor = .hexToColor("DADADA")
        logoutSeparator.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["logoutSeparator"] = logoutSeparator
        baseView.addSubview(logoutSeparator)
        
        logoutView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["logoutView"] = logoutView
        baseView.addSubview(logoutView)
        
        imgLogout.setImage(UIImage(named: "ic_logout"), for: .normal)
        imgLogout.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgLogout"] = imgLogout
        logoutView.addSubview(imgLogout)
        
        btnLogout.setTitle("txt_log_out".localize(), for: .normal)
        btnLogout.setTitleColor(.txtColor, for: .normal)
        btnLogout.titleLabel?.font = UIFont.appMediumFont(ofSize: 18)
        btnLogout.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnLogout"] = btnLogout
        logoutView.addSubview(btnLogout)
        
        imgDeleteAccount.setImage(UIImage(named: "deleteImage"), for: .normal)
        imgDeleteAccount.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgDeleteAccount"] = imgDeleteAccount
        logoutView.addSubview(imgDeleteAccount)
        
        btnDeleteAccount.setTitle("txt_delete_account".localize(), for: .normal)
        btnDeleteAccount.setTitleColor(.txtColor, for: .normal)
        btnDeleteAccount.titleLabel?.font = UIFont.appMediumFont(ofSize: 18)
        btnDeleteAccount.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnDeleteAccount"] = btnDeleteAccount
        logoutView.addSubview(btnDeleteAccount)
       
        // -----------------Constraints
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
      
        logoutView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-20-[scrollView]-8-[logoutSeparator(1)]-8-[logoutView]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[logoutSeparator]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[logoutView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerHgt.priority = .defaultLow
        containerHgt.isActive = true
        
       
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[profpicBtn(80)]-30-[lblFirstName][txtFirstName(40)]-25-[lblEmail][txtEmail(40)]-25-[lblPhoneNumber][txtPhoneNumber(40)]-15-[stackSave]-10-[lblMyFavourites(30)]-10-[tblFavourites]-10-[stackView]-10-|", options: [], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[profpicBtn(80)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        profpicEditBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        profpicEditBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        profpicEditBtn.bottomAnchor.constraint(equalTo: profpicBtn.bottomAnchor, constant: -10).isActive = true
        profpicEditBtn.leadingAnchor.constraint(equalTo: profpicBtn.trailingAnchor, constant: -15).isActive = true
        
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: profpicBtn.centerXAnchor, constant: 0).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: profpicBtn.centerYAnchor, constant: 0).isActive = true
        
        // --------FirstName
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblFirstName]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[txtFirstName]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        // --------Email
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblEmail]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[txtEmail]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        // --------PhoneNumber
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblPhoneNumber]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[txtPhoneNumber]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // -----------Save button
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[stackSave]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnSave.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // ----------Favourites
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblMyFavourites]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[tblFavourites]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.tblHeightConstraint = tblFavourites.heightAnchor.constraint(equalToConstant: 0)
        self.tblHeightConstraint?.isActive = true
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[stackView]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewHomeWork.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[btnAddHome(40)]-2-|", options: [], metrics: nil, views: layoutDict))
        viewHomeWork.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnAddHome]-10-[btnAddWork(==btnAddHome)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        viewOthers.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[btnAddOther(40)]-2-|", options: [], metrics: nil, views: layoutDict))
        btnAddOther.leadingAnchor.constraint(equalTo: btnAddHome.leadingAnchor, constant: 0).isActive = true
        btnAddOther.trailingAnchor.constraint(equalTo: btnAddHome.trailingAnchor, constant: 0).isActive = true
        
        // ---------Logout
        
        logoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[imgLogout(20)]-10-[btnLogout]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        logoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnLogout(40)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgLogout.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgLogout.centerYAnchor.constraint(equalTo: btnLogout.centerYAnchor, constant: 0).isActive = true
        
        
        logoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imgDeleteAccount(20)]-10-[btnDeleteAccount]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        logoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnDeleteAccount(40)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgDeleteAccount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgDeleteAccount.centerYAnchor.constraint(equalTo: btnDeleteAccount.centerYAnchor, constant: 0).isActive = true
       
    }

}
