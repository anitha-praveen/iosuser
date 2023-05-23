//
//  ChooseDestinationView.swift
//  Taxiappz
//
//  Created by Apple on 09/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps

class ChooseDestinationView: UIView {
    
    let topView = UIView()
    let btnBack = UIButton()
    
    let titleView = UIView()
    let lblTitle = UILabel()
    
    let viewMyself = UIView()
    let lblMyself = UILabel()
    let arrowMyself = UIImageView()
    
    let stackvw = UIStackView()
    let viewPickup = UIView()
    let pickupColor = UIView()
    let pickupTxt = UITextField()
    
    let viewDrop = UIView()
    let dropColor = UIView()
    let dropTxt = UITextField()
    let btnRemoveDrop = UIButton()
    let btnAddStop = UIButton()
    
    let viewSwap = UIView()
   
    let viewStop = UIView()
    let stopColor = UIView()
    let stopTxt = UITextField()
    let btnRemoveStop = UIButton()
    
    let mapview = GMSMapView()
    let markerImg = UIImageView()
    
    let btnConfirmLocation = UIButton()
    
    let btnCurrentLocation = UIButton()
    
    let tblview = UITableView()
    
    var layoutDict = [String: AnyObject]()
    
    var  tblHeight: NSLayoutConstraint?
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
        

        layoutDict["topView"] = topView
        topView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(topView)
        
        btnBack.setAppImage("backDark")
        btnBack.layer.cornerRadius = 20
        btnBack.addShadow()
        btnBack.backgroundColor = .secondaryColor
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(btnBack)
        
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 10
        titleView.addShadow()
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(titleView)
        
        lblTitle.text = "txt_destination".localize()
        lblTitle.textColor = .txtColor
        lblTitle.textAlignment = APIHelper.appTextAlignment
        lblTitle.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(lblTitle)
        
        //viewMyself.isHidden = true
        viewMyself.layer.cornerRadius = 5
        viewMyself.backgroundColor = .hexToColor("f3f3f3")
        layoutDict["viewMyself"] = viewMyself
        viewMyself.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(viewMyself)
        
        lblMyself.textAlignment = APIHelper.appTextAlignment
        lblMyself.textColor = .txtColor
        lblMyself.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblMyself"] = lblMyself
        lblMyself.translatesAutoresizingMaskIntoConstraints = false
        viewMyself.addSubview(lblMyself)
        
        arrowMyself.image = UIImage(named: "downArrowLight")
        arrowMyself.contentMode = .scaleAspectFit
        layoutDict["arrowMyself"] = arrowMyself
        arrowMyself.translatesAutoresizingMaskIntoConstraints = false
        viewMyself.addSubview(arrowMyself)
        
        let addressView = UIView()
        addressView.layer.cornerRadius = 5
        addressView.addShadow()
        addressView.backgroundColor = .secondaryColor
        layoutDict["addressView"] = addressView
        addressView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(addressView)
      
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        layoutDict["stackvw"] = stackvw
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        addressView.addSubview(stackvw)
        
        
        layoutDict["viewPickup"] = viewPickup
        viewPickup.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewPickup)
        
        pickupColor.layer.cornerRadius = 5
        pickupColor.backgroundColor = .themeColor
        layoutDict["pickupColor"] = pickupColor
        pickupColor.translatesAutoresizingMaskIntoConstraints = false
        viewPickup.addSubview(pickupColor)
        
        pickupTxt.isUserInteractionEnabled = false
        pickupTxt.textAlignment = APIHelper.appTextAlignment
        pickupTxt.textColor = .txtColor
        pickupTxt.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["pickupTxt"] = pickupTxt
        pickupTxt.translatesAutoresizingMaskIntoConstraints = false
        viewPickup.addSubview(pickupTxt)
        
        let addressSeparator = UIView()
        addressSeparator.backgroundColor = .hexToColor("DADADA")
        layoutDict["addressSeparator"] = addressSeparator
        addressSeparator.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(addressSeparator)
        
        layoutDict["viewDrop"] = viewDrop
        viewDrop.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewDrop)
        
        //dropColor.layer.cornerRadius = 5
        dropColor.backgroundColor = .red
        layoutDict["dropColor"] = dropColor
        dropColor.translatesAutoresizingMaskIntoConstraints = false
        viewDrop.addSubview(dropColor)
        
        dropTxt.tag = 101
        dropTxt.becomeFirstResponder()
        dropTxt.placeholder = "txt_EnterDrop".localize()
        dropTxt.clearButtonMode = .always
        dropTxt.textAlignment = APIHelper.appTextAlignment
        dropTxt.textColor = .txtColor
        dropTxt.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["dropTxt"] = dropTxt
        dropTxt.translatesAutoresizingMaskIntoConstraints = false
        viewDrop.addSubview(dropTxt)
        
        let dropSeparator = UIView()
        dropSeparator.backgroundColor = .hexToColor("DADADA")
        layoutDict["dropSeparator"] = dropSeparator
        dropSeparator.translatesAutoresizingMaskIntoConstraints = false
        viewDrop.addSubview(dropSeparator)
        
        btnRemoveDrop.setImage(UIImage(named: "ic_swap"), for: .normal)
        layoutDict["btnRemoveDrop"] = btnRemoveDrop
        btnRemoveDrop.translatesAutoresizingMaskIntoConstraints = false
        viewDrop.addSubview(btnRemoveDrop)
        
        btnAddStop.setImage(UIImage(named: "redPlus"), for: .normal)
        layoutDict["btnAddStop"] = btnAddStop
        btnAddStop.translatesAutoresizingMaskIntoConstraints = false
        viewDrop.addSubview(btnAddStop)
        
        layoutDict["viewStop"] = viewStop
        viewStop.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewStop)
        
       // stopColor.layer.cornerRadius = 5
        stopColor.backgroundColor = .red
        layoutDict["stopColor"] = stopColor
        stopColor.translatesAutoresizingMaskIntoConstraints = false
        viewStop.addSubview(stopColor)
        
        stopTxt.tag = 102
        stopTxt.placeholder = "txt_add_your_stop".localize()
        stopTxt.clearButtonMode = .always
        stopTxt.textAlignment = APIHelper.appTextAlignment
        stopTxt.textColor = .txtColor
        stopTxt.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["stopTxt"] = stopTxt
        stopTxt.translatesAutoresizingMaskIntoConstraints = false
        viewStop.addSubview(stopTxt)
        
        btnRemoveStop.setImage(UIImage(named: "ic_close"), for: .normal)
        layoutDict["btnRemoveStop"] = btnRemoveStop
        btnRemoveStop.translatesAutoresizingMaskIntoConstraints = false
        viewStop.addSubview(btnRemoveStop)
        
        

        markerImg.image = UIImage(named:"ic_destination_pin")
        layoutDict["markerImg"] = markerImg
        markerImg.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(markerImg)
        
      
     
        
        btnConfirmLocation.setTitle("txt_set_des".localize(), for: .normal)
        btnConfirmLocation.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnConfirmLocation.setTitleColor(.themeTxtColor, for: .normal)
        btnConfirmLocation.layer.cornerRadius = 5
        btnConfirmLocation.backgroundColor = .themeColor
        layoutDict["btnConfirmLocation"] = btnConfirmLocation
        btnConfirmLocation.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnConfirmLocation)
        
        btnCurrentLocation.setImage(UIImage(named: "ic_navigation"), for: .normal)
        layoutDict["btnCurrentLocation"] = btnCurrentLocation
        btnCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnCurrentLocation)
        
        tblview.isHidden = true
        tblview.layer.cornerRadius = 5
        tblview.backgroundColor = .secondaryColor
        tblview.addShadow()
        tblview.alwaysBounceVertical = false
        layoutDict["tblview"] = tblview
        tblview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblview)
        
        
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        topView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[topView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        topView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[btnBack(40)]-8-[titleView]-8-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        topView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[btnBack(40)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblTitle]-8-[viewMyself]-5-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblTitle]-5-|", options: [], metrics: nil, views: layoutDict))
        
        viewMyself.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblMyself]-8-[arrowMyself(15)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewMyself.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblMyself]|", options: [], metrics: nil, views: layoutDict))
        arrowMyself.heightAnchor.constraint(equalToConstant: 15).isActive = true
        arrowMyself.centerYAnchor.constraint(equalTo: lblMyself.centerYAnchor, constant: 0).isActive = true
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topView]-5-[addressView]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[addressView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        addressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stackvw]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        addressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackvw]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        

        viewPickup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[pickupColor(10)]-10-[pickupTxt]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewPickup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[pickupTxt(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pickupColor.centerYAnchor.constraint(equalTo: pickupTxt.centerYAnchor, constant: 0).isActive = true
        
        
        addressSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        viewDrop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[dropColor(10)]-10-[dropTxt]-2-[dropSeparator(1)]-5-[btnRemoveDrop(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDrop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[dropTxt(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropSeparator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dropSeparator.centerYAnchor.constraint(equalTo: dropTxt.centerYAnchor, constant: 0).isActive = true
        dropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropColor.centerYAnchor.constraint(equalTo: dropTxt.centerYAnchor, constant: 0).isActive = true
        btnRemoveDrop.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnRemoveDrop.centerYAnchor.constraint(equalTo: dropTxt.centerYAnchor, constant: 0).isActive = true
        
        btnAddStop.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnAddStop.centerYAnchor.constraint(equalTo: btnRemoveDrop.centerYAnchor, constant: 0).isActive = true
        btnAddStop.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnAddStop.centerXAnchor.constraint(equalTo: btnRemoveDrop.centerXAnchor, constant: 0).isActive = true
        
        
        
        viewStop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[stopColor(10)]-10-[stopTxt]-5-[btnRemoveStop(30)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewStop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stopTxt(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        stopColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stopColor.centerYAnchor.constraint(equalTo: stopTxt.centerYAnchor, constant: 0).isActive = true
        btnRemoveStop.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnRemoveStop.centerYAnchor.constraint(equalTo: stopTxt.centerYAnchor, constant: 0).isActive = true
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[tblview]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        tblview.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 5).isActive = true
        tblHeight = tblview.heightAnchor.constraint(equalToConstant: 0)
        tblHeight?.isActive = true
        
        
        markerImg.widthAnchor.constraint(equalToConstant: 26).isActive = true
        markerImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
        markerImg.centerXAnchor.constraint(equalTo: mapview.centerXAnchor, constant: 0).isActive = true
        markerImg.centerYAnchor.constraint(equalTo: mapview.centerYAnchor, constant: 0).isActive = true
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnCurrentLocation(50)]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnCurrentLocation(50)]-20-[btnConfirmLocation]", options: [], metrics: nil, views: layoutDict))
        
       
        btnConfirmLocation.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        btnConfirmLocation.heightAnchor.constraint(equalToConstant: 45).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnConfirmLocation]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        
    }
    
    
    
}


class RecentLocationsCell: UITableViewCell {

    var layoutDic = [String:AnyObject]()
    var placenameLbl = UILabel()
    var placeImv = UIImageView()
    var placeaddLbl = UILabel()
    var favBtn = UIButton()

    var favAction:(()->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpViews() {
        
        selectionStyle = .none
        contentView.isUserInteractionEnabled = true
        self.backgroundColor = .secondaryColor
    
        placeImv.contentMode = .scaleAspectFit
        placeImv.image = UIImage(named: "ic_location")
        placeImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placeImv"] = placeImv
        addSubview(placeImv)
        
        placeaddLbl.textColor = .txtColor
        placeaddLbl.textAlignment = APIHelper.appTextAlignment
        placeaddLbl.font = UIFont.appRegularFont(ofSize: 14)
        placeaddLbl.translatesAutoresizingMaskIntoConstraints = false
        placeaddLbl.numberOfLines = 0
        placeaddLbl.lineBreakMode = .byWordWrapping
        layoutDic["placeaddLbl"] = placeaddLbl
        addSubview(placeaddLbl)
        
        favBtn.isHidden = true
        favBtn.addTarget(self, action:#selector(favBtnPressed(_ :)), for: .touchUpInside)
        favBtn.setImage(UIImage(named: "ic_unfav"), for: .normal)
        favBtn.adjustsImageWhenHighlighted = false
        favBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favBtn"] = favBtn
        addSubview(favBtn)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[placeImv(22)]-(12)-[placeaddLbl]-(10)-[favBtn(20)]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
       
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[placeaddLbl(>=25)]-(5)-|", options: [], metrics: nil, views: layoutDic))
        
        placeImv.heightAnchor.constraint(equalToConstant: 22).isActive = true
        placeImv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        favBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc func favBtnPressed(_ sender: UIButton) {
        if let action = favAction{
            action()
        }
    }
    
}


class FavouriteLocationsCell: UITableViewCell {

    var layoutDic = [String:AnyObject]()
    var placenameLbl = UILabel()
    var placeImv = UIImageView()
    var placeaddLbl = UILabel()
    var favDeleteBtn = UIButton()
    
    var deleteAction:(()->())?
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
        self.backgroundColor = .secondaryColor
        
        placenameLbl.textColor = .txtColor
        placenameLbl.textAlignment = APIHelper.appTextAlignment
        placenameLbl.font = UIFont.appBoldFont(ofSize: 14)
        placenameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placenameLbl"] = placenameLbl
        addSubview(placenameLbl)
        
        placeImv.contentMode = .scaleAspectFit
        placeImv.image = UIImage(named: "ic_location")
        placeImv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["placeImv"] = placeImv
        addSubview(placeImv)
        
        placeaddLbl.textColor = .hexToColor("7E7D7D")
        placeaddLbl.textAlignment = APIHelper.appTextAlignment
        placeaddLbl.font = UIFont.appRegularFont(ofSize: 14)
        placeaddLbl.translatesAutoresizingMaskIntoConstraints = false
        placeaddLbl.numberOfLines = 0
        placeaddLbl.lineBreakMode = .byWordWrapping
        layoutDic["placeaddLbl"] = placeaddLbl
        addSubview(placeaddLbl)
        
        favDeleteBtn.isHidden = true
        favDeleteBtn.addTarget(self, action: #selector(deleteLocation(_ :)), for: .touchUpInside)
        favDeleteBtn.setImage(UIImage(named: "deletecardicon"), for: .normal)
        favDeleteBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["favDeleteBtn"] = favDeleteBtn
        addSubview(favDeleteBtn)
        

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[placeImv(22)]-(12)-[placeaddLbl]-(8)-[favDeleteBtn(30)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
       
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[placenameLbl(23)][placeaddLbl(>=25)]-(5)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        
        placeImv.heightAnchor.constraint(equalToConstant: 22).isActive = true
        placeImv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        favDeleteBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favDeleteBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     
    }
    
    @objc func deleteLocation(_ sender: UIButton) {
        if let action = self.deleteAction {
            action()
        }
    }
    
}
