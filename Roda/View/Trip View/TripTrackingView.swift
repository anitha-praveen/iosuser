//
//  TripTrackingView.swift
//  Taxiappz
//
//  Created by Apple on 28/02/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps

class TripTrackingView: UIView {
    
    let mapview = GMSMapView()
    let btnMenu = UIButton()
    
    let btnRequestNumber = UIButton()
    
    let btnSos = UIButton()
    
    let viewAddress = UIView()
    let stackAddress = UIStackView()
    
    let pickupView = UIView()
    let viewPickupColor = UIView()
    let lblPickup = UILabel()
    let btnPickupEdit = UIButton()
    
    let separator = UIView()
    
    let stopView = UIView()
    let viewStopColor = UIView()
    let lblStop = UILabel()
    
    let dropView = UIView()
    let viewDropColor = UIView()
    let lblDrop = UILabel()
    let btnDropEdit = UIButton()
    
    let waitingTimeCoverView = UIView()
    let waitingTimeView = UIView()
    let waitingTimeLbl = UILabel()
    let waitingTimeTitleView = UIView()
    let imgTriangle = UIImageView()
    let waitingTimeTitleLbl = UILabel()

    
    let arrivalEtaStack = UIStackView()
    let viewArrivalEta = UIView()
    let lblArrivalEta = UILabel()
    
    let containerView = UIView()
    let stackvw = UIStackView()
    
    let statusView = UIView()
    let lblStatusTitle = UILabel()
    let lblStatusHint = UILabel()
    let otpView = UIView()
    let lblOtp = UILabel()
    
    
    let driverDetailsView = UIView()
    let imgProfile = UIImageView()
    let lblDriverName = UILabel()
    let ratingLbl = UILabel()
    let callBtn = UIButton()
    let shareBtn = UIButton()
    
    let vehicleDetailsView = UIView()
    let vehicleImageView = UIImageView()
    let vehicleTypeLbl = UILabel()
    let vehicleNumberLbl = UILabel()
    let vehicleModelLbl = UILabel()
    
    let paymentModeView = UIView()
    let btnPaymentMode = UIButton()
    let btnApplyPromo = UIButton()
    
    let cancelBookBtn = UIButton()
    
    let transparentWaitingLocationView = UIView()
    let waitingLocationContentView = UIView()
    let lblWaitingLocationTitle = UILabel()
    let lblWaitingLocationContent = UILabel()
    
  
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
        
        btnRequestNumber.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        btnRequestNumber.addShadow()
        btnRequestNumber.layer.cornerRadius = 8
        btnRequestNumber.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        btnRequestNumber.backgroundColor = .secondaryColor
        btnRequestNumber.setTitleColor(.txtColor, for: .normal)
        btnRequestNumber.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["btnRequestNumber"] = btnRequestNumber
        btnRequestNumber.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnRequestNumber)
        
        
        btnMenu.setImage(UIImage(named: "ic_menu"), for: .normal)
        layoutDict["btnMenu"] = btnMenu
        btnMenu.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnMenu)
        baseView.bringSubviewToFront(btnMenu)
        
        btnSos.layer.cornerRadius = 25
        btnSos.setTitle("txt_sos".localize().uppercased(), for: .normal)
        btnSos.setTitleColor(.secondaryColor, for: .normal)
        btnSos.titleLabel?.font = UIFont.appBoldFont(ofSize: 16)
        btnSos.backgroundColor = .hexToColor("F31717")
        layoutDict["btnSos"] = btnSos
        btnSos.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnSos)
        
        
        // ---------------
        
        arrivalEtaStack.axis = .vertical
        arrivalEtaStack.distribution = .fill
        arrivalEtaStack.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["arrivalEtaStack"] = arrivalEtaStack
        baseView.addSubview(arrivalEtaStack)
        
        viewArrivalEta.layer.cornerRadius = 20
        viewArrivalEta.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewArrivalEta.backgroundColor = .hexToColor("FFBE7C")
        viewArrivalEta.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewArrivalEta"] = viewArrivalEta
        arrivalEtaStack.addArrangedSubview(viewArrivalEta)
        
        lblArrivalEta.numberOfLines = 0
        lblArrivalEta.lineBreakMode = .byWordWrapping
        lblArrivalEta.textAlignment = .center
        lblArrivalEta.textColor = .txtColor
        lblArrivalEta.font = UIFont.appBoldFont(ofSize: 16)
        lblArrivalEta.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblArrivalEta"] = lblArrivalEta
        viewArrivalEta.addSubview(lblArrivalEta)
        
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        containerView.backgroundColor = .secondaryColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        baseView.addSubview(containerView)
        
    
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackvw"] = stackvw
        containerView.addSubview(stackvw)
        
        statusView.addBorder(edges: .bottom, colour: .hexToColor("DADADA"),thickness: 0.5)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["statusView"] = statusView
        stackvw.addArrangedSubview(statusView)
        
        lblStatusTitle.numberOfLines = 0
        lblStatusTitle.lineBreakMode = .byWordWrapping
        lblStatusTitle.textAlignment = APIHelper.appTextAlignment
        lblStatusTitle.textColor = .txtColor
        lblStatusTitle.font = UIFont.appBoldFont(ofSize: 15)
        lblStatusTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblStatusTitle"] = lblStatusTitle
        statusView.addSubview(lblStatusTitle)
        
        lblStatusHint.numberOfLines = 0
        lblStatusHint.lineBreakMode = .byWordWrapping
        lblStatusHint.textAlignment = APIHelper.appTextAlignment
        lblStatusHint.textColor = .hexToColor("525252")
        lblStatusHint.font = UIFont.appRegularFont(ofSize: 13)
        lblStatusHint.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblStatusHint"] = lblStatusHint
        statusView.addSubview(lblStatusHint)
        
        otpView.layer.cornerRadius = 5
        otpView.backgroundColor = .hexToColor("FFBE7D")
        otpView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["otpView"] = otpView
        statusView.addSubview(otpView)
        
        lblOtp.font = UIFont.appBoldFont(ofSize: 20)
        lblOtp.textAlignment = .center
        lblOtp.textColor = .txtColor
        lblOtp.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblOtp"] = lblOtp
        otpView.addSubview(lblOtp)
    
        driverDetailsView.addBorder(edges: .bottom, colour: .hexToColor("DADADA"),thickness: 0.5)
        driverDetailsView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverDetailsView"] = driverDetailsView
        stackvw.addArrangedSubview(driverDetailsView)
        
        imgProfile.backgroundColor = .hexToColor("FFBE7D")
        imgProfile.layer.cornerRadius = 10
        imgProfile.clipsToBounds = true
        layoutDict["imgProfile"] = imgProfile
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        driverDetailsView.addSubview(imgProfile)
       
        
        lblDriverName.textColor = .txtColor
        lblDriverName.textAlignment = APIHelper.appTextAlignment
        lblDriverName.font = UIFont.appSemiBold(ofSize: 16)
        layoutDict["lblDriverName"] = lblDriverName
        lblDriverName.translatesAutoresizingMaskIntoConstraints = false
        driverDetailsView.addSubview(lblDriverName)
        
        ratingLbl.textColor = .txtColor
        ratingLbl.textAlignment = APIHelper.appTextAlignment
        ratingLbl.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["ratingLbl"] = ratingLbl
        ratingLbl.translatesAutoresizingMaskIntoConstraints = false
        driverDetailsView.addSubview(ratingLbl)
        
        callBtn.setImage(UIImage(named: "callBtn"), for: .normal)
        callBtn.contentMode = .scaleAspectFit
        callBtn.backgroundColor = .clear
        layoutDict["callBtn"] = callBtn
        callBtn.translatesAutoresizingMaskIntoConstraints = false
        driverDetailsView.addSubview(callBtn)
        
        shareBtn.isHidden = true
        shareBtn.setImage(UIImage(named: "img_share"), for: .normal)
        shareBtn.contentMode = .scaleAspectFit
        shareBtn.backgroundColor = .clear
        layoutDict["shareBtn"] = shareBtn
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        driverDetailsView.addSubview(shareBtn)
        
     
        // -------------VehicleDetailsView
        
        vehicleDetailsView.addBorder(edges: .bottom, colour: .hexToColor("DADADA"),thickness: 0.5)
        layoutDict["vehicleDetailsView"] = vehicleDetailsView
        vehicleDetailsView.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(vehicleDetailsView)
        
        vehicleImageView.image = UIImage(named: "img_rental_selected")
        vehicleImageView.contentMode = .scaleAspectFit
        layoutDict["vehicleImageView"] = vehicleImageView
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        vehicleDetailsView.addSubview(vehicleImageView)
      
        vehicleTypeLbl.textColor = .hexToColor("525252")
        vehicleTypeLbl.textAlignment = APIHelper.appTextAlignment
        vehicleTypeLbl.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["vehicleTypeLbl"] = vehicleTypeLbl
        vehicleTypeLbl.translatesAutoresizingMaskIntoConstraints = false
        vehicleDetailsView.addSubview(vehicleTypeLbl)
        
        
        vehicleNumberLbl.textColor = .txtColor
        vehicleNumberLbl.textAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .right:.left
        vehicleNumberLbl.font = UIFont.appMediumFont(ofSize: 20)
        layoutDict["vehicleNumberLbl"] = vehicleNumberLbl
        vehicleNumberLbl.translatesAutoresizingMaskIntoConstraints = false
        vehicleDetailsView.addSubview(vehicleNumberLbl)
        
       
        vehicleModelLbl.textColor = .hexToColor("525252")
        vehicleModelLbl.textAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .right:.left
        vehicleModelLbl.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["vehicleModelLbl"] = vehicleModelLbl
        vehicleModelLbl.translatesAutoresizingMaskIntoConstraints = false
        vehicleDetailsView.addSubview(vehicleModelLbl)
        
        // ------------Payment Mode
        
        paymentModeView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["paymentModeView"] = paymentModeView
        stackvw.addArrangedSubview(paymentModeView)
        
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
        paymentModeView.addSubview(btnPaymentMode)
        
        btnApplyPromo.isEnabled = false
        btnApplyPromo.addBorder(edges: .left, colour: .hexToColor("f3f3f3"), thickness: 1)
        if APIHelper.appLanguageDirection == .directionRightToLeft {
            btnApplyPromo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        } else {
            btnApplyPromo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
        btnApplyPromo.setImage(UIImage(named: "ic_apply_coupon"), for: .normal)
        btnApplyPromo.setTitle("txt_coupon".localize(), for: .normal)
        btnApplyPromo.setTitleColor(.hexToColor("DADADA"), for: .normal)
        btnApplyPromo.titleLabel?.font = UIFont.appMediumFont(ofSize: 15)
        layoutDict["btnApplyPromo"] = btnApplyPromo
        btnApplyPromo.translatesAutoresizingMaskIntoConstraints = false
        paymentModeView.addSubview(btnApplyPromo)
  
        // -----------Cancellation
        
        cancelBookBtn.setTitle("txt_cancel_book".localize(), for: .normal)
        cancelBookBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        cancelBookBtn.setTitleColor(.themeTxtColor, for: .normal)
        cancelBookBtn.addShadow()
        cancelBookBtn.backgroundColor = .themeColor
        cancelBookBtn.layer.cornerRadius = 5
        layoutDict["cancelBookBtn"] = cancelBookBtn
        stackvw.addArrangedSubview(cancelBookBtn)
        
        // --------------Address
        
        viewAddress.layer.cornerRadius = 10
        viewAddress.backgroundColor = .secondaryColor
        viewAddress.addShadow()
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewAddress)
        
        stackAddress.axis = .vertical
        stackAddress.distribution = .fill
        layoutDict["stackAddress"] = stackAddress
        stackAddress.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(stackAddress)
        
        
        layoutDict["pickupView"] = pickupView
        pickupView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(pickupView)
        
        viewPickupColor.layer.cornerRadius = 5
        viewPickupColor.backgroundColor = .txtColor
        layoutDict["viewPickupColor"] = viewPickupColor
        viewPickupColor.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(viewPickupColor)
        
        lblPickup.textColor = .txtColor
        lblPickup.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblPickup"] = lblPickup
        lblPickup.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(lblPickup)
        
        btnPickupEdit.setImage(UIImage(named: "ic_note"), for: .normal)
        layoutDict["btnPickupEdit"] = btnPickupEdit
        btnPickupEdit.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(btnPickupEdit)
        
        separator.backgroundColor = .hexToColor("E4E9F2")
        layoutDict["separator"] = separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(separator)
        
        stopView.isHidden = true
        layoutDict["stopView"] = stopView
        stopView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(stopView)
        
        viewStopColor.backgroundColor = .red
        layoutDict["viewStopColor"] = viewStopColor
        viewStopColor.translatesAutoresizingMaskIntoConstraints = false
        stopView.addSubview(viewStopColor)
        
        lblStop.textColor = .txtColor
        lblStop.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblStop"] = lblStop
        lblStop.translatesAutoresizingMaskIntoConstraints = false
        stopView.addSubview(lblStop)
        
        layoutDict["dropView"] = dropView
        dropView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(dropView)
        
        viewDropColor.backgroundColor = .red
        layoutDict["viewDropColor"] = viewDropColor
        viewDropColor.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(viewDropColor)
        
        lblDrop.textColor = .txtColor
        lblDrop.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblDrop"] = lblDrop
        lblDrop.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(lblDrop)
        
        btnDropEdit.setImage(UIImage(named: "ic_note"), for: .normal)
        layoutDict["btnDropEdit"] = btnDropEdit
        btnDropEdit.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(btnDropEdit)
        
        
        //--------------- Waiting Time
        
        waitingTimeCoverView.isHidden = true
        layoutDict["waitingTimeCoverView"] = waitingTimeCoverView
        waitingTimeCoverView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(waitingTimeCoverView)
        
       
        waitingTimeView.layer.cornerRadius = 30
        waitingTimeView.addShadow()
        waitingTimeView.backgroundColor = .secondaryColor
        layoutDict["waitingTimeView"] = waitingTimeView
        waitingTimeView.translatesAutoresizingMaskIntoConstraints = false
        waitingTimeCoverView.addSubview(waitingTimeView)
        
        waitingTimeLbl.text = "0.00 \n" + "txt_min".localize()
        waitingTimeLbl.numberOfLines = 0
        waitingTimeLbl.lineBreakMode = .byWordWrapping
        waitingTimeLbl.textAlignment = .center
        waitingTimeLbl.textColor = .txtColor
        waitingTimeLbl.font = UIFont.appBoldFont(ofSize: 14)
        layoutDict["waitingTimeLbl"] = waitingTimeLbl
        waitingTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        waitingTimeView.addSubview(waitingTimeLbl)
        
        imgTriangle.image = UIImage(named: "ic_triangle")
        layoutDict["imgTriangle"] = imgTriangle
        imgTriangle.translatesAutoresizingMaskIntoConstraints = false
        waitingTimeCoverView.addSubview(imgTriangle)
        
        waitingTimeTitleView.layer.cornerRadius = 8
        waitingTimeTitleView.addShadow()
        waitingTimeTitleView.backgroundColor = .themeColor
        layoutDict["waitingTimeTitleView"] = waitingTimeTitleView
        waitingTimeTitleView.translatesAutoresizingMaskIntoConstraints = false
        waitingTimeCoverView.addSubview(waitingTimeTitleView)
        
        waitingTimeTitleLbl.text = "txt_waiting_time".localize()
        waitingTimeTitleLbl.textAlignment = .center
        waitingTimeTitleLbl.textColor = .themeTxtColor
        waitingTimeTitleLbl.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["waitingTimeTitleLbl"] = waitingTimeTitleLbl
        waitingTimeTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        waitingTimeTitleView.addSubview(waitingTimeTitleLbl)
        
        
        // -------------------Location confirmation
        
        transparentWaitingLocationView.isHidden = true
        transparentWaitingLocationView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        transparentWaitingLocationView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["transparentWaitingLocationView"] = transparentWaitingLocationView
        baseView.addSubview(transparentWaitingLocationView)
        
        waitingLocationContentView.layer.cornerRadius = 10
        waitingLocationContentView.backgroundColor = .secondaryColor
        waitingLocationContentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["waitingLocationContentView"] = waitingLocationContentView
        transparentWaitingLocationView.addSubview(waitingLocationContentView)
        
        lblWaitingLocationTitle.text = APIHelper.shared.appName?.uppercased()
        lblWaitingLocationTitle.textAlignment = .center
        lblWaitingLocationTitle.font = UIFont.appSemiBold(ofSize: 20)
        lblWaitingLocationTitle.textColor = .themeColor
        lblWaitingLocationTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblWaitingLocationTitle"] = lblWaitingLocationTitle
        waitingLocationContentView.addSubview(lblWaitingLocationTitle)
        
        
        lblWaitingLocationContent.text = "txt_we_recieved_request".localize() + "...\n" + "txt_wait_confirmation_from_driver".localize()
        lblWaitingLocationContent.numberOfLines = 0
        lblWaitingLocationContent.lineBreakMode = .byWordWrapping
        lblWaitingLocationContent.textAlignment = .center
        lblWaitingLocationContent.font = UIFont.appRegularFont(ofSize: 18)
        lblWaitingLocationContent.textColor = .txtColor
        lblWaitingLocationContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblWaitingLocationContent"] = lblWaitingLocationContent
        waitingLocationContentView.addSubview(lblWaitingLocationContent)
        
        
        // ----------------Constraints
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
      
        btnMenu.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[btnMenu(50)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        btnRequestNumber.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        btnRequestNumber.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnRequestNumber.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        
        // -------sos
        
        btnSos.bottomAnchor.constraint(equalTo: viewAddress.topAnchor, constant: -20).isActive = true
        btnSos.heightAnchor.constraint(equalToConstant: 50).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnSos(50)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    // -------------Waiting Time
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[waitingTimeCoverView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingTimeCoverView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        waitingTimeCoverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[waitingTimeView(60)]-5-[imgTriangle(6)][waitingTimeTitleView(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        waitingTimeCoverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[waitingTimeView(60)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[waitingTimeLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[waitingTimeLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        waitingTimeCoverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imgTriangle(12)]-30-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        waitingTimeCoverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[waitingTimeTitleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingTimeTitleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[waitingTimeTitleLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingTimeTitleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[waitingTimeTitleLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
                
        // ---------------viewAddress
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackAddress]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackAddress]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewPickupColor(10)]-16-[lblPickup]-16-[btnPickupEdit(20)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblPickup(25)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewPickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewPickupColor.centerYAnchor.constraint(equalTo: lblPickup.centerYAnchor, constant: 0).isActive = true
        btnPickupEdit.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnPickupEdit.centerYAnchor.constraint(equalTo: lblPickup.centerYAnchor, constant: 0).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        stopView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewStopColor(10)]-16-[lblStop]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        stopView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblStop(25)]-5-|", options: [], metrics: nil, views: layoutDict))

        viewStopColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewStopColor.centerYAnchor.constraint(equalTo: lblStop.centerYAnchor, constant: 0).isActive = true
        
        
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewDropColor(10)]-16-[lblDrop]-16-[btnDropEdit(20)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblDrop(25)]-5-|", options: [], metrics: nil, views: layoutDict))

        viewDropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewDropColor.centerYAnchor.constraint(equalTo: lblDrop.centerYAnchor, constant: 0).isActive = true
        btnDropEdit.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnDropEdit.centerYAnchor.constraint(equalTo: lblDrop.centerYAnchor, constant: 0).isActive = true
        
     
        // ----------------Container
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewAddress]-8-[arrivalEtaStack][containerView]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[viewAddress]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[arrivalEtaStack]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewArrivalEta.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lblArrivalEta]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewArrivalEta.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblArrivalEta(25)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
       
        containerView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackvw]-10-|", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stackvw]-10-|", options: [], metrics: nil, views: layoutDict))
        
        
        
        statusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblStatusTitle][lblStatusHint]-5-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        statusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lblStatusHint]-5-[otpView]-5-|", options: [], metrics: nil, views: layoutDict))
        
        
        otpView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblOtp(25)]-5-|", options: [], metrics: nil, views: layoutDict))
        otpView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lblOtp]-5-|", options: [], metrics: nil, views: layoutDict))
        lblOtp.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        otpView.centerYAnchor.constraint(equalTo: statusView.centerYAnchor, constant: 0).isActive = true
        
        
        
        
        driverDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgProfile(70)]-8-[lblDriverName]-8-[shareBtn(40)]-8-[callBtn(40)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        driverDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[imgProfile(60)]-8-|", options: [], metrics: nil, views: layoutDict))
        
        driverDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblDriverName(30)][ratingLbl(30)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
   
        callBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        callBtn.centerYAnchor.constraint(equalTo: driverDetailsView.centerYAnchor, constant: 0).isActive = true
        shareBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        shareBtn.centerYAnchor.constraint(equalTo: driverDetailsView.centerYAnchor, constant: 0).isActive = true
       
        // --------------Vehicle Details
        
        vehicleDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[vehicleImageView(40)][vehicleTypeLbl(22)]-5-|", options: [], metrics: nil, views: layoutDict))
        
        vehicleDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[vehicleImageView(80)]-8-[vehicleNumberLbl]-8-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        vehicleTypeLbl.centerXAnchor.constraint(equalTo: vehicleImageView.centerXAnchor, constant: 0).isActive = true
        vehicleDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[vehicleModelLbl]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        vehicleModelLbl.centerYAnchor.constraint(equalTo: vehicleTypeLbl.centerYAnchor, constant: 0).isActive = true
        
        // ------------------Payment Mode
        
        paymentModeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnPaymentMode][btnApplyPromo(==btnPaymentMode)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        paymentModeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[btnPaymentMode(40)]-5-|", options: [], metrics: nil, views: layoutDict))
        
        // -------------------Cancel
        
        cancelBookBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // ---------------transparentWaitingLocationView
        
        transparentWaitingLocationView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        transparentWaitingLocationView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[transparentWaitingLocationView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        waitingLocationContentView.centerYAnchor.constraint(equalTo: transparentWaitingLocationView.centerYAnchor, constant: 0).isActive = true
        
        transparentWaitingLocationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[waitingLocationContentView]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        waitingLocationContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[lblWaitingLocationTitle(30)]-15-[lblWaitingLocationContent]-20-|", options: [], metrics: nil, views: layoutDict))
        waitingLocationContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblWaitingLocationTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingLocationContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblWaitingLocationContent]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }
    
}



