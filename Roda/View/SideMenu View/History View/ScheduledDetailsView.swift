//
//  ScheduledDetailsView.swift
//  Taxiappz
//
//  Created by NPlus Technologies on 02/03/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps

class ScheduledDetailsView: UIView {

    let backBtn = UIButton()
    let scrollview = Myscrollview()
    let containerView = UIView()
    let mapview = GMSMapView()
    let separator1 = UIView()
    let timeTitleLbl = UILabel()
    let durationTitleLbl = UILabel()
    let distanceTitleLbl = UILabel()
    let cancelBtn = UIButton()
    
    let timeLbl = UILabel()
    let distanceLbl = UILabel()
    let durationLbl = UILabel()
    
    let invoiceImgView = UIImageView()
    let pickupaddrlbl = UILabel()
    let dropupaddrlbl = UILabel()
    
    let billdetailslbl = UILabel()
    let listBgView = UITableView(frame: .zero, style: .plain)
    
    var layoutDict = [String:Any]()
    var tableHeight: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(_ baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            self.mapview.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }
        
        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.backgroundColor = .clear
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["backBtn"] = backBtn
        baseView.addSubview(backBtn)
        baseView.bringSubviewToFront(backBtn)
        
        scrollview.bounces = false
        scrollview.backgroundColor = .clear
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollview"] = scrollview
        baseView.addSubview(scrollview)
        
        containerView.backgroundColor = .secondaryColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        self.scrollview.addSubview(containerView)
        
        mapview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["mapview"] = mapview
        
        pickupaddrlbl.textColor = .txtColor
        pickupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        pickupaddrlbl.textAlignment = APIHelper.appTextAlignment
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["pickupaddrlbl"] = pickupaddrlbl
        
        dropupaddrlbl.textColor = .txtColor
        dropupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        dropupaddrlbl.textAlignment = APIHelper.appTextAlignment
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dropupaddrlbl"] = dropupaddrlbl
        
        invoiceImgView.image = UIImage(named: "ic_address_img")
        invoiceImgView.contentMode = .scaleToFill
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["invoiceImgView"] = invoiceImgView
        
        
        separator1.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator1"] = separator1
        
        timeTitleLbl.text = "txt_trip_time_text".localize() + ":"
        timeTitleLbl.textColor = .txtColor
        timeTitleLbl.textAlignment = APIHelper.appTextAlignment
        timeTitleLbl.font = UIFont.appRegularFont(ofSize: 14)
        timeTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["timeTitleLbl"] = timeTitleLbl
        
        durationTitleLbl.text = "txt_total_duration".localize() + ":"
        durationTitleLbl.textColor = .txtColor
        durationTitleLbl.textAlignment = APIHelper.appTextAlignment
        durationTitleLbl.font = UIFont.appRegularFont(ofSize: 14)
        durationTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["durationTitleLbl"] = durationTitleLbl
        
        distanceTitleLbl.text = "txt_total_distance".localize() + ":"  //"Total Distance:"
        distanceTitleLbl.textColor = .txtColor
        distanceTitleLbl.textAlignment = APIHelper.appTextAlignment
        distanceTitleLbl.font = UIFont.appRegularFont(ofSize: 14)
        distanceTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["distanceTitleLbl"] = distanceTitleLbl
        
        timeLbl.textColor = .txtColor
        timeLbl.textAlignment = .left
        timeLbl.font = UIFont.appRegularFont(ofSize: 14)
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["timeLbl"] = timeLbl
        
        distanceLbl.textColor = .txtColor
        distanceLbl.textAlignment = APIHelper.appTextAlignment
        distanceLbl.font = UIFont.appRegularFont(ofSize: 14)
        distanceLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["distanceLbl"] = distanceLbl
        
        durationLbl.textColor = .txtColor
        durationLbl.textAlignment = APIHelper.appTextAlignment
        durationLbl.font = UIFont.appRegularFont(ofSize: 14)
        durationLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["durationLbl"] = durationLbl
        
        billdetailslbl.text = "text_bill_details".localize()
        billdetailslbl.textAlignment = APIHelper.appTextAlignment
        billdetailslbl.font = UIFont.appSemiBold(ofSize: 17)
        billdetailslbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["billdetailslbl"] = billdetailslbl
        
        listBgView.separatorStyle = .none
        listBgView.allowsSelection = false
        listBgView.rowHeight = UITableView.automaticDimension
        listBgView.showsVerticalScrollIndicator = false
        listBgView.backgroundColor = .clear
        listBgView.estimatedRowHeight = 40
        listBgView.contentInsetAdjustmentBehavior = .never
        listBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["listBgView"] = listBgView
        listBgView.reloadData()
        
        cancelBtn.setTitle("text_cancel".localize().uppercased(), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        cancelBtn.setTitleColor(.secondaryColor, for: .normal)
        cancelBtn.backgroundColor = .themeColor
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(cancelBtn)
        layoutDict["cancelBtn"] = cancelBtn
        
        
        [mapview,pickupaddrlbl,dropupaddrlbl,invoiceImgView,separator1,timeTitleLbl,distanceTitleLbl,durationTitleLbl,timeLbl,distanceLbl,durationLbl,billdetailslbl,listBgView].forEach { $0.removeFromSuperview();containerView.addSubview($0) }
        
    
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor , constant: 10).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backBtn(30)]", options: [], metrics: nil, views: layoutDict))
        
        
        scrollview.topAnchor.constraint(equalTo: backBtn.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollview]-[cancelBtn]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        cancelBtn.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerViewHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerViewHgt.priority = .defaultLow
        containerViewHgt.isActive = true
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[mapview(160)]-10-[pickupaddrlbl(25)]-10-[dropupaddrlbl(25)]-10-[separator1(1)]-10-[timeTitleLbl(25)]-10-[durationTitleLbl(25)]-10-[distanceTitleLbl(25)]", options: [], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        invoiceImgView.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor, constant: -3).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor, constant: 5).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator1]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[timeTitleLbl(>=120)]-[timeLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[durationTitleLbl(>=120)]-[durationLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[distanceTitleLbl(>=120)]-[distanceLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelBtn]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        timeLbl.centerYAnchor.constraint(equalTo: timeTitleLbl.centerYAnchor).isActive = true
        timeLbl.heightAnchor.constraint(equalTo: timeTitleLbl.heightAnchor).isActive = true
        
        durationLbl.centerYAnchor.constraint(equalTo: durationTitleLbl.centerYAnchor).isActive = true
        durationLbl.heightAnchor.constraint(equalTo: durationTitleLbl.heightAnchor).isActive = true
        
        distanceLbl.centerYAnchor.constraint(equalTo: distanceTitleLbl.centerYAnchor).isActive = true
        distanceLbl.heightAnchor.constraint(equalTo: distanceTitleLbl.heightAnchor).isActive = true
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[timeTitleLbl(25)]-10-[billdetailslbl(25)]-10-[listBgView]-10-|", options: [], metrics: nil, views: layoutDict))

        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[billdetailslbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[listBgView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        self.tableHeight = listBgView.heightAnchor.constraint(equalToConstant: 0)
        self.tableHeight.isActive = true
        listBgView.reloadData() // After Tableviews datasource methods are loaded add height constraint to tableview
        listBgView.layoutIfNeeded()
        
        baseView.setNeedsLayout()
        baseView.layoutIfNeeded()

    }
    
    
}



class InvoiceCell:UITableViewCell {

    var layoutDict = [String:AnyObject]()
    let stackView = UIStackView()
    let keyValueView = UIView()
    let keyLbl = UILabel()
    let valueLbl = UILabel()
    let noteLbl = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    func setupViews() {

        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackView"] = stackView
        addSubview(stackView)

        keyValueView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["keyValueView"] = keyValueView
        stackView.addArrangedSubview(keyValueView)

        keyLbl.numberOfLines = 0
        keyLbl.lineBreakMode = .byWordWrapping
        keyLbl.textAlignment = APIHelper.appTextAlignment
        keyLbl.font = UIFont.appRegularFont(ofSize: 14)
        keyLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["keyLbl"] = keyLbl
        keyValueView.addSubview(keyLbl)

        valueLbl.adjustsFontSizeToFitWidth = true
        valueLbl.minimumScaleFactor = 0.1
        valueLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        valueLbl.font = UIFont.appRegularFont(ofSize: 14)
        valueLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["valueLbl"] = valueLbl
        keyValueView.addSubview(valueLbl)

        noteLbl.textAlignment = APIHelper.appTextAlignment
        noteLbl.font = UIFont.appFont(ofSize: 14)
        noteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["noteLbl"] = noteLbl
        stackView.addArrangedSubview(noteLbl)

        let noteLblHeight = noteLbl.heightAnchor.constraint(equalToConstant: 21)
        noteLblHeight.priority = UILayoutPriority.defaultLow
        noteLblHeight.isActive = true

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: layoutDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[stackView]-(15)-|", options: [], metrics: nil, views: layoutDict))
        keyValueView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[keyLbl(>=26)]|", options: [], metrics: nil, views: layoutDict))
        keyValueView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[keyLbl]-(5)-[valueLbl]-(0)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        valueLbl.widthAnchor.constraint(equalTo: keyLbl.widthAnchor, multiplier: 0.3).isActive = true

    }
}
