//
//  InvoiceView.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import HCSStarRatingView

class InvoiceView: UIView {

    let scrollview = Myscrollview()
    let containerView = UIView()
    
    let titleView = UIView()
    let titleLbl = UILabel()
    
    let addressView = UIView()
    let invoiceImgView = UIImageView()
    let pickupaddrlbl = UILabel()
    let dropupaddrlbl = UILabel()
    let separator1 = UIView()

    let driverDetailView = UIView()
    let driverprofilepicture = UIImageView()
    let drivernamelbl = UILabel()
    let ratingLbl = UILabel()
    let vehicleImageView = UIImageView()
    let lblVehicleTypeName = UILabel()
    let lblVehicleNumber = UILabel()
    
    let distanceDetailView = UIView()
    let imgDistance = UIImageView()
    let lblDistance = UILabel()
    let imgPayment = UIImageView()
    let lblTripAmount = UILabel()
    
    let dateTimeView = UIView()
    let dateLbl = UILabel()
    let timeLbl = UILabel()
    let endTimeLbl = UILabel()
    let tripTimeLbl = UILabel()
    
    let stackOutstation = UIStackView()
    let viewOutstationDetail = UIView()
    let lblOutstationStartkm = UILabel()
    let lblOutstationStartkmValue = UILabel()
    let lblOutstationEndkm = UILabel()
    let lblOutstationEndkmValue = UILabel()
    
    let billdetailslbl = UILabel()
    
    let stackBill = UIStackView()
    let totalSeparator = UIImageView()
    let totalTitleLabel = UILabel()
    let totalValueLbl = UILabel()
    let zigZagImage = UIImageView()
   
    let conformBtn = UIButton()
    let payBtn = UIButton()
   
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        

        scrollview.bounces = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollview"] = scrollview
        baseView.addSubview(scrollview)
        
        containerView.backgroundColor = .hexToColor("F8F8F8")
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        self.scrollview.addSubview(containerView)
        
        titleView.layer.cornerRadius = 10
       // titleView.addShadow()
        titleView.backgroundColor = .secondaryColor
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleView)
        
        titleLbl.text = "text_invoice".localize().uppercased()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = .center
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        addressView.layer.cornerRadius = 8
       // addressView.addShadow()
        addressView.backgroundColor = .secondaryColor
        layoutDict["addressView"] = addressView
        addressView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(addressView)
        
        pickupaddrlbl.textAlignment = APIHelper.appTextAlignment
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["pickupaddrlbl"] = pickupaddrlbl
        pickupaddrlbl.textColor = .txtColor
        pickupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        addressView.addSubview(pickupaddrlbl)
        
        dropupaddrlbl.textColor = .hexToColor("000000")
        dropupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        dropupaddrlbl.textAlignment = APIHelper.appTextAlignment
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dropupaddrlbl"] = dropupaddrlbl
        addressView.addSubview(dropupaddrlbl)
        
        separator1.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator1"] = separator1
        addressView.addSubview(separator1)
        
        invoiceImgView.contentMode = .scaleAspectFill
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["invoiceImgView"] = invoiceImgView
        invoiceImgView.image = UIImage(named: "ic_address_img")
        addressView.addSubview(invoiceImgView)
        
        
        driverDetailView.layer.cornerRadius = 8
        //driverDetailView.addShadow()
        driverDetailView.backgroundColor = .hexToColor("EAEAEA")
        driverDetailView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverDetailView"] = driverDetailView
        containerView.addSubview(driverDetailView)
        
        driverprofilepicture.backgroundColor = .hexToColor("FFBE7D")
        driverprofilepicture.layer.cornerRadius = 10
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
        
        vehicleImageView.image = UIImage(named: "img_rental")
        vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["vehicleImageView"] = vehicleImageView
        driverDetailView.addSubview(vehicleImageView)
        
        lblVehicleTypeName.textColor = .txtColor
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
        
        //distanceDetailView.addShadow()
        distanceDetailView.layer.cornerRadius = 8
        distanceDetailView.backgroundColor = .secondaryColor
        distanceDetailView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["distanceDetailView"] = distanceDetailView
        containerView.addSubview(distanceDetailView)
        
        imgDistance.image = UIImage(named: "ic_kilo_meter")
        imgDistance.contentMode = .scaleAspectFit
        imgDistance.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgDistance"] = imgDistance
        distanceDetailView.addSubview(imgDistance)
        
        lblDistance.textColor = .txtColor
        lblDistance.textAlignment = .center
        lblDistance.font = UIFont.appBoldFont(ofSize: 25)
        lblDistance.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblDistance"] = lblDistance
        distanceDetailView.addSubview(lblDistance)
        
        imgPayment.image = UIImage(named: "ic_pay_mode_cash")
        imgPayment.contentMode = .scaleAspectFit
        imgPayment.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgPayment"] = imgPayment
        distanceDetailView.addSubview(imgPayment)
        
        lblTripAmount.textColor = .txtColor
        lblTripAmount.textAlignment = .center
        lblTripAmount.font = UIFont.appBoldFont(ofSize: 25)
        lblTripAmount.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblTripAmount"] = lblTripAmount
        distanceDetailView.addSubview(lblTripAmount)
        
        
        dateTimeView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dateTimeView"] = dateTimeView
        distanceDetailView.addSubview(dateTimeView)
        
        
        dateLbl.textColor = .hexToColor("757474")
        dateLbl.textAlignment = .center
        dateLbl.font = UIFont.appRegularFont(ofSize: 14)
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dateLbl"] = dateLbl
        dateTimeView.addSubview(dateLbl)
        
        timeLbl.text = "---"
        timeLbl.textColor = .hexToColor("36AA76")
        timeLbl.textAlignment = .center
        timeLbl.font = UIFont.appRegularFont(ofSize: 14)
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["timeLbl"] = timeLbl
        dateTimeView.addSubview(timeLbl)
        
        endTimeLbl.text = "---"
        endTimeLbl.textColor = .hexToColor("FF0000")
        endTimeLbl.textAlignment = .center
        endTimeLbl.font = UIFont.appRegularFont(ofSize: 14)
        endTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["endTimeLbl"] = endTimeLbl
        dateTimeView.addSubview(endTimeLbl)
        
        tripTimeLbl.textColor = .hexToColor("757474")
        tripTimeLbl.textAlignment = .center
        tripTimeLbl.font = UIFont.appRegularFont(ofSize: 14)
        tripTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tripTimeLbl"] = tripTimeLbl
        dateTimeView.addSubview(tripTimeLbl)
       
      
        stackOutstation.axis = .vertical
        stackOutstation.spacing = 10
        stackOutstation.distribution = .fill
        stackOutstation.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackOutstation"] = stackOutstation
        containerView.addSubview(stackOutstation)
        
        viewOutstationDetail.layer.cornerRadius = 8
        viewOutstationDetail.backgroundColor = .secondaryColor
        viewOutstationDetail.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewOutstationDetail"] = viewOutstationDetail
        stackOutstation.addArrangedSubview(viewOutstationDetail)
        
        lblOutstationStartkm.text = "txt_vehicle_start_km".localize()
        lblOutstationStartkm.textAlignment = APIHelper.appTextAlignment
        lblOutstationStartkm.font = UIFont.appRegularFont(ofSize: 14)
        lblOutstationStartkm.textColor = .hexToColor("525151")
        lblOutstationStartkm.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblOutstationStartkm"] = lblOutstationStartkm
        viewOutstationDetail.addSubview(lblOutstationStartkm)
        
        lblOutstationStartkmValue.textAlignment = APIHelper.appTextAlignment
        lblOutstationStartkmValue.font = UIFont.appSemiBold(ofSize: 16)
        lblOutstationStartkmValue.textColor = .hexToColor("525151")
        lblOutstationStartkmValue.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblOutstationStartkmValue"] = lblOutstationStartkmValue
        viewOutstationDetail.addSubview(lblOutstationStartkmValue)
        
        lblOutstationEndkm.text = "txt_vehicle_end_km".localize()
        lblOutstationEndkm.textAlignment = APIHelper.appTextAlignment
        lblOutstationEndkm.font = UIFont.appRegularFont(ofSize: 14)
        lblOutstationEndkm.textColor = .hexToColor("525151")
        lblOutstationEndkm.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblOutstationEndkm"] = lblOutstationEndkm
        viewOutstationDetail.addSubview(lblOutstationEndkm)
        
        lblOutstationEndkmValue.textAlignment = APIHelper.appTextAlignment
        lblOutstationEndkmValue.font = UIFont.appSemiBold(ofSize: 16)
        lblOutstationEndkmValue.textColor = .hexToColor("525151")
        lblOutstationEndkmValue.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblOutstationEndkmValue"] = lblOutstationEndkmValue
        viewOutstationDetail.addSubview(lblOutstationEndkmValue)
        
        
        
        let billView = UIView()
        billView.layer.cornerRadius = 8
        //billView.addShadow()
        billView.backgroundColor = .secondaryColor
        billView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["billView"] = billView
        stackOutstation.addArrangedSubview(billView)
        
     
        stackBill.axis = .vertical
        stackBill.distribution = .fill
        stackBill.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackBill"] = stackBill
        billView.addSubview(stackBill)
        
        totalSeparator.image = UIImage(named: "img_separator")
        totalSeparator.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalSeparator"] = totalSeparator
        billView.addSubview(totalSeparator)
        
        totalTitleLabel.text = "txt_Total".localize()
        totalTitleLabel.textAlignment = APIHelper.appTextAlignment
        totalTitleLabel.font = UIFont.appSemiBold(ofSize: 20)
        totalTitleLabel.textColor = .txtColor
        totalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalTitleLabel"] = totalTitleLabel
        billView.addSubview(totalTitleLabel)
        
       
        totalValueLbl.textAlignment = APIHelper.appTextAlignment
        totalValueLbl.font = UIFont.appSemiBold(ofSize: 20)
        totalValueLbl.textColor = .txtColor
        totalValueLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalValueLbl"] = totalValueLbl
        billView.addSubview(totalValueLbl)
        
        zigZagImage.image = UIImage(named:"Zig_zag")
        zigZagImage.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["zigZagImage"] = zigZagImage
        billView.addSubview(zigZagImage)
        
   
        conformBtn.setTitle("txt_confirm".localize().uppercased(), for: .normal)
        conformBtn.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        conformBtn.setTitleColor(.themeTxtColor, for: .normal)
        conformBtn.backgroundColor = .themeColor
        conformBtn.layer.cornerRadius = 5
        conformBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["conformBtn"] = conformBtn
        containerView.addSubview(conformBtn)
        
        payBtn.isHidden = true
        payBtn.setTitle("PAY".localize().uppercased(), for: .normal)
        payBtn.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        payBtn.setTitleColor(.themeTxtColor, for: .normal)
        payBtn.backgroundColor = .themeColor
        payBtn.layer.cornerRadius = 5
        payBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["payBtn"] = payBtn
        containerView.addSubview(payBtn)
        
        
        scrollview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.widthAnchor.constraint(equalTo: scrollview.widthAnchor).isActive = true
        let containerViewHgt = containerView.heightAnchor.constraint(equalTo: scrollview.heightAnchor)
        containerViewHgt.priority = .defaultLow
        containerViewHgt.isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleView(45)]-(15)-[addressView]-10-[driverDetailView]-10-[distanceDetailView]-5-[stackOutstation]-15-[conformBtn(50)]-(15)-|", options: [], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[titleView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[addressView]-(15)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[driverDetailView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[distanceDetailView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[stackOutstation]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // -------------Title
        
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl]-5-|", options: [], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[titleLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // ------------------Address
        
        addressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[pickupaddrlbl(30)][separator1(1)][dropupaddrlbl(30)]-(8)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        invoiceImgView.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor, constant: -5).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor, constant: 5).isActive = true
        addressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        addressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[invoiceImgView]-(10)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        addressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[invoiceImgView]-(10)-[separator1]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
       
        
         // ---------------
        driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[driverprofilepicture(70)]-8-[drivernamelbl]-8-[vehicleImageView(70)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        driverprofilepicture.heightAnchor.constraint(equalToConstant: 70).isActive = true
        driverprofilepicture.centerYAnchor.constraint(equalTo: driverDetailView.centerYAnchor, constant: 0).isActive = true
        
        drivernamelbl.topAnchor.constraint(equalTo: driverprofilepicture.topAnchor, constant: 0).isActive = true
        driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[drivernamelbl(30)][ratingLbl(25)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[vehicleImageView(30)]-5-[lblVehicleTypeName]-5-[lblVehicleNumber]-12-|", options: [], metrics: nil, views: layoutDict))
        
        lblVehicleTypeName.centerXAnchor.constraint(equalTo: vehicleImageView.centerXAnchor, constant: 0).isActive = true
        driverDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[lblVehicleNumber]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
       
        // -------------------
       
        
        distanceDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[imgDistance(20)]-5-[lblDistance(40)][dateTimeView]-10-|", options: [], metrics: nil, views: layoutDict))
        distanceDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblDistance]-8-[lblTripAmount(==lblDistance)]-8-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        imgDistance.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgDistance.centerXAnchor.constraint(equalTo: lblDistance.centerXAnchor, constant: 0).isActive = true
        
        imgPayment.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgPayment.centerXAnchor.constraint(equalTo: lblTripAmount.centerXAnchor, constant: 0).isActive = true
        imgPayment.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgPayment.centerYAnchor.constraint(equalTo: imgDistance.centerYAnchor, constant: 0).isActive = true
        
        distanceDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dateTimeView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        //------------------
        
        dateTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dateLbl][timeLbl(==dateLbl)][endTimeLbl(==dateLbl)][tripTimeLbl(==dateLbl)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        dateTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dateLbl(30)]|", options: [], metrics: nil, views: layoutDict))
        
        // ------------------ Outstation
        
        viewOutstationDetail.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblOutstationStartkm(30)][lblOutstationEndkm(30)]-5-|", options: [], metrics: nil, views: layoutDict))
        
        viewOutstationDetail.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblOutstationStartkm][lblOutstationStartkmValue]-8-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        lblOutstationStartkmValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        viewOutstationDetail.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblOutstationEndkm][lblOutstationEndkmValue]-8-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        lblOutstationEndkmValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // -------------------
        
      //  containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[billView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        billView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-3-[stackBill]-3-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        billView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[stackBill]-3-[totalSeparator(1)]-10-[totalTitleLabel(30)]-10-[zigZagImage(10)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        billView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[totalSeparator]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        billView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[totalTitleLabel]-5-[totalValueLbl]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        totalValueLbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        billView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[zigZagImage]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // ---------------------------
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[conformBtn]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[payBtn]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        payBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        payBtn.centerYAnchor.constraint(equalTo: conformBtn.centerYAnchor, constant: 0).isActive = true

        baseView.layoutIfNeeded()
        baseView.setNeedsLayout()
        
    }
}
