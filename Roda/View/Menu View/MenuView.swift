//
//  MenuView.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class MenuView: UIView {

    let sidemenutopview = UIView()
    let profilepictureiv = UIImageView()
    let activityIndicator = UIActivityIndicatorView()
    let profileusernamelbl = UILabel()
    let greetingsLbl = UILabel()
    let menulistTableview = UITableView()
    
    let viewVersion = UIView()
    let lblVersion = UILabel()
    let btnSos = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .secondaryColor

        [profileusernamelbl,sidemenutopview,menulistTableview,profilepictureiv].forEach { $0?.removeFromSuperview() }

        sidemenutopview.backgroundColor = .hexToColor("#EAEAEA")
        sidemenutopview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sidemenutopview"] = sidemenutopview
        baseView.addSubview(sidemenutopview)
        
        let nameView = UIView()
        layoutDict["nameView"] = nameView
        nameView.translatesAutoresizingMaskIntoConstraints = false
        sidemenutopview.addSubview(nameView)
        
        greetingsLbl.text = "txt_my_profile".localize()
        greetingsLbl.isUserInteractionEnabled = true
        greetingsLbl.font = UIFont.appSemiBold(ofSize: 16)
        greetingsLbl.textAlignment = APIHelper.appTextAlignment
        greetingsLbl.textColor = .hexToColor("#4878F1")
        layoutDict["greetingsLbl"] = greetingsLbl
        greetingsLbl.translatesAutoresizingMaskIntoConstraints = false
        nameView.addSubview(greetingsLbl)
        
        profileusernamelbl.textAlignment = APIHelper.appTextAlignment
        profileusernamelbl.adjustsFontSizeToFitWidth = true
        profileusernamelbl.minimumScaleFactor = 0.1
        profileusernamelbl.textColor = .txtColor
        profileusernamelbl.font = UIFont.appBoldFont(ofSize: 18)
        profileusernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["profileusernamelbl"] = profileusernamelbl
        nameView.addSubview(profileusernamelbl)
        
        profilepictureiv.image = UIImage(named: "signup_profile_img")
        profilepictureiv.layer.masksToBounds = false
        profilepictureiv.layer.cornerRadius = 30
        profilepictureiv.clipsToBounds = true
        profilepictureiv.tintColor = .secondaryColor
        profilepictureiv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["profilepictureiv"] = profilepictureiv
        sidemenutopview.addSubview(profilepictureiv)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["activityIndicator"] = activityIndicator
        sidemenutopview.addSubview(activityIndicator)
        
        menulistTableview.alwaysBounceVertical = false
        menulistTableview.separatorStyle = .none
        menulistTableview.tableFooterView = UIView()
        menulistTableview.backgroundColor = .secondaryColor
        menulistTableview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["menulistTableview"] = menulistTableview
        baseView.addSubview(menulistTableview)
        
        viewVersion.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewVersion"] = viewVersion
        baseView.addSubview(viewVersion)
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text = "txt_app_version".localize() + " - V\(appVersion)"
        }
        lblVersion.textAlignment = APIHelper.appTextAlignment
        lblVersion.textColor = .txtColor
        lblVersion.font = UIFont.appMediumFont(ofSize: 12)
        lblVersion.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblVersion"] = lblVersion
        viewVersion.addSubview(lblVersion)
        
        btnSos.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        btnSos.setTitleColor(.hexToColor("F31717"), for: .normal)
        btnSos.setTitle("txt_sos".localize().uppercased(), for: .normal)
        btnSos.titleLabel?.font = UIFont.appMediumFont(ofSize: 20)
        btnSos.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnSos"] = btnSos
        viewVersion.addSubview(btnSos)
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[sidemenutopview]-20-[menulistTableview]-10-[viewVersion(30)]-8-|", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[menulistTableview(==width)]", options: [APIHelper.appLanguageDirection], metrics: ["width": controller.revealViewController().rearViewRevealWidth], views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[sidemenutopview(==width)]", options: [APIHelper.appLanguageDirection], metrics: ["width": controller.revealViewController().rearViewRevealWidth], views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewVersion(==width)]", options: [APIHelper.appLanguageDirection], metrics: ["width": controller.revealViewController().rearViewRevealWidth], views: layoutDict))
        
        viewVersion.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblVersion]-8-[btnSos]-4-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        btnSos.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        viewVersion.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnSos]|", options: [], metrics: nil, views: layoutDict))
        
        
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[profilepictureiv(60)][nameView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        profilepictureiv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profilepictureiv.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true
        
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: profilepictureiv.centerXAnchor, constant: 0).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: profilepictureiv.centerYAnchor, constant: 0).isActive = true
        
        nameView.centerYAnchor.constraint(equalTo: sidemenutopview.centerYAnchor).isActive = true
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[nameView]-30-|", options: [], metrics: nil, views: layoutDict))
        
        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[profileusernamelbl(30)][greetingsLbl(30)]|", options: [], metrics: nil, views: layoutDict))
        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[profileusernamelbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[greetingsLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
 
class MenuTVCell: UITableViewCell {

    var lblname = UILabel()
    var img = UIImageView()
    var gradientlineimg = UIImageView()
    
    var layoutDic = [String:AnyObject]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    func setUpViews() {
        
        contentView.isUserInteractionEnabled = true
        
        self.subviews.forEach({$0.removeAllConstraints()})
        addSubview(lblname)
        
        lblname.font = .appRegularFont(ofSize: 16)
        lblname.textColor = .txtColor
        lblname.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblname"] = lblname
        lblname.textAlignment = APIHelper.appTextAlignment

        addSubview(img)
       // img.tintColor = .themeColor
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["img"] = img

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[img(25)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[img(25)]-(15)-[lblname]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllBottom,.alignAllTop], metrics: nil, views: layoutDic))
    }
   
}
