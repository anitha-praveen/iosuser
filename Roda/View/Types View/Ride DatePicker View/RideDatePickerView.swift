//
//  RideDatePickerView.swift
//  Taxiappz
//
//  Created by Apple on 18/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit

class RideDatePickerView: UIView {
    
    let viewContent = UIView()
    let lblHeader = UILabel()
    
    let stackvw = UIStackView()
    let viewHint = UIView()
    let lblScheduleRide = UILabel()
    let lblHint = UILabel()
    
    let btnReset = UIButton()
    let datePicker = UIDatePicker()
    let btnConfirm = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        lblHeader.text = "txt_pickupTime".localize()
        lblHeader.textAlignment = APIHelper.appTextAlignment
        lblHeader.textColor = .txtColor
        lblHeader.font = UIFont.appSemiBold(ofSize: 20)
        layoutDict["lblHeader"] = lblHeader
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblHeader)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        layoutDict["stackvw"] = stackvw
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackvw)
        
        viewHint.layer.cornerRadius = 5
        viewHint.layer.borderWidth = 1.0
        viewHint.layer.borderColor = UIColor.themeColor.cgColor
        layoutDict["viewHint"] = viewHint
        viewHint.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewHint)
        
        lblScheduleRide.text = "txt_schedule_ride".localize()
        lblScheduleRide.textAlignment = APIHelper.appTextAlignment
        lblScheduleRide.textColor = .themeColor
        lblScheduleRide.font = UIFont.appSemiBold(ofSize: 16)
        layoutDict["lblScheduleRide"] = lblScheduleRide
        lblScheduleRide.translatesAutoresizingMaskIntoConstraints = false
        viewHint.addSubview(lblScheduleRide)
        
        lblHint.text = "Txt_Schedule_Alert".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textAlignment = APIHelper.appTextAlignment
        lblHint.textColor = .txtColor
        lblHint.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        viewHint.addSubview(lblHint)
        
      
        
        
        btnReset.setTitle("txt_reset_now".localize().uppercased(), for: .normal)
        btnReset.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnReset.setTitleColor(.themeColor, for: .normal)
        btnReset.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnReset"] = btnReset
        viewContent.addSubview(btnReset)
        
        datePicker.minimumDate = Date().addingTimeInterval(TimeInterval(30 * 60))
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["datePicker"] = datePicker
        viewContent.addSubview(datePicker)
        
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.setTitle("txt_confirm".localize().uppercased(), for: .normal)
        btnConfirm.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnConfirm.setTitleColor(.themeTxtColor, for: .normal)
        btnConfirm.backgroundColor = .themeColor
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnConfirm"] = btnConfirm
        viewContent.addSubview(btnConfirm)
        
        
        
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[lblHeader]-10-[stackvw]-10-[btnReset(30)]-20-[datePicker(200)]-20-[btnConfirm(48)]-20-|", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblHeader]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackvw]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnReset]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[datePicker]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnConfirm]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewHint.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblScheduleRide]-10-[lblHint]-10-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        viewHint.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblScheduleRide]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        
        
    }
}
