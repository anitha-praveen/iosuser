//
//  OutstationFareDetailView.swift
//  Roda
//
//  Created by Apple on 13/05/22.
//

import UIKit

class OutstationFareDetailView: UIView {
    
    let viewContent = UIView()
    let lblTitle = UILabel()
    let viewTotal = UIView()
    let lblTotalHint = UILabel()
    let lblTotalAmount = UILabel()
    let lblEstimation = UILabel()
    let stackPrice = UIStackView()
    
    let lblDescription = UILabel()
    let stackview = UIStackView()
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
        lblTitle.textAlignment = .center
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appBoldFont(ofSize: 20)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        viewTotal.layer.cornerRadius = 8
        viewTotal.addShadow()
        viewTotal.backgroundColor = .hexToColor("EAEAEA")
        viewTotal.alpha = 0.6
        layoutDict["viewTotal"] = viewTotal
        viewTotal.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewTotal)
        
        
        lblTotalHint.numberOfLines = 0
        lblTotalHint.lineBreakMode = .byWordWrapping
        lblTotalHint.textAlignment = .center
        lblTotalHint.textColor = .hexToColor("636363")
        lblTotalHint.font = UIFont.appRegularFont(ofSize: 12)
        layoutDict["lblTotalHint"] = lblTotalHint
        lblTotalHint.translatesAutoresizingMaskIntoConstraints = false
        viewTotal.addSubview(lblTotalHint)
        
        
        lblTotalAmount.textAlignment = .center
        lblTotalAmount.textColor = .txtColor
        lblTotalAmount.font = UIFont.appSemiBold(ofSize: 28)
        layoutDict["lblTotalAmount"] = lblTotalAmount
        lblTotalAmount.translatesAutoresizingMaskIntoConstraints = false
        viewTotal.addSubview(lblTotalAmount)
        
        lblEstimation.text = "txt_plain_estimated_fare".localize()
        lblEstimation.textAlignment = .center
        lblEstimation.textColor = .hexToColor("636363")
        lblEstimation.font = UIFont.appRegularFont(ofSize: 12)
        layoutDict["lblEstimation"] = lblEstimation
        lblEstimation.translatesAutoresizingMaskIntoConstraints = false
        viewTotal.addSubview(lblEstimation)
        
        stackPrice.axis = .vertical
        stackPrice.distribution = .fill
        stackPrice.spacing = 8
        layoutDict["stackPrice"] = stackPrice
        stackPrice.translatesAutoresizingMaskIntoConstraints = false
        viewTotal.addSubview(stackPrice)
        
       
        lblDescription.text = "txt_plain_description".localize()
        lblDescription.textAlignment = APIHelper.appTextAlignment
        lblDescription.textColor = .hexToColor("636363")
        lblDescription.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblDescription"] = lblDescription
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblDescription)
        
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 8
        layoutDict["stackview"] = stackview
        stackview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackview)
        
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
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[lblTitle(30)]-12-[viewTotal]-15-[lblDescription(30)]-8-[stackview]-15-[btnConfirm(40)]-10-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTitle]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewTotal]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblDescription]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackview]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnConfirm]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewTotal.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblTotalHint]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewTotal.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblTotalAmount(40)][lblEstimation]-8-[lblTotalHint]-8-[stackPrice]-8-|", options: [APIHelper.appLanguageDirection,.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
    }
}
