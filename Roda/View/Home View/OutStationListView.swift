//
//  OutStationListView.swift
//  Roda
//
//  Created by Apple on 20/04/22.
//

import UIKit
import GoogleMaps

class OutStationListView: UIView {
    
    let mapview = GMSMapView()
    let markerView = UIImageView()
    
    let btnBack = UIButton()
    
    let titleView = UIView()
    let txtTitle = UITextField()
    
    let locationView = UIView()
    let locationColor = UIView()
    let txtLocation = UITextField()
    let btnEditLocation = UIButton()
    
    let stackView = UIStackView()
    let viewContent = UIView()

    let viewRideType = UIView()
    let btnOneWayRide = UIButton()
    let btnReturnRide = UIButton()
    
    let stackDate = UIStackView()
    let viewTripDate = UIView()
    let lblFromDate = UILabel()
    let lblReturnDate = UILabel()
    
    let viewAddress = UIView()
    let pickupColor = UIView()
    let pickupTxt = UILabel()
    let dropColor = UIView()
    let dropTxt = UILabel()
    let btnDropDown = UIButton()
    
    let collectionvw = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let viewDistanceDetails = UIView()
    let lblDistance = UILabel()
    let lblTollHint = UILabel()
    let separator = UIView()
    
    let stackPromo = UIStackView()
    let promoHint = UILabel()
    
    let viewFare = UIView()
    let lblFareTitle = UILabel()
    let btnFareDetail = UIButton()
    let lblAmount = UILabel()
    let lblPromoAmount = UILabel()
    
    let lblNote = UILabel()
    
    let payPromoStackView = UIStackView()
    let btnPaymentMode = UIButton()
    let btnApplyPromo = UIButton()
    
    let viewBookRide = UIView()
    let lblBookRide = UILabel()
    let viewDate = UIView()
    let imgCalender = UIImageView()
    let lblDate = UILabel()
    
    let listView = UIView()
    let tblOutstationList = UITableView()

    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        mapview.isUserInteractionEnabled = false
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        markerView.image = UIImage(named: "ic_pick_pin")
        layoutDict["markerView"] = markerView
        markerView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(markerView)
        
        btnBack.setAppImage("backDark")
        btnBack.layer.cornerRadius = 20
        btnBack.addShadow()
        btnBack.backgroundColor = .secondaryColor
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        txtTitle.isUserInteractionEnabled = false
        txtTitle.text = "txt_outstation".localize()
        txtTitle.placeholder = "text_Search_here".localize()
        txtTitle.textColor = .txtColor
        txtTitle.textAlignment = APIHelper.appTextAlignment
        txtTitle.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["txtTitle"] = txtTitle
        txtTitle.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(txtTitle)
        
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
        

        
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.addShadow()
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
      
        viewAddress.layer.cornerRadius = 8
        viewAddress.backgroundColor = .hexToColor("F4F4F4")
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewAddress)
        
        pickupTxt.text = "current_place_name".localize()
        pickupTxt.addBorder(edges: .bottom,colour: .hexToColor("DDDDDD"),thickness: 0.5)
        pickupTxt.textColor = .hexToColor("797878")
        pickupTxt.textAlignment = APIHelper.appTextAlignment
        pickupTxt.font = UIFont.appSemiBold(ofSize: 16)
        layoutDict["pickupTxt"] = pickupTxt
        pickupTxt.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(pickupTxt)
        
        pickupColor.layer.cornerRadius = 5
        pickupColor.backgroundColor = .themeColor
        layoutDict["pickupColor"] = pickupColor
        pickupColor.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(pickupColor)
        
        dropTxt.isUserInteractionEnabled = true
        dropTxt.text = "text_drop_loc".localize()
        dropTxt.textColor = .txtColor
        dropTxt.textAlignment = APIHelper.appTextAlignment
        dropTxt.font = UIFont.appRegularFont(ofSize: 17)//appSemiBold(ofSize: 16) change
        layoutDict["dropTxt"] = dropTxt
        dropTxt.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(dropTxt)
        
        
        dropColor.backgroundColor = .red
        layoutDict["dropColor"] = dropColor
        dropColor.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(dropColor)
        
        btnDropDown.setImage(UIImage(named: "downArrowLight"), for: .normal)
        layoutDict["btnDropDown"] = btnDropDown
        btnDropDown.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(btnDropDown)
        
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        layoutDict["stackView"] = stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackView)
        
        
       // viewRideType.isHidden = true
        layoutDict["viewRideType"] = viewRideType
        viewRideType.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewRideType)
        
        
        btnOneWayRide.contentHorizontalAlignment = .left
        btnOneWayRide.isSelected = true
        btnOneWayRide.layer.cornerRadius = 20
        btnOneWayRide.layer.maskedCorners = [.layerMinXMinYCorner]
        btnOneWayRide.setTitle("txt_one_way".localize(), for: .normal)
        btnOneWayRide.setImage(UIImage(named: "ic_tick"), for: .selected)
        btnOneWayRide.setImage(UIImage(named: "ic_tick_unselect"), for: .normal)
        btnOneWayRide.setTitleColor(.themeTxtColor, for: .selected)
        btnOneWayRide.setTitleColor(.hexToColor("606060"), for: .normal)
        btnOneWayRide.titleLabel?.font = UIFont.appRegularFont(ofSize: 14)
        btnOneWayRide.backgroundColor = .themeColor
        layoutDict["btnOneWayRide"] = btnOneWayRide
        btnOneWayRide.translatesAutoresizingMaskIntoConstraints = false
        viewRideType.addSubview(btnOneWayRide)
        
        btnOneWayRide.imageView?.translatesAutoresizingMaskIntoConstraints = false
        btnOneWayRide.imageView?.trailingAnchor.constraint(equalTo: btnOneWayRide.trailingAnchor, constant: -10).isActive = true
        btnOneWayRide.imageView?.centerYAnchor.constraint(equalTo: btnOneWayRide.centerYAnchor, constant: 0).isActive = true
        
        btnReturnRide.contentHorizontalAlignment = .left
        btnReturnRide.isSelected = false
        btnReturnRide.layer.cornerRadius = 20
        btnReturnRide.layer.maskedCorners = [.layerMaxXMinYCorner]
        btnReturnRide.setTitle("txt_round_trip".localize(), for: .normal)
        btnReturnRide.setImage(UIImage(named: "ic_tick"), for: .selected)
        btnReturnRide.setImage(UIImage(named: "ic_tick_unselect"), for: .normal)
        btnReturnRide.setTitleColor(.txtColor, for: .selected)
        btnReturnRide.setTitleColor(.hexToColor("606060"), for: .normal)
        btnReturnRide.titleLabel?.font = UIFont.appRegularFont(ofSize: 14)
        btnReturnRide.backgroundColor = .hexToColor("F4F4F4")
        layoutDict["btnReturnRide"] = btnReturnRide
        btnReturnRide.translatesAutoresizingMaskIntoConstraints = false
        viewRideType.addSubview(btnReturnRide)
        
        btnReturnRide.imageView?.translatesAutoresizingMaskIntoConstraints = false
        btnReturnRide.imageView?.trailingAnchor.constraint(equalTo: btnReturnRide.trailingAnchor, constant: -10).isActive = true
        btnReturnRide.imageView?.centerYAnchor.constraint(equalTo: btnReturnRide.centerYAnchor, constant: 0).isActive = true
        
        
        stackDate.axis = .vertical
        stackDate.distribution = .fill
        layoutDict["stackDate"] = stackDate
        stackDate.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackDate)
        
        viewTripDate.isHidden = true
        layoutDict["viewTripDate"] = viewTripDate
        viewTripDate.translatesAutoresizingMaskIntoConstraints = false
        stackDate.addArrangedSubview(viewTripDate)
        
        let lblBookingFrom = UILabel()
        lblBookingFrom.text = "Book from"
        lblBookingFrom.textAlignment = APIHelper.appTextAlignment
        lblBookingFrom.textColor = .txtColor
        lblBookingFrom.font = UIFont.appSemiBold(ofSize: 14)
        layoutDict["lblBookingFrom"] = lblBookingFrom
        lblBookingFrom.translatesAutoresizingMaskIntoConstraints = false
        viewTripDate.addSubview(lblBookingFrom)

        
        lblFromDate.isUserInteractionEnabled = true
        lblFromDate.textAlignment = APIHelper.appTextAlignment
        lblFromDate.textColor = .blue
        lblFromDate.font = UIFont.appSemiBold(ofSize: 14)
        layoutDict["lblFromDate"] = lblFromDate
        lblFromDate.translatesAutoresizingMaskIntoConstraints = false
        viewTripDate.addSubview(lblFromDate)
        
        
        lblReturnDate.isUserInteractionEnabled = true
        lblReturnDate.textAlignment = APIHelper.appTextAlignment
        lblReturnDate.textColor = .blue
        lblReturnDate.font = UIFont.appSemiBold(ofSize: 14)
        layoutDict["lblReturnDate"] = lblReturnDate
        lblReturnDate.translatesAutoresizingMaskIntoConstraints = false
        viewTripDate.addSubview(lblReturnDate)
        
        collectionvw.isHidden = true
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumInteritemSpacing = 0
        collectionvw.collectionViewLayout = collectionLayout
        collectionvw.alwaysBounceHorizontal = false
        collectionvw.backgroundColor = .secondaryColor
        collectionvw.showsHorizontalScrollIndicator = false
        layoutDict["collectionvw"] = collectionvw
        collectionvw.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(collectionvw)
        
        viewDistanceDetails.isHidden = true
        viewDistanceDetails.backgroundColor = .secondaryColor
        layoutDict["viewDistanceDetails"] = viewDistanceDetails
        viewDistanceDetails.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(viewDistanceDetails)
        
        
        lblDistance.textColor = .txtColor
        lblDistance.textAlignment = APIHelper.appTextAlignment
        lblDistance.font = UIFont.appRegularFont(ofSize: 18)//appMediumFont(ofSize: 18) change
        layoutDict["lblDistance"] = lblDistance
        lblDistance.translatesAutoresizingMaskIntoConstraints = false
        viewDistanceDetails.addSubview(lblDistance)
        
        
        lblTollHint.numberOfLines = 0
        lblTollHint.lineBreakMode = .byWordWrapping
        lblTollHint.textColor = .hexToColor("606060")
        lblTollHint.textAlignment = APIHelper.appTextAlignment
        lblTollHint.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblTollHint"] = lblTollHint
        lblTollHint.translatesAutoresizingMaskIntoConstraints = false
       // viewDistanceDetails.addSubview(lblTollHint)
        
        separator.backgroundColor = .hexToColor("DADADA")
        layoutDict["separator"] = separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        viewDistanceDetails.addSubview(separator)
        
        stackPromo.axis = .vertical
        stackPromo.distribution = .fill
        layoutDict["stackPromo"] = stackPromo
        stackPromo.translatesAutoresizingMaskIntoConstraints = false
        viewDistanceDetails.addSubview(stackPromo)
        
        promoHint.isHidden = true
        promoHint.text = "txt_promo_not_applicable_for_this_type".localize()
        promoHint.textColor = .txtColor
        promoHint.textAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .right:.left
        promoHint.font = UIFont.appRegularFont(ofSize: 12)
        layoutDict["promoHint"] = promoHint
        promoHint.translatesAutoresizingMaskIntoConstraints = false
        stackPromo.addArrangedSubview(promoHint)
        
        layoutDict["viewFare"] = viewFare
        viewFare.translatesAutoresizingMaskIntoConstraints = false
        viewDistanceDetails.addSubview(viewFare)
        
        lblFareTitle.text = "txt_total_fare_estimation".localize()
        lblFareTitle.textColor = .txtColor
        lblFareTitle.textAlignment = APIHelper.appTextAlignment
        lblFareTitle.font = UIFont.appMediumFont(ofSize: 16)
        layoutDict["lblFareTitle"] = lblFareTitle
        lblFareTitle.translatesAutoresizingMaskIntoConstraints = false
        viewFare.addSubview(lblFareTitle)
        
       
        btnFareDetail.imageView?.tintColor = .themeColor
        btnFareDetail.setImage(UIImage(named: "paymentexc")?.withRenderingMode(.alwaysTemplate), for: .normal)
        layoutDict["btnFareDetail"] = btnFareDetail
        btnFareDetail.translatesAutoresizingMaskIntoConstraints = false
        viewFare.addSubview(btnFareDetail)
        

        lblAmount.textColor = .txtColor
        lblAmount.textAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .right:.left
        lblAmount.font = UIFont.appSemiBold(ofSize: 22)
        layoutDict["lblAmount"] = lblAmount
        lblAmount.translatesAutoresizingMaskIntoConstraints = false
        viewFare.addSubview(lblAmount)
        
        lblPromoAmount.textColor = .txtColor
        lblPromoAmount.textAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .right:.left
        lblPromoAmount.font = UIFont.appSemiBold(ofSize: 22)
        layoutDict["lblPromoAmount"] = lblPromoAmount
        lblPromoAmount.translatesAutoresizingMaskIntoConstraints = false
        viewFare.addSubview(lblPromoAmount)
        
        lblNote.text = "txt_outstation_fare_hint".localize()
        lblNote.numberOfLines = 0
        lblNote.lineBreakMode = .byWordWrapping
        lblNote.textColor = .hexToColor("606060")
        lblNote.textAlignment = .center
        lblNote.font = UIFont.appRegularFont(ofSize: 12)
        layoutDict["lblNote"] = lblNote
        lblNote.translatesAutoresizingMaskIntoConstraints = false
        viewDistanceDetails.addSubview(lblNote)
        
        payPromoStackView.addBorder(edges: .top, colour: .hexToColor("DADADA"), thickness: 0.5)
        payPromoStackView.axis = .horizontal
        payPromoStackView.distribution = .fillEqually
        layoutDict["payPromoStackView"] = payPromoStackView
        payPromoStackView.translatesAutoresizingMaskIntoConstraints = false
        viewDistanceDetails.addSubview(payPromoStackView)
        
        if APIHelper.appLanguageDirection == .directionRightToLeft {
            btnPaymentMode.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        } else {
            btnPaymentMode.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
        btnPaymentMode.setImage(UIImage(named: "ic_pay_mode_cash"), for: .normal)
        btnPaymentMode.setTitle("txt_cash".localize(), for: .normal)
        btnPaymentMode.setTitleColor(.txtColor, for: .normal)
        btnPaymentMode.titleLabel?.font = UIFont.appMediumFont(ofSize: 15)
        layoutDict["btnPaymentMode"] = btnPaymentMode
        btnPaymentMode.translatesAutoresizingMaskIntoConstraints = false
        payPromoStackView.addArrangedSubview(btnPaymentMode)
        
        if APIHelper.appLanguageDirection == .directionRightToLeft {
            btnApplyPromo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        } else {
            btnApplyPromo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
        btnApplyPromo.addBorder(edges: .left, colour: .hexToColor("f3f3f3"), thickness: 1)
        btnApplyPromo.setImage(UIImage(named: "ic_apply_coupon"), for: .normal)
        btnApplyPromo.setTitle("txt_coupon".localize(), for: .normal)
        btnApplyPromo.setTitleColor(.txtColor, for: .normal)
        btnApplyPromo.titleLabel?.font = UIFont.appMediumFont(ofSize: 15)
        layoutDict["btnApplyPromo"] = btnApplyPromo
        btnApplyPromo.translatesAutoresizingMaskIntoConstraints = false
        payPromoStackView.addArrangedSubview(btnApplyPromo)
        
        viewBookRide.isUserInteractionEnabled = true
        viewBookRide.layer.cornerRadius = 8
        viewBookRide.backgroundColor = .themeColor
        layoutDict["viewBookRide"] = viewBookRide
        viewBookRide.translatesAutoresizingMaskIntoConstraints = false
        viewDistanceDetails.addSubview(viewBookRide)
        
        lblBookRide.text = "text_schedule".localize()
        lblBookRide.textAlignment = .center
        lblBookRide.textColor = .themeTxtColor
        lblBookRide.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblBookRide"] = lblBookRide
        lblBookRide.translatesAutoresizingMaskIntoConstraints = false
        viewBookRide.addSubview(lblBookRide)
        
        viewDate.isHidden = true
        viewDate.isUserInteractionEnabled = true
        viewDate.layer.cornerRadius = 5
        viewDate.backgroundColor = .themeTxtColor
        layoutDict["viewDate"] = viewDate
        viewDate.translatesAutoresizingMaskIntoConstraints = false
        viewBookRide.addSubview(viewDate)
        
        imgCalender.image = UIImage(named: "ic_calender")
        imgCalender.contentMode = .scaleAspectFit
        layoutDict["imgCalender"] = imgCalender
        imgCalender.translatesAutoresizingMaskIntoConstraints = false
        viewDate.addSubview(imgCalender)
        
        lblDate.text = "txt_now".localize()
        lblDate.numberOfLines = 0
        lblDate.lineBreakMode = .byWordWrapping
        lblDate.textAlignment = .center
        lblDate.textColor = .secondaryColor
        lblDate.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblDate"] = lblDate
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        viewDate.addSubview(lblDate)
        
        // ------------Outstation Lists
        
        listView.isHidden = true
        listView.backgroundColor = .secondaryColor
        layoutDict["listView"] = listView
        listView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(listView)
        

        tblOutstationList.backgroundColor = .secondaryColor
        layoutDict["tblOutstationList"] = tblOutstationList
        tblOutstationList.translatesAutoresizingMaskIntoConstraints = false
        listView.addSubview(tblOutstationList)
        
     
        
        //-------------Mapview
        
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: viewContent.topAnchor, constant: 10).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        markerView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        markerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        markerView.centerXAnchor.constraint(equalTo: mapview.centerXAnchor, constant: 0).isActive = true
        markerView.centerYAnchor.constraint(equalTo: mapview.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnBack(40)]-10-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnBack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnBack.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[txtTitle(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-13-[txtTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
       // --------------Location
        
        locationView.bottomAnchor.constraint(equalTo: viewContent.topAnchor, constant: -10).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[locationView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        locationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[locationColor(10)]-8-[txtLocation]-8-[btnEditLocation(25)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        locationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[txtLocation(30)]-5-|", options: [], metrics: nil, views: layoutDict))
        locationColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        locationColor.centerYAnchor.constraint(equalTo: txtLocation.centerYAnchor, constant: 0).isActive = true
        btnEditLocation.heightAnchor.constraint(equalToConstant: 10).isActive = true
        btnEditLocation.centerYAnchor.constraint(equalTo: txtLocation.centerYAnchor, constant: 0).isActive = true
        
      // --------------Content View
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewRideType][stackDate]-8-[viewAddress]-8-[stackView]|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewRideType]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackDate]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[viewAddress]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        
        viewRideType.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnOneWayRide][btnReturnRide(==btnOneWayRide)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        viewRideType.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnOneWayRide(35)]-5-|", options: [], metrics: nil, views: layoutDict))
        
        viewTripDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[lblBookingFrom]-6-[lblFromDate]-12-[lblReturnDate]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        lblBookingFrom.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lblFromDate.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        viewTripDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblFromDate(35)]|", options: [], metrics: nil, views: layoutDict))
        
        // ---------------Address
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pickupTxt(40)][dropTxt(40)]|", options: [], metrics: nil, views: layoutDict))
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[pickupColor(10)]-8-[pickupTxt]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pickupColor.centerYAnchor.constraint(equalTo: pickupTxt.centerYAnchor, constant: 0).isActive = true
        
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[dropColor(10)]-8-[dropTxt]-8-[btnDropDown(25)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropColor.centerYAnchor.constraint(equalTo: dropTxt.centerYAnchor, constant: 0).isActive = true
        btnDropDown.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btnDropDown.centerYAnchor.constraint(equalTo: dropTxt.centerYAnchor, constant: 0).isActive = true
        
        // ------------Ride Type
        
        collectionvw.heightAnchor.constraint(equalToConstant: 80).isActive = true//100
        
        // ----------Distance Details
 
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblDistance(30)]-5-[separator(1)]-5-[stackPromo][viewFare]-5-[lblNote]-8-[payPromoStackView]-5-[viewBookRide(45)]-10-|", options: [], metrics: nil, views: layoutDict))
       
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblDistance]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
     
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[separator]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackPromo]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewFare]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lblNote]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[payPromoStackView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDistanceDetails.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewBookRide]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        btnPaymentMode.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btnApplyPromo.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        promoHint.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewFare.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblAmount][lblPromoAmount]-5-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewFare.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblFareTitle]-5-[btnFareDetail(25)]-16-[lblAmount]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        lblFareTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lblFareTitle.centerYAnchor.constraint(equalTo: viewFare.centerYAnchor, constant: 0).isActive = true
        btnFareDetail.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btnFareDetail.centerYAnchor.constraint(equalTo: lblFareTitle.centerYAnchor, constant: 0).isActive = true
        
        // ------------Book now
        
        viewBookRide.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblBookRide]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewBookRide.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewDate]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewBookRide.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblBookRide]-8-|", options: [], metrics: nil, views: layoutDict))
        viewDate.centerYAnchor.constraint(equalTo: viewBookRide.centerYAnchor, constant: 0).isActive = true
        viewDate.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[lblDate]-4-|", options: [], metrics: nil, views: layoutDict))
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[imgCalender(15)]-4-[lblDate]-4-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgCalender.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imgCalender.centerYAnchor.constraint(equalTo: lblDate.centerYAnchor, constant: 0).isActive = true
        
        
        // -------------------Outstation list
        
        listView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8).isActive = true
        listView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[listView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        listView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblOutstationList]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        listView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tblOutstationList]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    
    }

}

class OutStationTypesCollectionCell: UICollectionViewCell {
    
    let viewContent = UIView()
    let lblFare = UILabel()
    let imgview = UIImageView()
    let lblTypeName = UILabel()
    
    let colorBackground = UIView()
   
    private var layoutDict = [String: AnyObject]()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
    
    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        colorBackground.layer.cornerRadius = 25
        layoutDict["colorBackground"] = colorBackground
        colorBackground.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(colorBackground)
        
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgview)
        
        lblFare.font = UIFont.appSemiBold(ofSize: 14)
        lblFare.textAlignment = .center
        layoutDict["lblFare"] = lblFare
        lblFare.translatesAutoresizingMaskIntoConstraints = false
       // viewContent.addSubview(lblFare)
        
        lblTypeName.font = UIFont.appSemiBold(ofSize: 14)
        lblTypeName.textAlignment = .center
        layoutDict["lblTypeName"] = lblTypeName
        lblTypeName.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTypeName)
        

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblTypeName][imgview(50)]-5-|", options: [], metrics: nil, views: layoutDict))//[lblFare]

        imgview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgview.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true

        //viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblFare]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTypeName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        colorBackground.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorBackground.centerXAnchor.constraint(equalTo: imgview.centerXAnchor, constant: 0).isActive = true
        colorBackground.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorBackground.centerYAnchor.constraint(equalTo: imgview.centerYAnchor, constant: 0).isActive = true
    }
}
