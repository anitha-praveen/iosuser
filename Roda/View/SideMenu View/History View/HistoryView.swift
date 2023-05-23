//
//  HistoryView.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

extension UISegmentedControl {

    func setTitleColor(_ color: UIColor, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
    
    func setTitleFont(_ font: UIFont, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.font] = font
        self.setTitleTextAttributes(attributes, for: state)
    }

}

class HistoryView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
    
    let segmentedControl = UISegmentedControl(items: ["txt_schedule".localize().uppercased(),"txt_completed".localize().uppercased(),"txt_cancelled".localize().uppercased()])


    let historytbv = UITableView()
   
    let imgNoRides = UIImageView()
    let lblNoRides = UILabel()
    
    let cancelAlertView = UIView()
    let alertView = UIView()
    let lblAlertTitle = UILabel()
    let lblAlertHint = UILabel()
    let btnAlertYes = UIButton()
    let btnAlertNo = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .hexToColor("EAEAEA")
     
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
        
        titleLbl.text = "txt_my_rides".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .themeColor
        } else {
            segmentedControl.tintColor = .themeColor
        }
        segmentedControl.setTitleColor(.txtColor, state: .selected)
        segmentedControl.setTitleColor(.hexToColor("606060"), state: .normal)
        segmentedControl.setTitleFont(UIFont.appBoldFont(ofSize: 16), state: .selected)
        segmentedControl.setTitleFont(UIFont.appMediumFont(ofSize: 16), state: .normal)
        segmentedControl.layer.cornerRadius = 8
        segmentedControl.clipsToBounds = true
        segmentedControl.backgroundColor = .secondaryColor
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["segmentedControl"] = segmentedControl
        baseView.addSubview(segmentedControl)

        imgNoRides.isHidden = true
        imgNoRides.image = UIImage(named: "img_norides")
        imgNoRides.contentMode = .scaleAspectFit
        imgNoRides.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgNoRides"] = imgNoRides
        baseView.addSubview(imgNoRides)
        
        lblNoRides.isHidden = true
        lblNoRides.numberOfLines = 0
        lblNoRides.lineBreakMode = .byWordWrapping
        lblNoRides.text = "txt_no_records".localize() + "\n" + "txt_make_history".localize()
        lblNoRides.textAlignment = .center
        lblNoRides.font = UIFont.appBoldFont(ofSize: 20)
        lblNoRides.textColor = .hexToColor("555555")
        lblNoRides.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblNoRides"] = lblNoRides
        baseView.addSubview(lblNoRides)

        
        historytbv.backgroundColor = .hexToColor("EAEAEA")
        historytbv.alwaysBounceVertical = false
        historytbv.tableFooterView = UIView()
        historytbv.separatorStyle = .none
        historytbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["historytbv"] = historytbv
        baseView.addSubview(historytbv)
        
        
        // ---------------Cancel Alert
        
        cancelAlertView.isHidden = true
        cancelAlertView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.5)
        cancelAlertView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cancelAlertView"] = cancelAlertView
        baseView.addSubview(cancelAlertView)
        
        alertView.layer.cornerRadius = 20
        alertView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        alertView.backgroundColor = .secondaryColor
        alertView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["alertView"] = alertView
        cancelAlertView.addSubview(alertView)
        
        lblAlertTitle.text = "txt_are_you_sure".localize()
        lblAlertTitle.textAlignment = APIHelper.appTextAlignment
        lblAlertTitle.textColor = .txtColor
        lblAlertTitle.font = UIFont.appBoldFont(ofSize: 20)
        lblAlertTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblAlertTitle"] = lblAlertTitle
        alertView.addSubview(lblAlertTitle)
        
        lblAlertHint.text = "txt_cancel_scheduled_ride".localize()
        lblAlertHint.numberOfLines = 0
        lblAlertHint.lineBreakMode = .byWordWrapping
        lblAlertHint.textAlignment = APIHelper.appTextAlignment
        lblAlertHint.textColor = .hexToColor("B1B1B1")
        lblAlertHint.font = UIFont.appRegularFont(ofSize: 16)
        lblAlertHint.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblAlertHint"] = lblAlertHint
        alertView.addSubview(lblAlertHint)
        
        btnAlertYes.layer.cornerRadius = 8
        btnAlertYes.setTitle("text_yes".localize(), for: .normal)
        btnAlertYes.backgroundColor = .themeColor
        btnAlertYes.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        btnAlertYes.setTitleColor(.themeTxtColor, for: .normal)
        btnAlertYes.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnAlertYes"] = btnAlertYes
        alertView.addSubview(btnAlertYes)
        
        btnAlertNo.layer.cornerRadius = 8
        btnAlertNo.setTitle("text_no".localize(), for: .normal)
        btnAlertNo.backgroundColor = .hexToColor("D9D9D9")
        btnAlertNo.titleLabel?.font = UIFont.appRegularFont(ofSize: 16)
        btnAlertNo.setTitleColor(.txtColor, for: .normal)
        btnAlertNo.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnAlertNo"] = btnAlertNo
        alertView.addSubview(btnAlertNo)
        
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
       
    
        historytbv.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-20-[segmentedControl(40)]-10-[historytbv]", options: [], metrics: nil, views: layoutDict))
    
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[segmentedControl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[historytbv]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        imgNoRides.widthAnchor.constraint(equalToConstant: 180).isActive = true
        imgNoRides.heightAnchor.constraint(equalToConstant: 158).isActive = true
        imgNoRides.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        imgNoRides.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgNoRides]-10-[lblNoRides]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[lblNoRides]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // ------------Cancel Alert
        
        cancelAlertView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        cancelAlertView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cancelAlertView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        cancelAlertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[alertView]|", options: [], metrics: nil, views: layoutDict))
        cancelAlertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[alertView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblAlertTitle(30)]-5-[lblAlertHint]-20-[btnAlertYes(40)]-20-|", options: [], metrics: nil, views: layoutDict))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblAlertTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblAlertHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnAlertNo]-8-[btnAlertYes(==btnAlertNo)]-16-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
    }

}

class HistoryTableViewCell: UITableViewCell {
    
    let viewDate = UIView()
    let lblDate = UILabel()
    let lblTime = UILabel()
    let lblRideType = UILabel()

    let viewContent = UIView()
    let stackvw = UIStackView()
    let driverDetailView = UIView()
    let driverprofilepicture = UIImageView()
    let drivernamelbl = UILabel()
    let ratingLbl = UILabel()
    let lblRequestNumber = UILabel()
    let vehicleImageView = UIImageView()
    let lblVehicleTypeName = UILabel()
    let lblVehicleNumber = UILabel()
    
    let viewAddress = UIView()
    let pickupColor = UIView()
    let pickupTxt = UILabel()
    let dropColor = UIView()
    let dropTxt = UILabel()
    
    let btnDispute = UIButton()
    let btnCancelScheduleTrip = UIButton()
    let viewCancelReason = UIView()
    let lblCancelReason = UILabel()
    
    var layoutDict = [String:AnyObject]()

    var disputeAction:(()->())?
    var cancelScheduleAction:(()->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
  
    func setUpViews()
    {
        
        self.backgroundColor = .hexToColor("EAEAEA")
        
        contentView.isUserInteractionEnabled = true
        self.selectionStyle = .none
        
        viewDate.layer.cornerRadius = 10
        viewDate.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewDate.backgroundColor = .hexToColor("#48CB90")
        viewDate.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewDate"] = viewDate
        self.addSubview(viewDate)
        
        lblDate.textColor = .themeTxtColor
        lblDate.textAlignment = APIHelper.appTextAlignment
        lblDate.font = UIFont.appMediumFont(ofSize: 14)
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblDate"] = lblDate
        viewDate.addSubview(lblDate)
        
        lblTime.textColor = .themeTxtColor
        lblTime.textAlignment = APIHelper.appTextAlignment
        lblTime.font = UIFont.appMediumFont(ofSize: 14)
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblTime"] = lblTime
        viewDate.addSubview(lblTime)
        
        lblRideType.textColor = .themeTxtColor
        lblRideType.textAlignment = .center
        lblRideType.font = UIFont.appMediumFont(ofSize: 14)
        lblRideType.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblRideType"] = lblRideType
        viewDate.addSubview(lblRideType)
        
        viewContent.layer.cornerRadius = 8
        viewContent.addShadow()
        viewContent.backgroundColor = .secondaryColor
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewContent"] = viewContent
        self.addSubview(viewContent)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackvw"] = stackvw
        viewContent.addSubview(stackvw)
        
        driverDetailView.layer.cornerRadius = 8
        driverDetailView.backgroundColor = .secondaryColor
        driverDetailView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverDetailView"] = driverDetailView
        stackvw.addArrangedSubview(driverDetailView)
        
        //driverprofilepicture.contentMode = .scaleAspectFit
        driverprofilepicture.backgroundColor = .hexToColor("EAEAEA")
        driverprofilepicture.layer.cornerRadius = 8
        driverprofilepicture.clipsToBounds = true
        driverprofilepicture.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverprofilepicture"] = driverprofilepicture
        driverDetailView.addSubview(driverprofilepicture)
        
        drivernamelbl.textColor = .txtColor
        drivernamelbl.textAlignment = APIHelper.appTextAlignment
        drivernamelbl.font = UIFont.appMediumFont(ofSize: 20)
        drivernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["drivernamelbl"] = drivernamelbl
        driverDetailView.addSubview(drivernamelbl)
        
        ratingLbl.textColor = .txtColor
        ratingLbl.textAlignment = APIHelper.appTextAlignment
        ratingLbl.font = UIFont.appRegularFont(ofSize: 14)
        ratingLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["ratingLbl"] = ratingLbl
        driverDetailView.addSubview(ratingLbl)
        
        lblRequestNumber.textColor = .hexToColor("525252")
        lblRequestNumber.textAlignment = APIHelper.appTextAlignment
        lblRequestNumber.font = UIFont.appRegularFont(ofSize: 12)
        lblRequestNumber.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblRequestNumber"] = lblRequestNumber
        driverDetailView.addSubview(lblRequestNumber)
        
        vehicleImageView.image = UIImage(named: "img_rental")
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["vehicleImageView"] = vehicleImageView
        driverDetailView.addSubview(vehicleImageView)
        
        lblVehicleTypeName.textColor = .hexToColor("525252")
        lblVehicleTypeName.textAlignment = APIHelper.appTextAlignment
        lblVehicleTypeName.font = UIFont.appRegularFont(ofSize: 13)
        lblVehicleTypeName.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblVehicleTypeName"] = lblVehicleTypeName
        driverDetailView.addSubview(lblVehicleTypeName)
        
        lblVehicleNumber.textColor = .txtColor
        lblVehicleNumber.textAlignment = APIHelper.appTextAlignment
        lblVehicleNumber.font = UIFont.appSemiBold(ofSize: 16)
        lblVehicleNumber.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblVehicleNumber"] = lblVehicleNumber
        driverDetailView.addSubview(lblVehicleNumber)
        
        // -----------Address
        
        viewAddress.layer.cornerRadius = 8
        viewAddress.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        viewAddress.backgroundColor = .secondaryColor
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewAddress)
        
        pickupTxt.addBorder(edges: .bottom,colour: .hexToColor("DDDDDD"),thickness: 1.0)
        pickupTxt.textColor = .hexToColor("2F2E2E")
        pickupTxt.textAlignment = APIHelper.appTextAlignment
        pickupTxt.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["pickupTxt"] = pickupTxt
        pickupTxt.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(pickupTxt)
        
        pickupColor.layer.cornerRadius = 5
        pickupColor.backgroundColor = .themeColor
        layoutDict["pickupColor"] = pickupColor
        pickupColor.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(pickupColor)
        
        let addressVerticlaLIne = UIView()
        addressVerticlaLIne.backgroundColor = .hexToColor("DDDDDD")
        layoutDict["addressVerticlaLIne"] = addressVerticlaLIne
        addressVerticlaLIne.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(addressVerticlaLIne)
        
       
        dropTxt.textColor = .hexToColor("2F2E2E")
        dropTxt.textAlignment = APIHelper.appTextAlignment
        dropTxt.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["dropTxt"] = dropTxt
        dropTxt.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(dropTxt)
        
        
        dropColor.backgroundColor = .red
        layoutDict["dropColor"] = dropColor
        dropColor.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(dropColor)
        
        
        // ----------Dispute
        
        btnDispute.addTarget(self, action: #selector(btnDisputePressed(_ :)), for: .touchUpInside)
        btnDispute.layer.cornerRadius = 8
        btnDispute.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        btnDispute.setTitle("txt_any_dispute".localize(), for: .normal)
        btnDispute.setTitleColor(.secondaryColor, for: .normal)
        btnDispute.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnDispute.backgroundColor = .hexToColor("#E76565")
        layoutDict["btnDispute"] = btnDispute
        btnDispute.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(btnDispute)
        
        btnCancelScheduleTrip.addTarget(self, action: #selector(btnCancelScheduleTripPressed(_ :)), for: .touchUpInside)
        btnCancelScheduleTrip.layer.cornerRadius = 8
        btnCancelScheduleTrip.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        btnCancelScheduleTrip.setTitle("text_cancel".localize().uppercased(), for: .normal)
        btnCancelScheduleTrip.setTitleColor(.secondaryColor, for: .normal)
        btnCancelScheduleTrip.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnCancelScheduleTrip.backgroundColor = .hexToColor("#E76565")
        layoutDict["btnCancelScheduleTrip"] = btnCancelScheduleTrip
        btnCancelScheduleTrip.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(btnCancelScheduleTrip)
        
        viewCancelReason.addBorder(edges: .top,colour: .hexToColor("DADADA"),thickness: 0.5)
        viewCancelReason.layer.cornerRadius = 8
        viewCancelReason.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        layoutDict["viewCancelReason"] = viewCancelReason
        viewCancelReason.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewCancelReason)
        
        lblCancelReason.textColor = .hexToColor("#E76565")
        lblCancelReason.textAlignment = .center
        lblCancelReason.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblCancelReason"] = lblCancelReason
        lblCancelReason.translatesAutoresizingMaskIntoConstraints = false
        viewCancelReason.addSubview(lblCancelReason)
        
        // ---------------
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewDate][viewContent]-8-|", options: [], metrics: nil, views: layoutDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[viewContent]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[viewDate]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
    
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblDate]-5-[lblRideType]-5-[lblTime]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblDate(30)]|", options: [], metrics: nil, views: layoutDict))
        lblDate.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lblTime.setContentHuggingPriority(.defaultHigh, for: .horizontal)

      
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackvw]|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // --------------- Driver Detail
       driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[driverprofilepicture(70)]-8-[drivernamelbl]-8-[vehicleImageView(70)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
       
       driverprofilepicture.heightAnchor.constraint(equalToConstant: 70).isActive = true
       driverprofilepicture.centerYAnchor.constraint(equalTo: driverDetailView.centerYAnchor, constant: 0).isActive = true
    
       
       driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-7-[drivernamelbl(30)]-2-[ratingLbl]-3-[lblRequestNumber]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
       
       driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[vehicleImageView(30)]-2-[lblVehicleTypeName]-3-[lblVehicleNumber]|", options: [], metrics: nil, views: layoutDict))
       
        driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[lblVehicleTypeName]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
       driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[lblVehicleNumber]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // -----------Address
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pickupTxt(35)]-5-[dropTxt(30)]-5-|", options: [], metrics: nil, views: layoutDict))
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[pickupColor(10)]-8-[pickupTxt]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pickupColor.centerYAnchor.constraint(equalTo: pickupTxt.centerYAnchor, constant: 0).isActive = true
        
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[dropColor(10)]-8-[dropTxt]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropColor.centerYAnchor.constraint(equalTo: dropTxt.centerYAnchor, constant: 0).isActive = true
        
        addressVerticlaLIne.widthAnchor.constraint(equalToConstant: 1).isActive = true
        addressVerticlaLIne.centerXAnchor.constraint(equalTo: pickupColor.centerXAnchor, constant: 0).isActive = true
        addressVerticlaLIne.topAnchor.constraint(equalTo: pickupColor.bottomAnchor, constant: 0).isActive = true
        addressVerticlaLIne.bottomAnchor.constraint(equalTo: dropColor.topAnchor, constant: 0).isActive = true
        
        // ------------Dispute
        
        btnDispute.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnCancelScheduleTrip.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewCancelReason.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblCancelReason]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewCancelReason.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblCancelReason(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }
    
    @objc func btnDisputePressed(_ sender: UIButton) {
        if let action = self.disputeAction {
            action()
        }
    }
    
    @objc func btnCancelScheduleTripPressed(_ sender: UIButton) {
        if let action = self.cancelScheduleAction {
            action()
        }
    }

}
