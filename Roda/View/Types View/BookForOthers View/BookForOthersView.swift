//
//  BookForOthersView.swift
//  Taxiappz
//
//  Created by Apple on 22/03/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit

class BookForOthersView: UIView {
    
    var choosePassengerView = UIView()
    
    var choosePassengerTableView = UITableView()
    
    let stackvw = UIStackView()
    var contactNameView = UIView()
    let txtContactName = UITextField()
    let btnChooseContact = UIButton()
    let txtContactNumber = UITextField()
    
    var skipButton = UIButton()
    var continueButton = UIButton()
    
    var layoutDict = [String:Any]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(_ baseView:UIView ) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        choosePassengerView.backgroundColor = .secondaryColor
        choosePassengerView.layer.cornerRadius = 10
        choosePassengerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        layoutDict["choosePassengerView"] = choosePassengerView
        choosePassengerView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(choosePassengerView)
        
        choosePassengerTableView.isScrollEnabled = false
        choosePassengerTableView.backgroundColor = .secondaryColor
        choosePassengerTableView.clipsToBounds = true
        choosePassengerTableView.separatorStyle = .none
        layoutDict["choosePassengerTableView"] = choosePassengerTableView
        choosePassengerTableView.translatesAutoresizingMaskIntoConstraints = false
        choosePassengerView.addSubview(choosePassengerTableView)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        layoutDict["stackvw"] = stackvw
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        choosePassengerView.addSubview(stackvw)
        
        contactNameView.isHidden = true
        contactNameView.backgroundColor = .secondaryColor
        layoutDict["contactNameView"] = contactNameView
        contactNameView.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(contactNameView)
        
        txtContactName.padding(10)
        txtContactName.placeholder = "txt_enter_contact_name".localize()
        txtContactName.layer.cornerRadius = 8
        txtContactName.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
        txtContactName.layer.borderWidth = 1.0
        txtContactName.textAlignment = APIHelper.appTextAlignment
        txtContactName.textColor = .txtColor
        txtContactName.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["txtContactName"] = txtContactName
        txtContactName.translatesAutoresizingMaskIntoConstraints = false
        contactNameView.addSubview(txtContactName)
        
        txtContactNumber.padding(10)
        txtContactNumber.placeholder = "txt_enter_contact_number".localize()
        txtContactNumber.layer.cornerRadius = 8
        txtContactNumber.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
        txtContactNumber.layer.borderWidth = 1.0
        txtContactNumber.keyboardType = .phonePad
        txtContactNumber.textAlignment = APIHelper.appTextAlignment
        txtContactNumber.textColor = .txtColor
        txtContactNumber.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["txtContactNumber"] = txtContactNumber
        txtContactNumber.translatesAutoresizingMaskIntoConstraints = false
        contactNameView.addSubview(txtContactNumber)
        
        btnChooseContact.setImage(UIImage(named: "User_Profile_Reg"), for: .normal)
        layoutDict["btnChooseContact"] = btnChooseContact
        btnChooseContact.translatesAutoresizingMaskIntoConstraints = false
        contactNameView.addSubview(btnChooseContact)
        
        skipButton.setTitle("text_cancel".localize(), for: .normal)
        skipButton.layer.cornerRadius = 5
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor.themeColor.cgColor
        skipButton.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        skipButton.setTitleColor(.themeColor, for: .normal)
        layoutDict["skipButton"] = skipButton
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        choosePassengerView.addSubview(skipButton)
        
        continueButton.setTitle("Txt_Continue".localize(), for: .normal)
        continueButton.layer.cornerRadius = 5
        continueButton.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        continueButton.setTitleColor(.themeTxtColor, for: .normal)
        continueButton.backgroundColor = .themeColor
        layoutDict["continueButton"] = continueButton
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        choosePassengerView.addSubview(continueButton)
        
        
        choosePassengerView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[choosePassengerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        choosePassengerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[choosePassengerTableView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        choosePassengerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stackvw]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        choosePassengerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[choosePassengerTableView(80)]-8-[stackvw]-16-[skipButton(48)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        choosePassengerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[skipButton]-10-[continueButton(==skipButton)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        
        contactNameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[txtContactName(45)]-8-[txtContactNumber(45)]-8-|", options: [], metrics: nil, views: layoutDict))
        btnChooseContact.centerYAnchor.constraint(equalTo: txtContactName.centerYAnchor).isActive = true
        btnChooseContact.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        contactNameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[txtContactName]-8-[btnChooseContact(40)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contactNameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[txtContactNumber]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
    }
    
}


class ChoosePassengerTableViewCell: UITableViewCell {
    
    var choosePassengerView = UIView()
    var layoutDict = [String:Any]()
    
    var chooseView = UIView()
    var chooseIconView = UIView()
    var chooseLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        choosePassengerView.backgroundColor = .secondaryColor
        layoutDict["choosePassengerView"] = choosePassengerView
        choosePassengerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(choosePassengerView)
        
        chooseView.backgroundColor = .secondaryColor
        chooseView.layer.cornerRadius = 11
        chooseView.layer.borderColor = UIColor.themeColor.cgColor
        chooseView.layer.borderWidth = 3
        layoutDict["chooseView"] = chooseView
        chooseView.translatesAutoresizingMaskIntoConstraints = false
        choosePassengerView.addSubview(chooseView)
        
        chooseIconView.backgroundColor = .themeColor
        chooseIconView.layer.cornerRadius = 6
        layoutDict["chooseIconView"] = chooseIconView
        chooseIconView.translatesAutoresizingMaskIntoConstraints = false
        chooseView.addSubview(chooseIconView)
        
        chooseLabel.textColor = .txtColor
        chooseLabel.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["chooseLabel"] = chooseLabel
        chooseLabel.translatesAutoresizingMaskIntoConstraints = false
        choosePassengerView.addSubview(chooseLabel)
        
        
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[choosePassengerView]-5-|", options: [], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[choosePassengerView]|", options: [], metrics: nil, views: layoutDict))
        
        choosePassengerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[chooseView(22)]-15-[chooseLabel]-|", options: [], metrics: nil, views: layoutDict))
        
        choosePassengerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chooseLabel(30)]|", options: [], metrics: nil, views: layoutDict))
        
        chooseView.centerYAnchor.constraint(equalTo: chooseLabel.centerYAnchor).isActive = true
        chooseView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        chooseIconView.centerXAnchor.constraint(equalTo: chooseView.centerXAnchor).isActive = true
        chooseIconView.centerYAnchor.constraint(equalTo: chooseView.centerYAnchor).isActive = true
        chooseIconView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        chooseIconView.widthAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
}
