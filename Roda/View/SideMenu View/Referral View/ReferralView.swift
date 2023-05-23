//
//  ReferralView.swift
//  Roda
//
//  Created by Apple on 26/04/22.
//

import UIKit

class ReferralView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
    
    let lblInviteFriends = UILabel()
    let lblInviteHint = UILabel()
    let lblTotalReferralTitle = UILabel()
    let lblTotalAmount = UILabel()
    
    let imgview = UIImageView()
    
    let lblYourReferralCode = UILabel()
    let lblRefferalCode = UILabel()
    
    
    let btnShare = UIButton()

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
        
        titleLbl.text = "refferal_code".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        lblInviteFriends.text = "txt_invite_friends".localize()
        lblInviteFriends.font = .appBoldFont(ofSize: 20)
        lblInviteFriends.textColor = .txtColor
        lblInviteFriends.textAlignment = .center
        layoutDict["lblInviteFriends"] = lblInviteFriends
        lblInviteFriends.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblInviteFriends)
        
        lblInviteHint.text = "txt_invite_content".localize()
        lblInviteHint.numberOfLines = 0
        lblInviteHint.lineBreakMode = .byWordWrapping
        lblInviteHint.font = .appRegularFont(ofSize: 14)
        lblInviteHint.textColor = .hexToColor("2F2E2E")
        lblInviteHint.textAlignment = .center
        layoutDict["lblInviteHint"] = lblInviteHint
        lblInviteHint.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblInviteHint)
        
        lblTotalReferralTitle.text = "txt_total_referral_amount".localize()
        lblTotalReferralTitle.font = .appBoldFont(ofSize: 18)
        lblTotalReferralTitle.textColor = .txtColor
        lblTotalReferralTitle.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblTotalReferralTitle"] = lblTotalReferralTitle
        lblTotalReferralTitle.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblTotalReferralTitle)
        
        lblTotalAmount.font = .appBoldFont(ofSize: 25)
        lblTotalAmount.textColor = .txtColor
        lblTotalAmount.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblTotalAmount"] = lblTotalAmount
        lblTotalAmount.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblTotalAmount)
        
        
        imgview.image = UIImage(named: "img_referral_background")
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(imgview)
        
        
        lblYourReferralCode.text = "txt_your_referral_code".localize()
        lblYourReferralCode.font = .appBoldFont(ofSize: 16)
        lblYourReferralCode.textColor = .hexToColor("2F2E2E")
        lblYourReferralCode.textAlignment = .center
        layoutDict["lblYourReferralCode"] = lblYourReferralCode
        lblYourReferralCode.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblYourReferralCode)
        
        let viewReferralCode = UIViewWithDashedLineBorder()
        viewReferralCode.backgroundColor = .clear
        layoutDict["viewReferralCode"] = viewReferralCode
        viewReferralCode.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewReferralCode)
        
        
        lblRefferalCode.font = .appBoldFont(ofSize: 16)
        lblRefferalCode.textColor = .hexToColor("2F2E2E")
        lblRefferalCode.textAlignment = .center
        layoutDict["lblRefferalCode"] = lblRefferalCode
        lblRefferalCode.translatesAutoresizingMaskIntoConstraints = false
        viewReferralCode.addSubview(lblRefferalCode)
        
       
        
        btnShare.setTitle("text_share".localize(), for: .normal)
        btnShare.layer.cornerRadius = 8
        btnShare.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        btnShare.setTitleColor(.themeTxtColor, for: .normal)
        btnShare.backgroundColor = .themeColor
        layoutDict["btnShare"] = btnShare
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnShare)
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        
        btnShare.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        btnShare.heightAnchor.constraint(equalToConstant: 45).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnShare]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-30-[lblInviteFriends(30)][lblInviteHint(<=50)]-20-[lblTotalAmount(30)]-20-[imgview]-20-[btnShare]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblInviteFriends]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblInviteHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTotalReferralTitle]-8-[lblTotalAmount]-16-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        lblTotalAmount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
      
        lblYourReferralCode.bottomAnchor.constraint(equalTo: imgview.centerYAnchor, constant: -80).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblYourReferralCode(30)]-10-[viewReferralCode(40)]", options: [], metrics: nil, views: layoutDict))
        
       
        lblYourReferralCode.centerXAnchor.constraint(equalTo: viewReferralCode.centerXAnchor, constant: 0).isActive = true
        
        if APIHelper.appLanguageDirection == .directionRightToLeft {
            baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[viewReferralCode]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        } else {
            baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewReferralCode]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        }
        
        viewReferralCode.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[lblRefferalCode]-50-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewReferralCode.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblRefferalCode]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
    }

}


class UIViewWithDashedLineBorder: UIView {

    override func draw(_ rect: CGRect) {

         let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8))

        UIColor.hexToColor("#E7FFF4").setFill()
        path.fill()

        UIColor.hexToColor("#48CB90").setStroke()
        path.lineWidth = 6

        let dashPattern : [CGFloat] = [4, 2]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}
