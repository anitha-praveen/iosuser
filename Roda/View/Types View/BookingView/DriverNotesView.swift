//
//  DriverNotesView.swift
//  Roda
//
//  Created by Apple on 03/06/22.
//

import UIKit

class DriverNotesView: UIView {
    
    private let viewContent = UIView()
    private let lblTitle = UILabel()
    let btnClose = UIButton()
    let txtView = UITextView()
    let btnSubmit = UIButton()

    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        btnClose.setImage(UIImage(named: "ic_close"), for: .normal)
        layoutDict["btnClose"] = btnClose
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnClose)
        
        lblTitle.text = "txt_notes_to_driver".localize()
        lblTitle.textColor = .txtColor
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        txtView.layer.cornerRadius = 8
        txtView.layer.borderWidth = 1
        txtView.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
        txtView.textColor = .gray
        txtView.font = UIFont.appRegularFont(ofSize: 16)
        txtView.backgroundColor = .hexToColor("f9f9f9")
        layoutDict["txtView"] = txtView
        txtView.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(txtView)
        
        btnSubmit.setTitle("text_submit".localize(), for: .normal)
        btnSubmit.layer.cornerRadius = 8
        btnSubmit.setTitleColor(.themeTxtColor, for: .normal)
        btnSubmit.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnSubmit.backgroundColor = .themeColor
        layoutDict["btnSubmit"] = btnSubmit
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnSubmit)
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblTitle(30)]-20-[txtView(150)]-20-[btnSubmit(45)]-20-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[lblTitle]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnClose(30)]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnClose.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnClose.centerYAnchor.constraint(equalTo: lblTitle.centerYAnchor, constant: 0).isActive = true
        
    }

}
