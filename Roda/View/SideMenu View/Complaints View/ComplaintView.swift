//
//  ComplaintView.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit


class ComplaintView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let tblComplaintList = UITableView()
    let complainttxtvw = UITextView()
    
    
    let complaintsavebtn = UIButton()
    
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
        
        titleLbl.text = "txt_complaints".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollView"] = scrollView
        baseView.addSubview(scrollView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        scrollView.addSubview(containerView)

        
        tblComplaintList.alwaysBounceVertical = false
        tblComplaintList.backgroundColor = .secondaryColor
        tblComplaintList.separatorStyle = .none
        tblComplaintList.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tblComplaintList"] = tblComplaintList
        containerView.addSubview(tblComplaintList)
    

        complainttxtvw.backgroundColor = .hexToColor("EAEAEA")
        complainttxtvw.textColor = .gray
        complainttxtvw.textAlignment = APIHelper.appTextAlignment
        complainttxtvw.font = UIFont.appRegularFont(ofSize: 14)
        complainttxtvw.layer.cornerRadius = 5
        complainttxtvw.layer.borderWidth = 1
        complainttxtvw.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
        complainttxtvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["complainttxtvw"] = complainttxtvw
        containerView.addSubview(complainttxtvw)
        
        complaintsavebtn.setTitle("text_submit".localize().uppercased(), for: .normal)
        complaintsavebtn.titleLabel?.textAlignment = APIHelper.appTextAlignment
        complaintsavebtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        complaintsavebtn.setTitleColor(.themeTxtColor, for: .normal)
        complaintsavebtn.backgroundColor = .themeColor
        complaintsavebtn.layer.cornerRadius = 5
        complaintsavebtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["complaintsavebtn"] = complaintsavebtn
        baseView.addSubview(complaintsavebtn)
        

        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        complaintsavebtn.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-20-[scrollView]-8-[complaintsavebtn(45)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[complaintsavebtn]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerHgt.priority = .defaultLow
        containerHgt.isActive = true
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[tblComplaintList]-20-[complainttxtvw(120)]-10-|", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[tblComplaintList]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[complainttxtvw]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.layoutIfNeeded()
        baseView.setNeedsLayout()

    }
    
}


class ComplaintListCell: UITableViewCell {
    
    let viewContent = UIView()
    var cancelReasonLbl = UILabel()
    var checkMark = UIImageView()
    var lineView = UIView()
    
    var layoutDict = [String: AnyObject]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpViews() { // adding ui elements to superview
        
        contentView.isUserInteractionEnabled = true
        
        viewContent.layer.cornerRadius = 5
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        cancelReasonLbl.textAlignment = APIHelper.appTextAlignment
        cancelReasonLbl.numberOfLines = 0
        cancelReasonLbl.lineBreakMode = .byWordWrapping
        cancelReasonLbl.translatesAutoresizingMaskIntoConstraints = false
        cancelReasonLbl.font = UIFont.appMediumFont(ofSize: 16)
        layoutDict["cancelReasonLbl"] = cancelReasonLbl
        viewContent.addSubview(cancelReasonLbl)
        
        checkMark.image = UIImage(named: "ic_uncheck")
        layoutDict["checkMark"] = checkMark
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(checkMark)

        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewContent]-8-|", options: [], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[viewContent]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[cancelReasonLbl(>=30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelReasonLbl]-10-[checkMark(16)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        checkMark.centerYAnchor.constraint(equalTo: cancelReasonLbl.centerYAnchor, constant: 0).isActive = true
        checkMark.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }

}
