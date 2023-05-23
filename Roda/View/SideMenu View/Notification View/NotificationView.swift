//
//  NotificationView.swift
//  Taxiappz Driver
//
//  Created by Apple on 18/05/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit
import DSGradientProgressView
class NotificationView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
    
    let progressView = DSGradientProgressView()
    
    let tblNotification = UITableView()
    
    let msgView = UIView()
    let imgNoData = UIImageView()
    let msgLbl = UILabel()
    
    var layoutDict = [String: AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
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
        
        titleLbl.text = "txt_noitification".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
      
        
        progressView.barColor = .themeColor
        layoutDict["progressView"] = progressView
        progressView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(progressView)
        
        tblNotification.tableFooterView = UIView()
        tblNotification.backgroundColor = .secondaryColor
        layoutDict["tblNotification"] = tblNotification
        tblNotification.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblNotification)
        
        msgView.isHidden = true
        layoutDict["msgView"] = msgView
        msgView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(msgView)
        
        imgNoData.image = UIImage(named: "img_norides")
        imgNoData.contentMode = .scaleAspectFit
        layoutDict["imgNoData"] = imgNoData
        imgNoData.translatesAutoresizingMaskIntoConstraints = false
        msgView.addSubview(imgNoData)
        
        msgLbl.text = "txt_no_records".localize().capitalized
        msgLbl.numberOfLines = 0
        msgLbl.lineBreakMode = .byWordWrapping
        msgLbl.textAlignment = .center
        msgLbl.textColor = .txtColor
        msgLbl.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["msgLbl"] = msgLbl
        msgLbl.translatesAutoresizingMaskIntoConstraints = false
        msgView.addSubview(msgLbl)
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        
        tblNotification.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-3-[progressView(2)]-20-[tblNotification]", options: [], metrics: nil, views: layoutDict))

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[progressView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[tblNotification]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        msgView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 0).isActive = true
        msgView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[msgView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        imgNoData.widthAnchor.constraint(equalToConstant: 180).isActive = true
        imgNoData.heightAnchor.constraint(equalToConstant: 158).isActive = true
        imgNoData.centerXAnchor.constraint(equalTo: msgView.centerXAnchor, constant: 0).isActive = true
        imgNoData.centerYAnchor.constraint(equalTo: msgView.centerYAnchor, constant: 0).isActive = true
        
        msgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgNoData]-10-[msgLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        msgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[msgLbl]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
    }
}

class NotificationTableCell: UITableViewCell {
    
    let viewContent = UIView()
    let imgview = UIImageView()
    let lblTitle = UILabel()
    let lblMsg = UILabel()
    let lblDate = UILabel()
    
    var layoutDict = [String: AnyObject]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //viewContent.applyGradient(colours: [UIColor.random, UIColor.random], radius: 5, locations: [0.0,1.0])
    }
    
    func setupViews() {
        
        self.selectionStyle = .none
        
        viewContent.backgroundColor = .clear
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgview)
        
        lblTitle.textColor = .txtColor
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.textAlignment = APIHelper.appTextAlignment
        lblTitle.font = UIFont.appBoldFont(ofSize: 18)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        lblMsg.numberOfLines = 0
        lblMsg.lineBreakMode = .byWordWrapping
        lblMsg.font = UIFont.appFont(ofSize: 14)
        lblMsg.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblMsg"] = lblMsg
        lblMsg.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblMsg)
        
        lblDate.textColor = .gray
        lblDate.font = UIFont.appFont(ofSize: 16)
        layoutDict["lblDate"] = lblDate
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblDate)
        
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[viewContent]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewContent]-8-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblDate]-5-[lblTitle(>=30)][lblMsg(>=30)]-10-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgview(35)]-8-[lblTitle]-8-|", options: [APIHelper.appLanguageDirection,.alignAllTop], metrics: nil, views: layoutDict))
        imgview.heightAnchor.constraint(equalToConstant: 35).isActive = true
        imgview.centerYAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[lblDate]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imgview]-8-[lblMsg]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
