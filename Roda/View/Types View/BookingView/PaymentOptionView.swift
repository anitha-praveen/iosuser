//
//  PaymentOptionView.swift
//  Roda
//
//  Created by Apple on 26/08/22.
//

import UIKit

class PaymentOptionView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
    
    private let lblHeader: UILabel = {
        let lbl = UILabel()
        lbl.text = "Choose your payment option"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .txtColor
        lbl.textAlignment = APIHelper.appTextAlignment
        lbl.font = UIFont.appRegularFont(ofSize: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let tblPayOptions: UITableView = {
        let tblview = UITableView()
        tblview.alwaysBounceVertical = false
        tblview.backgroundColor = .secondaryColor
        tblview.translatesAutoresizingMaskIntoConstraints = false
        return tblview
    }()
    
    let btnConfirm: UIButton = {
        let btn = UIButton()
        btn.setTitle("txt_confirm".localize().uppercased(), for: .normal)
        btn.setTitleColor(.themeTxtColor, for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btn.backgroundColor = .themeColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    

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
        
        titleLbl.text = "Payment".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        
        layoutDict["lblHeader"] = lblHeader
        baseView.addSubview(lblHeader)
        
        layoutDict["tblPayOptions"] = tblPayOptions
        baseView.addSubview(tblPayOptions)
        
        layoutDict["btnConfirm"] = btnConfirm
        baseView.addSubview(btnConfirm)
        
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-25-[lblHeader]-25-[tblPayOptions]-15-[btnConfirm(45)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[lblHeader]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblPayOptions]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[btnConfirm]-25-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnConfirm.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
    }
}


class PaymentOptionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -15)
        
        self.textLabel?.font = UIFont.appSemiBold(ofSize: 18)
        
        self.detailTextLabel?.font = UIFont.appRegularFont(ofSize: 13)
        self.detailTextLabel?.textColor = .gray
        self.detailTextLabel?.numberOfLines = 0
        self.detailTextLabel?.lineBreakMode = .byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


enum PaymentOption:String, CaseIterable {
    case cash = "1"
    case card = "2"
    case upi = "3"
    case wallet = "4"
    
    var title: String {
        switch self {
        case .cash:
            return "Cash"
        case .card:
            return "Card"
        case .upi:
            return "UPI"
        case .wallet:
            return "Wallet"
        }
    }
    var desc: String {
        switch self {
            
        case .cash:
            return "Pay ride amount by cash."
        case .card:
            return "Master card, Visa card, Credit / Debit card etc."
        case .upi:
            return "Use UPI intents (i.e Gpay, Paytm, phonePe)."
        case .wallet:
            return "Use your wallet amount to pay ride amount."
        }
    }
    
    var image: String {
        switch self {
            
        case .cash:
            return "cash-icon"
        case .card:
            return "card-icon"
        case .upi:
            return "upi-icon"
        case .wallet:
            return "wallet-icon"
        }
    }
    
    var slug: String {
        switch self {
        case .cash:
            return "CASH"
        case .card:
            return "CARD"
        case .upi:
            return "CARD"
        case .wallet:
            return "WALLET"
        }
    }
}
