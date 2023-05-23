//
//  SelectCountryView.swift
//  Taxiappz
//
//  Created by Apple on 26/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit

class SelectCountryView: UIView {

    let btnBack = UIButton()
    let lblTitle = UILabel()
    let txtSearch = UITextField()
    let tblCountry = UITableView()
    let countrySearchBar = UISearchBar()
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .secondaryColor
        
        btnBack.setImage(UIImage(named: "ic_back"), for: .normal)
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        lblTitle.text = "txt_select_country".localize()
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appSemiBold(ofSize: 40)
        lblTitle.adjustsFontSizeToFitWidth = true
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblTitle)
        
        txtSearch.clearButtonMode = .always
        txtSearch.addIcon(UIImage(named: "txtSearch"))
        txtSearch.font = UIFont.appRegularFont(ofSize: 15)
        txtSearch.layer.cornerRadius = 10
        txtSearch.backgroundColor = .hexToColor("EDF1F7")
        txtSearch.placeholder = "text_Search_here".localize()
        layoutDict["txtSearch"] = txtSearch
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(txtSearch)
        
        tblCountry.separatorStyle = .none
        layoutDict["tblCountry"] = tblCountry
        tblCountry.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblCountry)
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        tblCountry.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnBack(30)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(30)]-20-[lblTitle(45)]-20-[txtSearch(40)]-20-[tblCountry]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTitle]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[tblCountry]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
         baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[txtSearch]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
       

        layoutIfNeeded()
        setNeedsLayout()
    }
    
}

class CountryPickerCell: UITableViewCell {
    let flagImgView = UIImageView()
    let countryNameLbl = UILabel()
    let isoCodeLbl = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        self.selectionStyle = .none

        flagImgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flagImgView)
        countryNameLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countryNameLbl)
        isoCodeLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(isoCodeLbl)

       // flagImgView.isHidden = true
        flagImgView.contentMode = .scaleAspectFit
        countryNameLbl.numberOfLines = 0
        countryNameLbl.lineBreakMode = .byWordWrapping
        isoCodeLbl.textColor = .gray
        isoCodeLbl.textAlignment = .right

        isoCodeLbl.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        countryNameLbl.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[flagImgView(30)]-(>=8)-|", options: [], metrics: nil, views: ["flagImgView": flagImgView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[countryNameLbl(>=30)]-(8)-|", options: [], metrics: nil, views: ["countryNameLbl": countryNameLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[isoCodeLbl(30)]-(>=8)-|", options: [], metrics: nil, views: ["isoCodeLbl": isoCodeLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[flagImgView(30)]-(5)-[countryNameLbl]-(5)-[isoCodeLbl]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: ["flagImgView": flagImgView,"countryNameLbl": countryNameLbl,"isoCodeLbl": isoCodeLbl]))
        //
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

