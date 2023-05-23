//
//  SuggestionView.swift
//  Taxiappz
//
//  Created by Apple on 23/12/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class SuggestionView: UIView {
    
    let backBtn = UIButton()
    let titleLbl = UILabel()
    
    let suggestionLbl = UILabel()
    let viewSuggestionType = UIView()
    let lblSuggestionType = UITextField()
    let imgDownArrow = UIImageView()
    
    let suggestiontheaderlbl = UILabel()
    let suggestiontxtView = UITextView()
    
    let submitBtn = UIButton()
    
    let blurView = UIView()
    let tblCoverView = UIView()
    let tblSuggestionList = UITableView()
    
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
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        baseView.addSubview(backBtn)

        titleLbl.text = "txt_suggestion_title".localize()
        titleLbl.font = .appSemiBold(ofSize: 30)
        titleLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleLbl)

        suggestiontheaderlbl.text = "txt_suggestion".localize()
        suggestiontheaderlbl.textAlignment = APIHelper.appTextAlignment
        suggestiontheaderlbl.backgroundColor = .secondaryColor
        suggestiontheaderlbl.font = .appSemiBold(ofSize: 12)
        suggestiontheaderlbl.textColor = UIColor(red: 0.537, green: 0.573, blue: 0.639, alpha: 1)
        suggestiontheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["suggestiontheaderlbl"] = suggestiontheaderlbl
        baseView.addSubview(suggestiontheaderlbl)
        
        viewSuggestionType.isUserInteractionEnabled = true
        viewSuggestionType.layer.cornerRadius = 5
        viewSuggestionType.layer.borderWidth = 1
        viewSuggestionType.layer.borderColor = UIColor.gray.cgColor
        layoutDict["viewSuggestionType"] = viewSuggestionType
        viewSuggestionType.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewSuggestionType)
        
        lblSuggestionType.placeholder = "txt_suggestion_type".localize()
        lblSuggestionType.isUserInteractionEnabled = false
        lblSuggestionType.textColor = .txtColor
        lblSuggestionType.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["lblSuggestionType"] = lblSuggestionType
        lblSuggestionType.translatesAutoresizingMaskIntoConstraints = false
        viewSuggestionType.addSubview(lblSuggestionType)
        
        imgDownArrow.contentMode = .scaleAspectFit
        imgDownArrow.image = UIImage(named: "downArrowLight")
        layoutDict["imgDownArrow"] = imgDownArrow
        imgDownArrow.translatesAutoresizingMaskIntoConstraints = false
        viewSuggestionType.addSubview(imgDownArrow)

        suggestionLbl.text = "hint_your_comments".localize().uppercased()
        suggestionLbl.textAlignment = APIHelper.appTextAlignment
        suggestionLbl.backgroundColor = .secondaryColor
        suggestionLbl.font = .appSemiBold(ofSize: 12)
        suggestionLbl.textColor = UIColor(red: 0.537, green: 0.573, blue: 0.639, alpha: 1)
        suggestionLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["suggestionLbl"] = suggestionLbl
        baseView.addSubview(suggestionLbl)
        
        suggestiontxtView.backgroundColor = UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 0.5)
        suggestiontxtView.textColor = .txtColor
        suggestiontxtView.textAlignment = APIHelper.appTextAlignment
        suggestiontxtView.font = UIFont.appRegularFont(ofSize: 14)
        suggestiontxtView.layer.cornerRadius = 5
        suggestiontxtView.layer.borderWidth = 1
        suggestiontxtView.layer.borderColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1).cgColor
        suggestiontxtView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["suggestiontxtView"] = suggestiontxtView
        baseView.addSubview(suggestiontxtView)

        submitBtn.setTitle("text_submit".localize().uppercased(), for: .normal)
        submitBtn.titleLabel?.textAlignment = APIHelper.appTextAlignment
        submitBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 14)
        submitBtn.setTitleColor(.themeTxtColor, for: .normal)
        submitBtn.backgroundColor = .themeColor
        submitBtn.layer.cornerRadius = 5
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["submitBtn"] = submitBtn
        baseView.addSubview(submitBtn)
        
        blurView.isHidden = true
        blurView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.3)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["blurView"] = blurView
        baseView.addSubview(blurView)
        
        tblCoverView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tblCoverView"] = tblCoverView
        blurView.addSubview(tblCoverView)
        
        tblSuggestionList.alwaysBounceVertical = false
        tblSuggestionList.separatorStyle = .none
        tblSuggestionList.backgroundColor = .secondaryColor
        tblSuggestionList.tableFooterView = UIView()
        tblSuggestionList.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tblSuggestionList"] = tblSuggestionList
        blurView.addSubview(tblSuggestionList)

        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor , constant: 20).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-10-[titleLbl(40)]-15-[suggestiontheaderlbl(25)]-(5)-[viewSuggestionType(50)]-(15)-[suggestionLbl(25)]-(5)-[suggestiontxtView(150)]-(40)-[submitBtn(40)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[suggestiontheaderlbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[viewSuggestionType]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[suggestionLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[suggestiontxtView]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        
        viewSuggestionType.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblSuggestionType(30)]-10-|", options: [], metrics: nil, views: layoutDict))
        imgDownArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgDownArrow.centerYAnchor.constraint(equalTo: viewSuggestionType.centerYAnchor, constant: 0).isActive = true
        viewSuggestionType.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblSuggestionType]-10-[imgDownArrow(20)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        submitBtn.widthAnchor.constraint(equalToConstant: 140).isActive = true
        submitBtn.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
        blurView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurView]|", options: [], metrics: nil, views: layoutDict))
        
        
        blurView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[tblCoverView]-16-|", options: [], metrics: nil, views: layoutDict))
        tblCoverView.topAnchor.constraint(equalTo: viewSuggestionType.bottomAnchor, constant: 0).isActive = true
        tblCoverView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: 0).isActive = true
        
        blurView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[tblSuggestionList]-16-|", options: [], metrics: nil, views: layoutDict))
        tblSuggestionList.topAnchor.constraint(equalTo: viewSuggestionType.bottomAnchor, constant: 0).isActive = true
        
        baseView.layoutIfNeeded()
        baseView.setNeedsLayout()

    }
    
}
