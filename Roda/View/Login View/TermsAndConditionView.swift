//
//  TermsAndConditionView.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import WebKit
class TermsAndConditionView: UIView {
    
    let btnBack = UIButton()
    let lblHeader = UILabel()
    let wkWebView = WKWebView()
    
    let indicatorView = UIActivityIndicatorView()

    var layoutDic = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        
        btnBack.setAppImage("BackImage")
        layoutDic["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        lblHeader.text = "text_terms_conditions".localize()
        lblHeader.numberOfLines = 0
        lblHeader.lineBreakMode = .byWordWrapping
        lblHeader.font = UIFont.appSemiBold(ofSize: 24)
        lblHeader.textColor = .txtColor
        lblHeader.textAlignment = APIHelper.appTextAlignment
        layoutDic["lblHeader"] = lblHeader
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHeader)
        
        wkWebView.backgroundColor = .secondaryColor
        layoutDic["wkWebView"] = wkWebView
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(wkWebView)
        
        indicatorView.color = .themeColor
        layoutDic["indicatorView"] = indicatorView
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(indicatorView)
        
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(30)]-10-[lblHeader]-10-[wkWebView]", options: [], metrics: nil, views: layoutDic))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnBack(30)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblHeader]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[wkWebView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        indicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        
    }

}
