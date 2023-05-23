//
//  SearchLocationView.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps

class SearchLocationView: UIView {
    
    let backBtn = UIButton()
    let titleView = UIView()
    let titleLbl = UILabel()
    
    let mapview = GMSMapView()
    let marker = UIImageView()
    
    let locationView = UIView()
    let locationColor = UIView()
    let txtLocation = UITextField()
    let btnEditLocation = UIButton()
   
    let btnConfirm = UIButton()
    
    let tblLocation = UITableView()
    var tblHeightConstraint: NSLayoutConstraint?

    var layoutDict = [String: AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            self.mapview.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        marker.image = UIImage(named: "ic_pick_pin")
        marker.contentMode = .scaleAspectFit
        layoutDict["marker"] = marker
        marker.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(marker)
        
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
        
        titleLbl.text = "txt_search_location".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        locationView.layer.cornerRadius = 8
        locationView.addShadow()
        locationView.backgroundColor = .secondaryColor
        layoutDict["locationView"] = locationView
        locationView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(locationView)
        
        locationColor.layer.cornerRadius = 5
        locationColor.backgroundColor = .themeColor
        layoutDict["locationColor"] = locationColor
        locationColor.translatesAutoresizingMaskIntoConstraints = false
        locationView.addSubview(locationColor)
        
        txtLocation.placeholder = "txt_search_location".localize()
        txtLocation.clearButtonMode = .whileEditing
        txtLocation.isUserInteractionEnabled = false
        txtLocation.textAlignment = APIHelper.appTextAlignment
        txtLocation.textColor = .txtColor
        txtLocation.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["txtLocation"] = txtLocation
        txtLocation.translatesAutoresizingMaskIntoConstraints = false
        locationView.addSubview(txtLocation)
        
        btnEditLocation.setImage(UIImage(named: "ic_note"), for: .normal)
        layoutDict["btnEditLocation"] = btnEditLocation
        btnEditLocation.translatesAutoresizingMaskIntoConstraints = false
        locationView.addSubview(btnEditLocation)
        
        
        btnConfirm.layer.cornerRadius = 8
        btnConfirm.setTitle("txt_confirm".localize(), for: .normal)
        btnConfirm.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        btnConfirm.setTitleColor(.themeTxtColor, for: .normal)
        btnConfirm.addShadow()
        btnConfirm.backgroundColor = .themeColor
        layoutDict["btnConfirm"] = btnConfirm
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnConfirm)
        
        tblLocation.isHidden = true
        tblLocation.alwaysBounceVertical = false
        tblLocation.backgroundColor = .secondaryColor
        layoutDict["tblLocation"] = tblLocation
        tblLocation.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblLocation)
      
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        marker.widthAnchor.constraint(equalToConstant: 26).isActive = true
        marker.heightAnchor.constraint(equalToConstant: 30).isActive = true
        marker.centerXAnchor.constraint(equalTo: mapview.centerXAnchor, constant: 0).isActive = true
        marker.centerYAnchor.constraint(equalTo: mapview.centerYAnchor, constant: 0).isActive = true
        
        
        locationView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[locationView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        locationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[locationColor(10)]-8-[txtLocation]-8-[btnEditLocation(25)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        locationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[txtLocation(30)]-5-|", options: [], metrics: nil, views: layoutDict))
        locationColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        locationColor.centerYAnchor.constraint(equalTo: txtLocation.centerYAnchor, constant: 0).isActive = true
        btnEditLocation.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btnEditLocation.centerYAnchor.constraint(equalTo: txtLocation.centerYAnchor, constant: 0).isActive = true
       

        btnConfirm.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant: 40).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[btnConfirm]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // ------------Location Table
        
        tblLocation.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 8).isActive = true
        self.tblHeightConstraint = tblLocation.heightAnchor.constraint(equalToConstant: 0)
        self.tblHeightConstraint?.isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[tblLocation]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }
}

class SearchListTableViewCell: UITableViewCell {

    var layoutDic = [String:AnyObject]()
    var placenameLbl = UILabel()
    var placeImv = UIImageView()
    var placeaddLbl = UILabel()
   

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpViews() { // adding ui elements to superview
        
        selectionStyle = .none
        contentView.isUserInteractionEnabled = true
        
        placeImv.contentMode = .scaleAspectFit
        placeImv.image = UIImage(named: "ic_location")
        placeImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placeImv"] = placeImv
        addSubview(placeImv)
        
        placenameLbl.textColor = .txtColor
        placenameLbl.textAlignment = APIHelper.appTextAlignment
        placenameLbl.font = UIFont.appFont(ofSize: 16)
        placenameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placenameLbl"] = placenameLbl
        addSubview(placenameLbl)
        
        placeaddLbl.textColor = .hexToColor("7E7D7D")
        placeaddLbl.textAlignment = APIHelper.appTextAlignment
        placeaddLbl.font = UIFont.appFont(ofSize: 14)
        placeaddLbl.translatesAutoresizingMaskIntoConstraints = false
        placeaddLbl.numberOfLines = 0
        placeaddLbl.lineBreakMode = .byWordWrapping
        layoutDic["placeaddLbl"] = placeaddLbl
        addSubview(placeaddLbl)
        
       

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(12)-[placeImv(25)]-(15)-[placenameLbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[placenameLbl(21)]-(3)-[placeaddLbl(>=25)]-(5)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        
        placeImv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        placeImv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
       
    }
    
}
