//
//  RideLaterSucessVC.swift
//  Taxiappz
//
//  Created by Apple on 03/03/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit

class RideLaterSucessVC: UIViewController {
    
    let viewContent = UIView()
    let appNameLbl = UILabel()
    let imageView = UIImageView()
    let textLbl = UILabel()
    let okBtn = UIButton()
        
    var layoutDic = [String: AnyObject]()
    var rideLaterDate = Date()
    var callBack:((String)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.7)
        
        viewContent.backgroundColor = .secondaryColor
        viewContent.layer.cornerRadius = 30
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewContent"] = viewContent
        self.view.addSubview(viewContent)
        
        appNameLbl.text = APIHelper.shared.appName?.uppercased()
        appNameLbl.textAlignment = .center
        appNameLbl.font = UIFont.appSemiBold(ofSize: 24)
        appNameLbl.textColor = .txtColor
        appNameLbl.backgroundColor = .secondaryColor
        appNameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["appNameLbl"] = appNameLbl
        viewContent.addSubview(appNameLbl)
        
        imageView.image = UIImage(named: "tick_img_big")
        imageView.backgroundColor = .secondaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imageView"] = imageView
        viewContent.addSubview(imageView)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd,MMM hh:mm a"
        let timeStr = timeFormatter.string(from: self.rideLaterDate)
        
        textLbl.text = "text_ride_later_sucess".localize() + "\n" + timeStr
        textLbl.textAlignment = .center
        textLbl.font = UIFont.appRegularFont(ofSize: 16)
        textLbl.numberOfLines = 0
        textLbl.lineBreakMode = .byWordWrapping
        textLbl.textColor = .hexToColor("B1B1B1")
        textLbl.backgroundColor = .secondaryColor
        textLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["textLbl"] = textLbl
        viewContent.addSubview(textLbl)
        
        okBtn.setTitle("text_ok".localize().uppercased(), for: .normal)
        okBtn.backgroundColor = .themeColor
        okBtn.layer.cornerRadius = 8
        okBtn.addTarget(self, action: #selector(okBtnAction(_ :)), for: .touchUpInside)
        okBtn.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        okBtn.setTitleColor(.themeTxtColor, for: .normal)
        okBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["okBtn"] = okBtn
        viewContent.addSubview(okBtn)
        
      
        viewContent.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[appNameLbl(30)]-20-[imageView(100)]-(20)-[textLbl(>=30)]-(20)-[okBtn(45)]-30-|", options: [], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[appNameLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(50)-[textLbl]-(50)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.viewContent.centerXAnchor, constant: 0).isActive = true
        
        okBtn.widthAnchor.constraint(equalToConstant: 130).isActive = true
        okBtn.centerXAnchor.constraint(equalTo: self.viewContent.centerXAnchor, constant: 0).isActive = true
        
        
    }
    
    @objc func okBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.callBack?("sucess")
        }
        
    }
    
}
