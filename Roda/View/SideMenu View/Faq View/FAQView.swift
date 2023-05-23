//
//  FAQView.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class FAQView: UIView {

    let backBtn = UIButton()
    let titleLbl = UILabel()
    let faqTb = UITableView()
    
    var layoutDict = [String: AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        
        titleLbl.text = "text_faq".localize().uppercased()
        titleLbl.font = .appSemiBold(ofSize: 30)
        titleLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl

        faqTb.alwaysBounceVertical = false
        faqTb.tableFooterView = UIView()
        faqTb.separatorStyle = .none
        faqTb.rowHeight = UITableView.automaticDimension
        faqTb.tableFooterView = UIView()
        faqTb.estimatedRowHeight = 50
        layoutDict["faqTb"] = faqTb
        
        [backBtn, titleLbl, faqTb].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            baseView.addSubview($0)
        }
        
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor , constant: 20).isActive = true
        faqTb.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-10-[titleLbl(30)]-20-[faqTb]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLbl]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[faqTb]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}

class FAQCell: UITableViewCell {

    var layoutDic = [String:AnyObject]()
    let stackView = UIStackView()
    let questionLbl = UILabel()
    let expandBtn = UIButton(type: .custom)
    let answerLbl = Label()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    func setupViews() {

        contentView.isUserInteractionEnabled = true
        
        let viewContent = UIView()
        viewContent.backgroundColor = .secondaryColor
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewContent"] = viewContent
        addSubview(viewContent)

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["stackView"] = stackView
        viewContent.addSubview(stackView)
        
        let QuestExpandBtnView = UIView()
        QuestExpandBtnView.backgroundColor = .secondaryColor
        QuestExpandBtnView.layer.cornerRadius = 5
        QuestExpandBtnView.layer.borderWidth = 1
        QuestExpandBtnView.layer.borderColor = UIColor.themeColor.cgColor
        QuestExpandBtnView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["QuestExpandBtnView"] = QuestExpandBtnView
        stackView.addArrangedSubview(QuestExpandBtnView)
        
        questionLbl.font = UIFont.appRegularFont(ofSize: 15)
        questionLbl.numberOfLines = 0
        questionLbl.lineBreakMode = .byWordWrapping
        questionLbl.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        questionLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["questionLbl"] = questionLbl
        QuestExpandBtnView.addSubview(questionLbl)

        expandBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["expandBtn"] = expandBtn
        QuestExpandBtnView.addSubview(expandBtn)

        answerLbl.numberOfLines = 0
        answerLbl.layer.borderWidth = 1
        answerLbl.lineBreakMode = .byWordWrapping
        answerLbl.font = UIFont.appRegularFont(ofSize: 13)
        answerLbl.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1)
        answerLbl.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
        answerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["answerLbl"] = answerLbl
        stackView.addArrangedSubview(answerLbl)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent]|", options: [], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[viewContent]-(15)-|", options: [], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[stackView]-(5)-|", options: [], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[stackView]-(0)-|", options: [], metrics: nil, views: layoutDic))
        
        stackView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[QuestExpandBtnView]|", options: [], metrics: nil, views: layoutDic))
        expandBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        expandBtn.centerYAnchor.constraint(equalTo: questionLbl.centerYAnchor, constant: 0).isActive = true
        QuestExpandBtnView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[questionLbl]|", options: [], metrics: nil, views: layoutDic))
        QuestExpandBtnView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[questionLbl]-(5)-[expandBtn(20)]-10-|", options: [], metrics: nil, views: layoutDic))
        
        questionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        answerLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }

}

class Label: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    }
}
