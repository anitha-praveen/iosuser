//
//  PaymentSelectView.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class PaymentSelectView: UIView {

    let backBtn = UIButton()
    let titleLbl = UILabel()
    let selectpaymentcardlbl = UILabel()
    let cardlisttbv = UITableView()
    
    let btnConfirm = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)

        titleLbl.text = "txt_choose_pay".localize().capitalized
        titleLbl.font = .appSemiBold(ofSize: 30)
        titleLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleLbl)
        
        cardlisttbv.alwaysBounceVertical = false
        cardlisttbv.tableFooterView = UIView()
        cardlisttbv.separatorStyle = .none
        cardlisttbv.showsVerticalScrollIndicator = false
        cardlisttbv.backgroundColor = .secondaryColor
        cardlisttbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cardlisttbv"] = cardlisttbv
        cardlisttbv.tableFooterView = UIView()
        baseView.addSubview(cardlisttbv)
        
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.setTitle("txt_confirm".localize().uppercased(), for: .normal)
        btnConfirm.setTitleColor(.secondaryColor, for: .normal)
        btnConfirm.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnConfirm.backgroundColor = .themeColor
        layoutDict["btnConfirm"] = btnConfirm
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnConfirm)

        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor , constant: 20).isActive = true

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-15-[titleLbl(40)]-(25)-[cardlisttbv]-10-[btnConfirm(45)]", options: [], metrics: nil, views: layoutDict))
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cardlisttbv]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[btnConfirm]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        btnConfirm.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor,constant: -20).isActive = true
    }
    

}


class PaymentTypesCell: UITableViewCell {
    
    var layoutDic = [String:AnyObject]()
    
    var viewContent = UIView()
    var cardImv = UIImageView()
    var cardnumbeLbl = UILabel()
    var cardTypes = UILabel()
    var cardSelectionBtn = UIButton()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    func setUpViews() {
        
        addSubview(viewContent)
        
        viewContent.backgroundColor = .secondaryColor
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewContent"] = viewContent
        
        cardImv.contentMode = .scaleAspectFit
        viewContent.addSubview(cardImv)
        cardImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cardImv"] = cardImv
        
        viewContent.addSubview(cardnumbeLbl)
        cardnumbeLbl.font = UIFont.appRegularFont(ofSize: 16)
        cardnumbeLbl.textColor = .txtColor
        cardnumbeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cardnumbeLbl"] = cardnumbeLbl
        
        
        cardSelectionBtn.setImage(UIImage(named: "checked"), for: .selected)
        cardSelectionBtn.setImage(UIImage(named: "unchecked"), for: .normal)
        cardSelectionBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cardSelectionBtn"] = cardSelectionBtn
        viewContent.addSubview(cardSelectionBtn)
      
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[viewContent]-5-|", options: [], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[viewContent]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))

        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cardImv(40)]-(15)-[cardnumbeLbl]-(5)-[cardSelectionBtn(24)]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        cardImv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        cardImv.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        cardSelectionBtn.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        cardSelectionBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[cardnumbeLbl(30)]-(5)-|", options: [], metrics: nil, views: layoutDic))
        
    }
}
