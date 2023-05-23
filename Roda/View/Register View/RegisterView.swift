//
//  RegisterView.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//


import UIKit
import JVFloatLabeledTextField
import Kingfisher
class RegisterView: UIView {
    
    let scrollvw = UIScrollView()
    let contentvw = UIView()

    let titleView = UIView()
    let registrationLbl = UILabel()
    
    let viewProfileImage = UIImageView()
    let imgProfile = UIImageView()
    let btnAddImage = UIButton()
    
    let firstnameTfd = JVFloatLabeledTextField()
    
    let emailTfd = JVFloatLabeledTextField()
    
    let txtReferralCode = JVFloatLabeledTextField()
    
    
    let signupBtn = UIButton()

    var layoutDic = [String:AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        scrollvw.showsVerticalScrollIndicator = false
        scrollvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["scrollvw"] = scrollvw
        baseView.addSubview(scrollvw)
        
        contentvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["contentvw"] = contentvw
        scrollvw.addSubview(contentvw)
        
        titleView.layer.cornerRadius = 10
        titleView.addShadow()
        titleView.backgroundColor = .secondaryColor
        titleView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["titleView"] = titleView
        contentvw.addSubview(titleView)
        
        registrationLbl.text = "txt_add_personal_info".localize().capitalized
        registrationLbl.numberOfLines = 0
        registrationLbl.lineBreakMode = .byWordWrapping
        registrationLbl.textAlignment = .center
        registrationLbl.font = UIFont.appBoldFont(ofSize: 22)
        registrationLbl.textColor = .txtColor
        registrationLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["registrationLbl"] = registrationLbl
        titleView.addSubview(registrationLbl)
        
        viewProfileImage.isUserInteractionEnabled = true
        viewProfileImage.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewProfileImage"] = viewProfileImage
        contentvw.addSubview(viewProfileImage)
        
        
        imgProfile.image = UIImage(named: "signup_profile_img")
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.cornerRadius = 50
        imgProfile.clipsToBounds = true
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imgProfile"] = imgProfile
        viewProfileImage.addSubview(imgProfile)
        
        btnAddImage.setImage(UIImage(named: "signup_profile_edit"), for: .normal)
        btnAddImage.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnAddImage"] = btnAddImage
        viewProfileImage.addSubview(btnAddImage)
        
        [firstnameTfd,emailTfd, txtReferralCode].forEach({
           
            $0.addBorder(edges: .bottom, colour: .txtColor, thickness: 1)
           // $0.padding(10)
            $0.textAlignment = APIHelper.appTextAlignment
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.font = UIFont.appSemiBold(ofSize: 15)
            $0.floatingLabelYPadding = 7.0
            $0.floatingLabelTextColor = .hexToColor("636363")
            $0.floatingLabelActiveTextColor = .hexToColor("636363")
            
        })
        
        firstnameTfd.placeholder = "txt_name".localize()
        firstnameTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["firstnameTfd"] = firstnameTfd
        contentvw.addSubview(firstnameTfd)
        
      
        
        emailTfd.placeholder = "text_email_plain".localize()
        emailTfd.keyboardType = .emailAddress
        emailTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["emailTfd"] = emailTfd
        contentvw.addSubview(emailTfd)
        
    
        
        txtReferralCode.placeholder = "refferal_code".localize() + " (" + "txt_optional".localize() + ")"
        txtReferralCode.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["txtReferralCode"] = txtReferralCode
        contentvw.addSubview(txtReferralCode)
        
        signupBtn.layer.cornerRadius = 5
        signupBtn.setTitle("Txt_Continue".localize().uppercased(), for: .normal)
        signupBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        signupBtn.backgroundColor = .themeColor
        signupBtn.setTitleColor(.themeTxtColor, for: .normal)
        signupBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["signupBtn"] = signupBtn
        contentvw.addSubview(signupBtn)
        
        
        
        scrollvw.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollvw.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        scrollvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        scrollvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentvw]|", options: [], metrics: nil, views: layoutDic))
        contentvw.widthAnchor.constraint(equalTo: scrollvw.widthAnchor, constant: 0).isActive = true
        let contentHgt = contentvw.heightAnchor.constraint(equalTo: scrollvw.heightAnchor, constant: 0)
        contentHgt.priority = .defaultLow
        contentHgt.isActive = true
        
        
        
        contentvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[titleView]-30-[viewProfileImage]-25-[firstnameTfd(50)]-(20)-[emailTfd(50)]-(20)-[txtReferralCode(50)]-50-[signupBtn(50)]-10-|", options: [], metrics: nil, views: layoutDic))
        
        viewProfileImage.centerXAnchor.constraint(equalTo: contentvw.centerXAnchor, constant: 0).isActive = true
        
        viewProfileImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[imgProfile(100)]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewProfileImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[imgProfile(100)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        btnAddImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnAddImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnAddImage.bottomAnchor.constraint(equalTo: imgProfile.bottomAnchor, constant: -10).isActive = true
        btnAddImage.leadingAnchor.constraint(equalTo: imgProfile.trailingAnchor, constant: -20).isActive = true
        
        
        contentvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[titleView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[registrationLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[registrationLbl]-10-|", options: [], metrics: nil, views: layoutDic))
        
        
        
        contentvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[firstnameTfd]-(32)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        contentvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[emailTfd]-(32)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        contentvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[txtReferralCode]-(32)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        contentvw.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[signupBtn]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        

    }

}

