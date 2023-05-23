//
//  PromoView.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class PromoView: UIView {

    let btnBack = UIButton()
    let lblTitle = UILabel()
    
    let viewPromoBox = UIView()
    let textField = UITextField()
    let applyBtn = UIButton()
    let promoCancelBtn = UIButton()
    
    let lblAvailablePromo = UILabel()
    
    let viewAvailablePromo = UIView()
    let tblAvailablePromo = UITableView()
    
    let ImgNoOfferData = UIImageView()
    let lblNoOfferData = UILabel()
    
    let blurredView = UIView()
    
    let successTransparentView = UIView()
    let imgPromoApplied = UIImageView()
    let viewSuccessPopup = UIView()
    let lblAppliedPromoCode = UILabel()
    let lblApplied = UILabel()
    let lblAppliedAmount = UILabel()
    let lblSavings = UILabel()
    let btnYAY = UIButton()
    
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.hexToColor("f3f3f3")
        
        btnBack.setAppImage("BackImage")
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnBack"] = btnBack
        baseView.addSubview(btnBack)
        
        lblTitle.text = "Txt_title_Promocode".localize()
        lblTitle.textAlignment = APIHelper.appTextAlignment
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appRegularFont(ofSize: 18)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblTitle"] = lblTitle
        baseView.addSubview(lblTitle)
        
        viewPromoBox.layer.borderWidth = 0.5
        viewPromoBox.layer.cornerRadius = 5
        viewPromoBox.layer.borderColor = UIColor.lightGray.cgColor
        viewPromoBox.backgroundColor = .secondaryColor
        viewPromoBox.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewPromoBox"] = viewPromoBox
        baseView.addSubview(viewPromoBox)
        
        textField.placeholder = "Txt_title_Promocode".localize()
        textField.textAlignment = APIHelper.appTextAlignment
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.font = UIFont.appSemiBold(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["textField"] = textField
        viewPromoBox.addSubview(textField)
        
        applyBtn.isEnabled = false
        applyBtn.setTitle("txt_Apply".localize().uppercased(), for: .normal)
        applyBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        applyBtn.setTitleColor(UIColor.themeColor.withAlphaComponent(0.3), for: .disabled)
        applyBtn.setTitleColor(UIColor.themeColor, for: .normal)
        applyBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["applyBtn"] = applyBtn
        viewPromoBox.addSubview(applyBtn)
        
        promoCancelBtn.setImage(UIImage(named: "remove_circle"), for: .normal)
        promoCancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["promoCancelBtn"] = promoCancelBtn
        viewPromoBox.addSubview(promoCancelBtn)
        
        lblAvailablePromo.textColor = .txtColor
        lblAvailablePromo.text = "txt_promo_available_promo".localize()
        lblAvailablePromo.font = UIFont.appRegularFont(ofSize: 16)
        lblAvailablePromo.textAlignment = APIHelper.appTextAlignment
        lblAvailablePromo.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblAvailablePromo"] = lblAvailablePromo
        baseView.addSubview(lblAvailablePromo)
        
        viewAvailablePromo.backgroundColor = .secondaryColor
        viewAvailablePromo.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewAvailablePromo"] = viewAvailablePromo
        baseView.addSubview(viewAvailablePromo)
        
        ImgNoOfferData.image = UIImage(named: "no_promo")
        ImgNoOfferData.contentMode = .scaleAspectFit
        ImgNoOfferData.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["ImgNoOfferData"] = ImgNoOfferData
        viewAvailablePromo.addSubview(ImgNoOfferData)
        
        lblNoOfferData.text = "txt_no_offers_found".localize()
        lblNoOfferData.numberOfLines = 0
        lblNoOfferData.lineBreakMode = .byWordWrapping
        lblNoOfferData.textAlignment = .center
        lblNoOfferData.textColor = .gray
        lblNoOfferData.font = UIFont.appRegularFont(ofSize: 16)
        lblNoOfferData.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblNoOfferData"] = lblNoOfferData
        viewAvailablePromo.addSubview(lblNoOfferData)
        
        tblAvailablePromo.isHidden = true
        tblAvailablePromo.alwaysBounceVertical = false
        tblAvailablePromo.tableFooterView = UIView()
        tblAvailablePromo.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tblAvailablePromo"] = tblAvailablePromo
        viewAvailablePromo.addSubview(tblAvailablePromo)
        
        blurredView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.2)
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["blurredView"] = blurredView
        viewAvailablePromo.addSubview(blurredView)
        
        // -----------Success View
        
        successTransparentView.isHidden = true
        successTransparentView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.8)
        successTransparentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["successTransparentView"] = successTransparentView
        baseView.addSubview(successTransparentView)
        
        viewSuccessPopup.layer.cornerRadius = 10
        viewSuccessPopup.backgroundColor = .secondaryColor
        viewSuccessPopup.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewSuccessPopup"] = viewSuccessPopup
        successTransparentView.addSubview(viewSuccessPopup)
        
        
        lblAppliedPromoCode.textAlignment = .center
        lblAppliedPromoCode.textColor = .txtColor
        lblAppliedPromoCode.font = UIFont.appSemiBold(ofSize: 18)
        lblAppliedPromoCode.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblAppliedPromoCode"] = lblAppliedPromoCode
        viewSuccessPopup.addSubview(lblAppliedPromoCode)
        
        lblApplied.text = "txt_applied".localize()
        lblApplied.textAlignment = .center
        lblApplied.textColor = .green
        lblApplied.font = UIFont.appSemiBold(ofSize: 16)
        lblApplied.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblApplied"] = lblApplied
        viewSuccessPopup.addSubview(lblApplied)
        
        lblAppliedAmount.textAlignment = .center
        lblAppliedAmount.textColor = .txtColor
        lblAppliedAmount.font = UIFont.appSemiBold(ofSize: 24)
        lblAppliedAmount.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblAppliedAmount"] = lblAppliedAmount
        viewSuccessPopup.addSubview(lblAppliedAmount)
        
        lblSavings.text = "txt_savings_from_promo".localize()
        lblSavings.font = UIFont.appRegularFont(ofSize: 15)
        lblSavings.textAlignment = .center
        lblSavings.textColor = .txtColor
        lblSavings.font = UIFont.appRegularFont(ofSize: 16)
        lblSavings.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblSavings"] = lblSavings
        viewSuccessPopup.addSubview(lblSavings)
        
        btnYAY.setTitle("yay".localize(), for: .normal)
        btnYAY.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnYAY.setTitleColor(.themeColor, for: .normal)
        btnYAY.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnYAY"] = btnYAY
        viewSuccessPopup.addSubview(btnYAY)
        
        imgPromoApplied.contentMode = .scaleAspectFit
        imgPromoApplied.image = UIImage(named: "promo_success_percentage")
        imgPromoApplied.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgPromoApplied"] = imgPromoApplied
        successTransparentView.addSubview(imgPromoApplied)
        
        // ------------------
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        viewAvailablePromo.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(30)]-20-[viewPromoBox]-20-[lblAvailablePromo(30)]-10-[viewAvailablePromo]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnBack(30)]-10-[lblTitle]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[viewPromoBox]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewPromoBox.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[textField]-10-[applyBtn]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        viewPromoBox.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[textField(40)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewPromoBox.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[promoCancelBtn(30)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        promoCancelBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        promoCancelBtn.centerYAnchor.constraint(equalTo: applyBtn.centerYAnchor, constant: 0).isActive = true
        
    
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[lblAvailablePromo]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewAvailablePromo]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewAvailablePromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblAvailablePromo]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAvailablePromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tblAvailablePromo]|", options: [], metrics: nil, views: layoutDict))
        
        
        
        
        viewAvailablePromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[ImgNoOfferData(150)]-20-[lblNoOfferData]", options: [], metrics: nil, views: layoutDict))
        ImgNoOfferData.widthAnchor.constraint(equalToConstant: 150).isActive = true
        ImgNoOfferData.centerXAnchor.constraint(equalTo: viewAvailablePromo.centerXAnchor, constant: 0).isActive = true
        
        viewAvailablePromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblNoOfferData]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // --------Blurred View
        viewAvailablePromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurredView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAvailablePromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurredView]|", options: [], metrics: nil, views: layoutDict))
        
        
        // -----------SuccessView
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[successTransparentView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[successTransparentView]|", options: [], metrics: nil, views: layoutDict))
        
        imgPromoApplied.centerYAnchor.constraint(equalTo: viewSuccessPopup.topAnchor, constant: 0).isActive = true
        imgPromoApplied.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imgPromoApplied.centerXAnchor.constraint(equalTo: viewSuccessPopup.centerXAnchor, constant: 0).isActive = true
        imgPromoApplied.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        successTransparentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[viewSuccessPopup]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewSuccessPopup.centerYAnchor.constraint(equalTo: successTransparentView.centerYAnchor, constant: 0).isActive = true
        
        viewSuccessPopup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-35-[lblAppliedPromoCode][lblApplied]-20-[lblAppliedAmount]-8-[lblSavings]-20-[btnYAY(30)]-10-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewSuccessPopup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblAppliedPromoCode]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }

}
