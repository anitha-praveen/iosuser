//
//  NoDriversFoundView.swift
//  Roda
//
//  Created by Apple on 10/06/22.
//

import UIKit

class NoDriversFoundView: UIView {

    let imgview = UIImageView()
    let lblDemand = UILabel()
    let lblHint = UILabel()
    let btnCancelTrip = UIButton()
    let btnCallUs = UIButton()
    
    let btnClose = UIButton()
   
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        imgview.image = UIImage(named: "img_no_driver_girl")
        imgview.contentMode = .scaleAspectFill
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(imgview)
        
        lblDemand.text = "txt_high_demand".localize().uppercased()
        lblDemand.textAlignment = .center
        lblDemand.font = UIFont.appSemiBold(ofSize: 22)
        lblDemand.textColor = .txtColor
        layoutDict["lblDemand"] = lblDemand
        lblDemand.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblDemand)
        
        lblHint.font = UIFont.appRegularFont(ofSize: 16)
        let str = "txt_your_trip".localize() + " " + "txt_assign_trip".localize()
        let stringOne = str + "\n" + "txt_call_us_for_support".localize()
        
        let attributedString = NSMutableAttributedString(string: stringOne)
        let foundRange = attributedString.mutableString.range(of: "txt_assign_trip".localize())
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 18), range: foundRange)
        lblHint.attributedText = attributedString
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textAlignment = .center
        
        lblHint.textColor = .txtColor
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHint)
        
        btnCancelTrip.setTitle("txt_cancel_book".localize(), for: .normal)
        btnCancelTrip.layer.cornerRadius = 8
        btnCancelTrip.setTitleColor(.themeTxtColor, for: .normal)
        btnCancelTrip.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnCancelTrip.titleLabel?.numberOfLines = 0
        btnCancelTrip.titleLabel?.lineBreakMode = .byWordWrapping
        btnCancelTrip.backgroundColor = .themeColor
        layoutDict["btnCancelTrip"] = btnCancelTrip
        btnCancelTrip.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnCancelTrip)
        
        btnCallUs.setTitle("txt_call_us".localize(), for: .normal)
        btnCallUs.layer.cornerRadius = 8
        btnCallUs.setTitleColor(.themeTxtColor, for: .normal)
        btnCallUs.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnCallUs.backgroundColor = .themeColor
        layoutDict["btnCallUs"] = btnCallUs
        btnCallUs.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnCallUs)
        
        btnClose.setImage(UIImage(named: "ic_close"), for: .normal)
        layoutDict["btnClose"] = btnClose
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnClose)
        
        
        imgview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        btnCallUs.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgview]-20-[lblDemand(30)][lblHint(>=50)]-25-[btnCallUs(45)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[imgview]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lblDemand]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lblHint]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnCancelTrip]-16-[btnCallUs(==btnCancelTrip)]-16-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        
        btnClose.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: 30).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnClose(30)]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
    }
}
