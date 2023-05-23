//
//  AboutusView.swift
//  Roda
//
//  Created by Apple on 13/05/22.
//

import UIKit

class AboutusView: UIView {

    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
    
    let lblAbout = UILabel()
    let lblVersion = UILabel()
    
    let tblview = UITableView()
    
    let lblLove = UILabel()
    
    var layoutDict = [String: AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        backBtn.contentMode = .scaleAspectFit
        backBtn.setAppImage("backDark")
        backBtn.layer.cornerRadius = 20
        backBtn.addShadow()
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = APIHelper.shared.appName?.uppercased()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        
        lblAbout.text = "txt_plain_about".localize()
        lblAbout.font = .appMediumFont(ofSize: 20)
        lblAbout.textColor = .txtColor
        lblAbout.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblAbout"] = lblAbout
        lblAbout.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblAbout)
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text = "txt_app_version".localize() + " - V\(appVersion)"
        }
        lblVersion.font = .appRegularFont(ofSize: 16)
        lblVersion.textColor = .gray
        lblVersion.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblVersion"] = lblVersion
        lblVersion.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblVersion)
        
        tblview.tableFooterView = UIView()
        tblview.alwaysBounceVertical = false
        tblview.backgroundColor = .secondaryColor
        layoutDict["tblview"] = tblview
        tblview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblview)
        
        let fullString = NSMutableAttributedString(string: "txt_made_with".localize() + " ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "ic_love")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: " " + "txt_in".localize() + " " + "txt_place_name".localize()))
        lblLove.isHidden = true
        lblLove.attributedText = fullString
        lblLove.font = .appRegularFont(ofSize: 16)
        lblLove.textColor = .hexToColor("515151")
        lblLove.textAlignment = .center
        layoutDict["lblLove"] = lblLove
        lblLove.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblLove)
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        
        lblLove.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-30-[lblAbout(30)][lblVersion(30)]-20-[tblview]-20-[lblLove(40)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lblAbout]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lblVersion]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[tblview]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblLove]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
