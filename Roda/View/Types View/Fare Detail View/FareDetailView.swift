//
//  FareDetailView.swift
//  Roda
//
//  Created by Apple on 23/04/22.
//

import UIKit

class FareDetailView: UIView {
    
    let viewContent = UIView()
    let lblTitle = UILabel()
    let viewVehicleType = UIView()
    let lblVehicleType = UILabel()
    let lblTypeName = UILabel()
    let imgVehicleType = UIImageView()
    
    let stackvw = UIStackView()
    let imgSeparator = UIImageView()
    
    let lblTotalFare = UILabel()
    let lblTotalAmount = UILabel()
    
    let lblNote = UILabel()
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
        
        lblTitle.text = "txt_FareDetails".localize()
        lblTitle.textAlignment = APIHelper.appTextAlignment
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appBoldFont(ofSize: 20)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        viewVehicleType.layer.cornerRadius = 8
        viewVehicleType.backgroundColor = .hexToColor("EAEAEA")
        layoutDict["viewVehicleType"] = viewVehicleType
        viewVehicleType.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewVehicleType)
        
        lblVehicleType.text = "txt_vehicle_type".localize()
        lblVehicleType.textAlignment = APIHelper.appTextAlignment
        lblVehicleType.textColor = .hexToColor("636363")
        lblVehicleType.font = UIFont.appRegularFont(ofSize: 12)
        layoutDict["lblVehicleType"] = lblVehicleType
        lblVehicleType.translatesAutoresizingMaskIntoConstraints = false
        viewVehicleType.addSubview(lblVehicleType)
        
        
        lblTypeName.textAlignment = APIHelper.appTextAlignment
        lblTypeName.textColor = .hexToColor("616161")
        lblTypeName.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblTypeName"] = lblTypeName
        lblTypeName.translatesAutoresizingMaskIntoConstraints = false
        viewVehicleType.addSubview(lblTypeName)
        
        imgVehicleType.contentMode = .scaleAspectFit
        layoutDict["imgVehicleType"] = imgVehicleType
        imgVehicleType.translatesAutoresizingMaskIntoConstraints = false
        viewVehicleType.addSubview(imgVehicleType)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        layoutDict["stackvw"] = stackvw
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackvw)
        
        imgSeparator.image = UIImage(named: "img_separator")
        layoutDict["imgSeparator"] = imgSeparator
        imgSeparator.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgSeparator)
        
        lblTotalFare.text = "txt_total_fare_estimation".localize()
        lblTotalFare.textColor = .txtColor
        lblTotalFare.textAlignment = APIHelper.appTextAlignment
        lblTotalFare.font = UIFont.appBoldFont(ofSize: 16)
        layoutDict["lblTotalFare"] = lblTotalFare
        lblTotalFare.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTotalFare)
        
        lblTotalAmount.textColor = .txtColor
        lblTotalAmount.textAlignment = APIHelper.appTextAlignment
        lblTotalAmount.font = UIFont.appBoldFont(ofSize: 20)
        layoutDict["lblTotalAmount"] = lblTotalAmount
        lblTotalAmount.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTotalAmount)
        
        lblNote.text = "txt_estimates_text".localize()
        lblNote.textAlignment = .center
        lblNote.numberOfLines = 0
        lblNote.lineBreakMode = .byWordWrapping
        lblNote.textColor = .hexToColor("606060")
        lblNote.font = UIFont.appRegularFont(ofSize: 12)
        layoutDict["lblNote"] = lblNote
        lblNote.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblNote)
        
        btnConfirm.layer.cornerRadius = 8
        btnConfirm.setTitle("txt_Gotit".localize(), for: .normal)
        btnConfirm.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        btnConfirm.setTitleColor(.themeTxtColor, for: .normal)
        btnConfirm.backgroundColor = .themeColor
        layoutDict["btnConfirm"] = btnConfirm
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnConfirm)
        
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[lblTitle(30)]-12-[viewVehicleType]-15-[stackvw]-10-[imgSeparator(5)]-8-[lblTotalAmount(30)]-20-[lblNote]-15-[btnConfirm(40)]-10-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTitle]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewVehicleType]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewVehicleType.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblVehicleType]-8-[imgVehicleType(70)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewVehicleType.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblVehicleType]-5-[lblTypeName]-8-|", options: [APIHelper.appLanguageDirection,.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        imgVehicleType.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imgVehicleType.centerYAnchor.constraint(equalTo: viewVehicleType.centerYAnchor, constant: 0).isActive = true
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackvw]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[imgSeparator]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTotalFare]-8-[lblTotalAmount]-16-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        lblTotalAmount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblNote]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnConfirm]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
