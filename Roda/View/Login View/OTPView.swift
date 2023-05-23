//
//  OTPView.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit

class OTPView: UIView {
    
    let btnBack = UIButton()
    let lblVerify = UILabel()
    
    let otpTfd = UIView()
    
    let textField = UITextField()
    
    let lblGetAnotherCode = UILabel()
    let resendBtn = UIButton()
    
    let otpRecieveHint = UILabel()
  
    let verifyotpBtn = UIButton()
    

    var layoutDic = [String:AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        btnBack.setImage(UIImage(named: "back_img"), for: .normal)
        btnBack.layer.cornerRadius = 25
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnBack"] = btnBack
        baseView.addSubview(btnBack)
        
        lblVerify.font = UIFont.appBoldFont(ofSize: 22)
        lblVerify.numberOfLines = 0
        lblVerify.lineBreakMode = .byWordWrapping
        lblVerify.textColor = .txtColor
        lblVerify.textAlignment = APIHelper.appTextAlignment
        lblVerify.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblVerify"] = lblVerify
        baseView.addSubview(lblVerify)
        
       
        otpTfd.addBorder(edges: .bottom, colour: .txtColor, thickness: 1)
        otpTfd.semanticContentAttribute = .forceLeftToRight
        otpTfd.backgroundColor = .secondaryColor
        otpTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["otpTfd"] = otpTfd
        baseView.addSubview(otpTfd)
        
        textField.defaultTextAttributes.updateValue(24.0, forKey: NSAttributedString.Key.kern)
        textField.becomeFirstResponder()
        textField.placeholder = "*   *   *   *"
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        textField.font = UIFont.appBoldFont(ofSize: 20)
        textField.textColor = .txtColor
        textField.textAlignment = APIHelper.appTextAlignment
        textField.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["textField"] = textField
        otpTfd.addSubview(textField)
        
        verifyotpBtn.setTitleColor(.themeTxtColor, for: .normal)
        verifyotpBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        verifyotpBtn.setTitle("txt_next".localize().uppercased(), for: .normal)
        verifyotpBtn.backgroundColor = .themeColor
        verifyotpBtn.layer.cornerRadius = 5
        verifyotpBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["verifyotpBtn"] = verifyotpBtn
        baseView.addSubview(verifyotpBtn)
        
       
        resendBtn.layer.cornerRadius = 5
        resendBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.resendBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        resendBtn.setTitle("txt_send_new_code".localize(), for: .normal)
        resendBtn.setTitleColor(.themeTxtColor, for: .normal)
        resendBtn.backgroundColor = .themeColor
        resendBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["resendBtn"] = resendBtn
        baseView.addSubview(resendBtn)
        
        otpRecieveHint.isHidden = true
        otpRecieveHint.text = "txt_otp_wait".localize()
        otpRecieveHint.font = UIFont.appRegularFont(ofSize: 15)
        otpRecieveHint.numberOfLines = 0
        otpRecieveHint.lineBreakMode = .byWordWrapping
        otpRecieveHint.textColor = .txtColor
        otpRecieveHint.textAlignment = APIHelper.appTextAlignment
        otpRecieveHint.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["otpRecieveHint"] = otpRecieveHint
        baseView.addSubview(otpRecieveHint)

        lblGetAnotherCode.textColor = .hexToColor("#636363")
        lblGetAnotherCode.textAlignment = APIHelper.appTextAlignment
        lblGetAnotherCode.font = UIFont.appRegularFont(ofSize: 14)
        lblGetAnotherCode.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblGetAnotherCode"] = lblGetAnotherCode
        baseView.addSubview(lblGetAnotherCode)
        
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnBack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(50)]-20-[lblVerify]-(25)-[otpTfd(50)]-(25)-[lblGetAnotherCode(30)]-15-[resendBtn(40)]", options: [], metrics: nil, views: layoutDic))
       
      
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[otpTfd]", options: [], metrics: nil, views: layoutDic))

        otpTfd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[textField(150)]-5-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        otpTfd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField]|", options: [], metrics: nil, views: layoutDic))


        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[lblVerify]-(32)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[lblGetAnotherCode]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[resendBtn]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
    
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblGetAnotherCode]-15-[otpRecieveHint]", options: [], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[otpRecieveHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        verifyotpBtn.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        verifyotpBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[verifyotpBtn]-(32)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
    }
   
}

