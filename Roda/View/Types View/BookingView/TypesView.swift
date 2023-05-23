//
//  TypesView.swift
//  Taxiappz
//
//  Created by Apple on 02/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps

class TypesView: UIView {
    
    let mapview = GMSMapView()
    let viewBottom = UIView()
    let dragView = UIView()
    let viewTypesTable = UIView()
    let lblSuggestedRyde = UILabel()
   
    let tblTypes = UITableView()
    let lineView = UIView()
    let btnBookNow = UIButton()
    
    let stackPayView = UIStackView()
    let viewPay = UIView()
    let imgPay = UIImageView()
    let lblPayment = UILabel()
    let imgrightArrow = UIImageView()
    let viewPromo = UIView()
    let lblPromo = UILabel()
    let verticalLine1 = UIView()
    let btnCalender = UIButton()
   
    
    let btnBack = UIButton()
    
    let viewAddress = UIView()
    let lblPickup = UILabel()
    let lblDrop = UILabel()
    let separator = UIView()
    let viewPickupColor = UIView()
    let viewDropColor = UIView()
    let viewDot = UIView()
    
    let errorView = UIView()
    let imgError = UIImageView()
    let lblErrorMsg = UILabel()
    
    var containerHeightConstraint: NSLayoutConstraint?
    var containerDefaultHeight: CGFloat = 261
    var containerMaximumHeight: CGFloat = UIScreen.main.bounds.height - 14
    var containerCurrentHeight: CGFloat = 261
    
    let viewAnim = UIView()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .secondaryColor
        
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            self.mapview.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        } else {
            print("Unable to find mapStyle.json")
        }
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        btnBack.setAppImage("BackImage")
        btnBack.backgroundColor = .secondaryColor
        btnBack.addShadow()
        btnBack.layer.cornerRadius = 15.0
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        
        viewAddress.isHidden = true
        viewAddress.layer.cornerRadius = 20
        viewAddress.backgroundColor = .secondaryColor
        viewAddress.addShadow()
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewAddress)
        
        lblPickup.textColor = .txtColor
        lblPickup.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblPickup"] = lblPickup
        lblPickup.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(lblPickup)
        
        lblDrop.textColor = .txtColor
        lblDrop.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblDrop"] = lblDrop
        lblDrop.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(lblDrop)
        
        separator.backgroundColor = .hexToColor("E4E9F2")
        layoutDict["separator"] = separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(separator)
        
        viewPickupColor.layer.cornerRadius = 5
        viewPickupColor.backgroundColor = .txtColor
        layoutDict["viewPickupColor"] = viewPickupColor
        viewPickupColor.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(viewPickupColor)
        
        
        layoutDict["viewDot"] = viewDot
        viewDot.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(viewDot)
        
        viewDropColor.backgroundColor = .red
        layoutDict["viewDropColor"] = viewDropColor
        viewDropColor.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(viewDropColor)
        
        viewBottom.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewBottom.layer.cornerRadius = 20
       // viewBottom.addShadow()
        viewBottom.backgroundColor = .secondaryColor
        layoutDict["viewBottom"] = viewBottom
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewBottom)
        
        dragView.backgroundColor = .hexToColor("E4E9F2")
        layoutDict["dragView"] = dragView
        dragView.translatesAutoresizingMaskIntoConstraints = false
        viewBottom.addSubview(dragView)
        
        
        viewTypesTable.backgroundColor = .secondaryColor
        layoutDict["viewTypesTable"] = viewTypesTable
        viewTypesTable.translatesAutoresizingMaskIntoConstraints = false
        viewBottom.addSubview(viewTypesTable)
        
        lineView.backgroundColor = .hexToColor("E4E9F2")
        layoutDict["lineView"] = lineView
        lineView.translatesAutoresizingMaskIntoConstraints = false
        viewBottom.addSubview(lineView)
        
        lblSuggestedRyde.text = "txt_suggested_rides".localize().uppercased()
        lblSuggestedRyde.textAlignment = APIHelper.appTextAlignment
        lblSuggestedRyde.textColor = .txtColor
        lblSuggestedRyde.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["lblSuggestedRyde"] = lblSuggestedRyde
        lblSuggestedRyde.translatesAutoresizingMaskIntoConstraints = false
        viewTypesTable.addSubview(lblSuggestedRyde)
        

        
        tblTypes.alwaysBounceVertical = false
        tblTypes.showsVerticalScrollIndicator = false
        tblTypes.separatorStyle = .none
        layoutDict["tblTypes"] = tblTypes
        tblTypes.translatesAutoresizingMaskIntoConstraints = false
        viewTypesTable.addSubview(tblTypes)
        
        stackPayView.axis = .horizontal
        stackPayView.distribution = .fillEqually
        layoutDict["stackPayView"] = stackPayView
        stackPayView.translatesAutoresizingMaskIntoConstraints = false
        viewBottom.addSubview(stackPayView)
        
        layoutDict["viewPay"] = viewPay
        viewPay.translatesAutoresizingMaskIntoConstraints = false
        stackPayView.addArrangedSubview(viewPay)
        
        imgPay.image = UIImage(named: "ic_dollar")
        layoutDict["imgPay"] = imgPay
        imgPay.translatesAutoresizingMaskIntoConstraints = false
        viewPay.addSubview(imgPay)
        
        lblPayment.textColor = .txtColor
        lblPayment.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["lblPayment"] = lblPayment
        lblPayment.translatesAutoresizingMaskIntoConstraints = false
        viewPay.addSubview(lblPayment)
        
        imgrightArrow.image = UIImage(named: "rightSideArrow")
        layoutDict["imgrightArrow"] = imgrightArrow
        imgrightArrow.translatesAutoresizingMaskIntoConstraints = false
        viewPay.addSubview(imgrightArrow)
        
        layoutDict["viewPromo"] = viewPromo
        viewPromo.translatesAutoresizingMaskIntoConstraints = false
        stackPayView.addArrangedSubview(viewPromo)
        
        btnCalender.setImage(UIImage(named: "ic_calender"), for: .normal)
        layoutDict["btnCalender"] = btnCalender
        btnCalender.translatesAutoresizingMaskIntoConstraints = false
        viewPromo.addSubview(btnCalender)
        
        lblPromo.text = "Txt_title_Promocode".localize()
        lblPromo.isUserInteractionEnabled = true
        lblPromo.textColor = .txtColor
        lblPromo.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["lblPromo"] = lblPromo
        lblPromo.translatesAutoresizingMaskIntoConstraints = false
        viewPromo.addSubview(lblPromo)
        
      
        
        verticalLine1.backgroundColor = .hexToColor("E4E9F2")
        layoutDict["verticalLine1"] = verticalLine1
        verticalLine1.translatesAutoresizingMaskIntoConstraints = false
        viewPromo.addSubview(verticalLine1)
        
     
        
        btnBookNow.setTitle("txt_book_now".localize(), for: .normal)
        btnBookNow.layer.cornerRadius = 5
        btnBookNow.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnBookNow.setTitleColor(.themeTxtColor, for: .normal)
        btnBookNow.backgroundColor = .themeColor
        layoutDict["btnBookNow"] = btnBookNow
        btnBookNow.translatesAutoresizingMaskIntoConstraints = false
        viewBottom.addSubview(btnBookNow)
        
        // --------------Error View
        
        errorView.isHidden = true
        errorView.backgroundColor = .secondaryColor
        layoutDict["errorView"] = errorView
        errorView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(errorView)
        
        imgError.contentMode = .scaleAspectFit
        imgError.image = UIImage(named: "Lock")
        layoutDict["imgError"] = imgError
        imgError.translatesAutoresizingMaskIntoConstraints = false
        errorView.addSubview(imgError)
        
        lblErrorMsg.text = "txt_no_service_available".localize()
        lblErrorMsg.textAlignment = .center
        lblErrorMsg.textColor = .txtColor
        lblErrorMsg.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblErrorMsg"] = lblErrorMsg
        lblErrorMsg.translatesAutoresizingMaskIntoConstraints = false
        errorView.addSubview(lblErrorMsg)
        
        //-----------------
        
        viewAnim.isHidden = true
        viewAnim.alpha = 0
        viewAnim.backgroundColor = .secondaryColor
        layoutDict["viewAnim"] = viewAnim
        viewAnim.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewAnim)
        
        let lblAnimTitle = UILabel()
        lblAnimTitle.text = "txt_suggested_rides".localize().uppercased()
        lblAnimTitle.textColor = .txtColor
        lblAnimTitle.textAlignment = .center
        lblAnimTitle.font = UIFont.appSemiBold(ofSize: 16)
        layoutDict["lblAnimTitle"] = lblAnimTitle
        lblAnimTitle.translatesAutoresizingMaskIntoConstraints = false
        viewAnim.addSubview(lblAnimTitle)
        
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
     
        mapview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -containerDefaultHeight).isActive = true
        
        viewBottom.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(30)]-12-[viewAddress]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewAddress]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnBack(30)]", options: [], metrics: nil, views: layoutDict))
        
         
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewBottom]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.containerHeightConstraint = viewBottom.heightAnchor.constraint(equalToConstant: self.containerDefaultHeight)
        self.containerHeightConstraint?.isActive = true
        
        
        viewBottom.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewTypesTable]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewBottom.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnBookNow]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewBottom.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackPayView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewBottom.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lineView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        dragView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        dragView.centerXAnchor.constraint(equalTo: viewBottom.centerXAnchor, constant: 0).isActive = true
        
        viewBottom.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[dragView(4)]-8-[viewTypesTable]-5-[lineView(1)]-10-[stackPayView]-18-[btnBookNow(48)]-10-|", options: [], metrics: nil, views: layoutDict))
        //112+30+44
        // -------------------ViewPay
        
        viewPay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgPay(16)]-5-[lblPayment]-5-[imgrightArrow(8)]", options: [], metrics: nil, views: layoutDict))
        viewPay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblPayment(22)]|", options: [], metrics: nil, views: layoutDict))
        imgPay.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imgPay.centerYAnchor.constraint(equalTo: lblPayment.centerYAnchor, constant: 0).isActive = true
        imgrightArrow.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imgrightArrow.centerYAnchor.constraint(equalTo: lblPayment.centerYAnchor, constant: 0).isActive = true
        
        // -------------------Types table
        
        viewTypesTable.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblSuggestedRyde(30)][tblTypes]|", options: [], metrics: nil, views: layoutDict))
        
        viewTypesTable.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblSuggestedRyde]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))

        
        viewTypesTable.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblTypes]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // ---------------------viewPromo
        
        viewPromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[lblPromo]-8-[verticalLine1(1)]-8-[btnCalender(22)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewPromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblPromo(22)]|", options: [], metrics: nil, views: layoutDict))
        viewPromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[verticalLine1(22)]|", options: [], metrics: nil, views: layoutDict))
        
        btnCalender.heightAnchor.constraint(equalToConstant: 22).isActive = true
        btnCalender.centerYAnchor.constraint(equalTo: lblPromo.centerYAnchor, constant: 0).isActive = true
        
        
        // -------------------viewAddress
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblPickup(30)]-8-[separator(1)]-8-[lblDrop(30)]-8-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewPickupColor(10)]-16-[lblPickup]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewDropColor(10)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewPickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewPickupColor.centerYAnchor.constraint(equalTo: lblPickup.centerYAnchor, constant: 0).isActive = true
        
        viewDropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewDropColor.centerYAnchor.constraint(equalTo: lblDrop.centerYAnchor, constant: 0).isActive = true
        
        viewDot.topAnchor.constraint(equalTo: viewPickupColor.bottomAnchor, constant: 0).isActive = true
        viewDot.bottomAnchor.constraint(equalTo: viewDropColor.topAnchor, constant: 0).isActive = true
        viewDot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        viewDot.centerXAnchor.constraint(equalTo: viewDropColor.centerXAnchor, constant: 0).isActive = true
        
        // -------------Error View
        
        errorView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: containerDefaultHeight).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[errorView]|", options: APIHelper.appLanguageDirection, metrics: nil, views: layoutDict))
        
        imgError.bottomAnchor.constraint(equalTo: errorView.centerYAnchor, constant: 0).isActive = true
        errorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgError(100)]-15-[lblErrorMsg]-20-|", options: APIHelper.appLanguageDirection, metrics: nil, views: layoutDict))
        imgError.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgError.centerXAnchor.constraint(equalTo: errorView.centerXAnchor, constant: 0).isActive = true
        
        errorView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblErrorMsg]-32-|", options: APIHelper.appLanguageDirection, metrics: nil, views: layoutDict))
       
        // ------------------
        
        viewAnim.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        viewAnim.heightAnchor.constraint(equalToConstant: 44).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewAnim]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewAnim.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblAnimTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAnim.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblAnimTitle]|", options: [], metrics: nil, views: layoutDict))
        
    }
    

}

class TypesCell: UITableViewCell {
    
    let viewContent = UIView()
    let lblTypeName = UILabel()
    let imgview = UIImageView()
    let lblEta = UILabel()
    let lblMin = UILabel()
    let lblAmount = UILabel()
    let lblPromoAmount = UILabel()
    let btnFareDetails  = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        self.selectionStyle = .none
        
        viewContent.layer.borderWidth = 1
        viewContent.layer.cornerRadius = 5
        viewContent.backgroundColor = .hexToColor("FFF7F7")
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        lblTypeName.textColor = .txtColor
        lblTypeName.font = UIFont.appSemiBold(ofSize: 17)
        layoutDict["lblTypeName"] = lblTypeName
        lblTypeName.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTypeName)
        
        btnFareDetails.setImage(UIImage(named: "paymentexc"), for: .normal)
        btnFareDetails.imageView?.contentMode = .scaleAspectFit
        layoutDict["btnFareDetails"] = btnFareDetails
        btnFareDetails.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnFareDetails)
        
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgview)
        
        lblAmount.font = UIFont.appSemiBold(ofSize: 15)
        lblAmount.textColor = .themeColor
        layoutDict["lblAmount"] = lblAmount
        lblAmount.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblAmount)
        
        lblPromoAmount.font = UIFont.appSemiBold(ofSize: 15)
        lblPromoAmount.textColor = .themeColor
        layoutDict["lblPromoAmount"] = lblPromoAmount
        lblPromoAmount.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblPromoAmount)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[viewContent]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[viewContent]-5-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgview(50)]", options: [], metrics: nil, views: layoutDict))
        imgview.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[lblAmount]-5-[lblPromoAmount][imgview(50)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        lblAmount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[lblTypeName]-8-[btnFareDetails(15)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
       
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblTypeName(25)][lblAmount(25)]-7-|", options: [], metrics: nil, views: layoutDict))
        
        lblPromoAmount.heightAnchor.constraint(equalToConstant: 25).isActive = true
        lblPromoAmount.centerYAnchor.constraint(equalTo: lblAmount.centerYAnchor, constant: 0).isActive = true
        
        btnFareDetails.heightAnchor.constraint(equalToConstant: 15).isActive = true
        btnFareDetails.centerYAnchor.constraint(equalTo: lblTypeName.centerYAnchor, constant: 0).isActive = true
        
    }
}



