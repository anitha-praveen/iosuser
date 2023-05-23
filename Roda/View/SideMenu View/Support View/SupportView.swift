//
//  SupportView.swift
//  Taxiappz
//
//  Created by spextrum on 29/12/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class SupportView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()

    let tblSupport = UITableView()
    
    let viewAdmin = UIView()
    let lblAdmin = UILabel()
    let lblNeedSupport = UILabel()
    let btnCallAdmin = UIButton()
    
    var layoutDic = [String: AnyObject]()
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
        layoutDic["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDic["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "txt_support".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
       
        
        tblSupport.alwaysBounceVertical = false
        tblSupport.backgroundColor = .secondaryColor
        tblSupport.separatorStyle = .none
        tblSupport.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tblSupport"] = tblSupport
        baseView.addSubview(tblSupport)
        
        viewAdmin.isHidden = true
        viewAdmin.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewAdmin"] = viewAdmin
        baseView.addSubview(viewAdmin)
        
        lblAdmin.text = "txt_admin".localize()
        lblAdmin.textAlignment = APIHelper.appTextAlignment
        lblAdmin.textColor = .txtColor
        lblAdmin.font = UIFont.appSemiBold(ofSize: 20)
        lblAdmin.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblAdmin"] = lblAdmin
        viewAdmin.addSubview(lblAdmin)
        
        lblNeedSupport.text = "txt_need_support".localize()
        lblNeedSupport.numberOfLines = 0
        lblNeedSupport.lineBreakMode = .byWordWrapping
        lblNeedSupport.textAlignment = APIHelper.appTextAlignment
        lblNeedSupport.textColor = .hexToColor("525252")
        lblNeedSupport.font = UIFont.appRegularFont(ofSize: 16)
        lblNeedSupport.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblNeedSupport"] = lblNeedSupport
        viewAdmin.addSubview(lblNeedSupport)
        
        btnCallAdmin.setImage(UIImage(named: "callBtn"), for: .normal)
        btnCallAdmin.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnCallAdmin"] = btnCallAdmin
        viewAdmin.addSubview(btnCallAdmin)
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-20-[tblSupport]-30-[viewAdmin]", options: [], metrics: nil, views: layoutDic))
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[tblSupport]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewAdmin]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewAdmin.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblAdmin(30)][lblNeedSupport(>=40)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewAdmin.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblAdmin]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewAdmin.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblNeedSupport]-8-[btnCallAdmin(40)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        btnCallAdmin.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnCallAdmin.centerYAnchor.constraint(equalTo: lblNeedSupport.centerYAnchor, constant: 0).isActive = true
        
    }

}
class SupportCell: UITableViewCell {
    
    let viewContent = UIView()
    let imgview = UIImageView()
    let lblName = UILabel()
    let imgArrow = UIImageView()
    
    var layoutDict = [String: AnyObject]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.backgroundColor = .secondaryColor
        
        selectionStyle = .none
        
        viewContent.layer.cornerRadius = 5
        viewContent.layer.borderWidth = 1
        viewContent.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        imgview.tintColor = .themeColor
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgview)
        
        lblName.textAlignment = APIHelper.appTextAlignment
        lblName.textColor = .txtColor
        lblName.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblName"] = lblName
        lblName.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblName)
        
        imgArrow.image = UIImage(named: "rightSideArrow")?.imageFlippedForRightToLeftLayoutDirection()
        imgArrow.contentMode = .scaleAspectFit
        layoutDict["imgArrow"] = imgArrow
        imgArrow.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgArrow)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[viewContent]-10-|", options: [], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[imgview(30)]-10-[lblName]-10-[imgArrow(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[imgview(30)]-10-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblName(30)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        imgArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgArrow.centerYAnchor.constraint(equalTo: lblName.centerYAnchor, constant: 0).isActive = true
        
    }
}
