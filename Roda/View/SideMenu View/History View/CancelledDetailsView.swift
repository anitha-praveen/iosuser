//
//  CancelledDetailsView.swift
//  Taxiappz
//
//  Created by spextrum on 30/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import HCSStarRatingView

class CancelledDetailsView: UIView {

    let backBtn = UIButton()
    
    let contentView = UIView()
    
    let invoiceImgView = UIImageView()
    let pickupaddrlbl = UILabel()
    let dropupaddrlbl = UILabel()
    let separator1 = UIView()
    
    let driverprofilepicture = UIImageView()
    let dateTimeLbl = UILabel()
    let drivernamelbl = UILabel()
    var carLbl = UILabel()
    let rating = HCSStarRatingView()
    let ratingLbl = UILabel()
    var resIdLbl = UILabel()
    let separator2 = UIView()
    
    let totalFareDisLbl = UILabel()
    let distancelbl = UILabel()
    let separator3 = UIView()
    
    let billdetailslbl = UILabel()
    let totheaderlbl = UILabel()
    let totLbl = UILabel()
    let zigzagImgView = UIImageView()
    
    let cancelBtn = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        
        baseView.addSubview(contentView)
        contentView.addSubview(invoiceImgView)
        contentView.addSubview(pickupaddrlbl)
        contentView.addSubview(dropupaddrlbl)
        contentView.addSubview(separator1)
        
        contentView.addSubview(driverprofilepicture)
        contentView.addSubview(rating)
        contentView.addSubview(carLbl)
        contentView.addSubview(ratingLbl)
        contentView.addSubview(drivernamelbl)
        contentView.addSubview(dateTimeLbl)
        contentView.addSubview(separator2)
        
        contentView.addSubview(totalFareDisLbl)
        contentView.addSubview(distancelbl)
        contentView.addSubview(separator3)
        
        contentView.addSubview(billdetailslbl)
        
        contentView.addSubview(totheaderlbl)
        contentView.addSubview(totLbl)
        
        contentView.addSubview(zigzagImgView)
        
        billdetailslbl.text = "text_bill_details".localize()
        
        self.drivernamelbl.textAlignment = APIHelper.appTextAlignment
        self.drivernamelbl.font = UIFont.appSemiBold(ofSize: 16)
        self.totalFareDisLbl.font = UIFont.appRegularFont(ofSize: 17)
        self.distancelbl.font = UIFont.appSemiBold(ofSize: 15)
        self.pickupaddrlbl.textAlignment = APIHelper.appTextAlignment
        self.dropupaddrlbl.textAlignment = APIHelper.appTextAlignment
        self.billdetailslbl.textAlignment = APIHelper.appTextAlignment
        self.billdetailslbl.font = UIFont.appSemiBold(ofSize: 17)
        
        
        pickupaddrlbl.textColor = .txtColor
        pickupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        dropupaddrlbl.textColor = .txtColor
        dropupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        
        totheaderlbl.textAlignment = APIHelper.appTextAlignment
        totheaderlbl.font = UIFont.appSemiBold(ofSize: 20)
        totLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        totLbl.font = UIFont.appSemiBold(ofSize: 20)
        
        distancelbl.text = "----"
        totheaderlbl.text = "-----"
        totLbl.text = "---"
        totalFareDisLbl.text = "txt_your_trip_dis".localize()
        zigzagImgView.image = UIImage(named: "Zig_zag")
        invoiceImgView.image = UIImage(named: "ic_address_img")
        separator1.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        separator2.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        separator3.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        
        self.pickupaddrlbl.textAlignment = APIHelper.appTextAlignment
        self.pickupaddrlbl.font = UIFont.appFont(ofSize: 14)
        self.dropupaddrlbl.textAlignment = APIHelper.appTextAlignment
        self.dropupaddrlbl.font = UIFont.appFont(ofSize: 14)
        
    
        contentView.backgroundColor = .secondaryColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["contentView"] = contentView
        
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["pickupaddrlbl"] = pickupaddrlbl
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dropupaddrlbl"] = dropupaddrlbl
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["invoiceImgView"] = invoiceImgView
        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator1"] = separator1
        
        driverprofilepicture.layer.masksToBounds = false
        driverprofilepicture.clipsToBounds = true
        driverprofilepicture.layer.cornerRadius = 22.5
        driverprofilepicture.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverprofilepicture"] = driverprofilepicture
        dateTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dateTimeLbl"] = dateTimeLbl
        drivernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["drivernamelbl"] = drivernamelbl
        
        rating.value = 1
        rating.isEnabled = false
        rating.tintColor = UIColor.orange
        rating.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["rating"] = rating
        
        dateTimeLbl.font = UIFont.appSemiBold(ofSize: 12)
        dateTimeLbl.textColor = .txtColor
        dateTimeLbl.textAlignment = APIHelper.appTextAlignment
        dateTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dateTimeLbl"] = dateTimeLbl
        
        rating.tintColor = .orange
        rating.isUserInteractionEnabled = false
        rating.minimumValue = 0
        rating.maximumValue = 1
        rating.value = 1
        rating.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["rating"] = rating
        
        ratingLbl.textAlignment = APIHelper.appTextAlignment
        ratingLbl.font = UIFont.appSemiBold(ofSize: 13)
        ratingLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["ratingLbl"] = ratingLbl
        
        carLbl.textColor = .themeColor
        carLbl.textAlignment = APIHelper.appTextAlignment
        carLbl.font = UIFont.appRegularFont(ofSize: 14)
        carLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["carLbl"] = carLbl
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator2"] = separator2
        
        totalFareDisLbl.textAlignment = APIHelper.appTextAlignment
        totalFareDisLbl.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        totalFareDisLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalFareDisLbl"] = totalFareDisLbl
        distancelbl.textAlignment = .right
        distancelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["distancelbl"] = distancelbl
        
        separator3.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator3"] = separator3
        
        billdetailslbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["billdetailslbl"] = billdetailslbl
        totheaderlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totheaderlbl"] = totheaderlbl
        totLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totLbl"] = totLbl
        
        zigzagImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["zigzagImgView"] = zigzagImgView
        
       
        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.backgroundColor = .clear
        layoutDict["backBtn"] = backBtn
        contentView.addSubview(backBtn)
        
        cancelBtn.isHidden = true
        cancelBtn.setTitle("text_cancel".localize().uppercased(), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        cancelBtn.setTitleColor(.themeTxtColor, for: .normal)
        cancelBtn.backgroundColor = .themeColor
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cancelBtn"] = cancelBtn
        baseView.addSubview(cancelBtn)
        
        
        
        contentView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        
        cancelBtn.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[contentView]-10-[cancelBtn]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[backBtn(30)]-20-[pickupaddrlbl(25)]-(10)-[dropupaddrlbl(25)]-(10)-[separator1(1)]-10-[driverprofilepicture(45)]-(5)-[rating(15)]-(10)-[separator2(1)]-(10)-[totalFareDisLbl(30)]-(10)-[separator3(2)]-10-[billdetailslbl(20)]-10-[totheaderlbl(20)]-10-[zigzagImgView(10)]", options: [], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [], metrics: nil, views: layoutDict))
        invoiceImgView.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor, constant: -3).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor, constant: 5).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator1]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        drivernamelbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateTimeLbl.heightAnchor.constraint(equalToConstant: 14).isActive = true
        dateTimeLbl.centerYAnchor.constraint(equalTo: drivernamelbl.topAnchor, constant: 0).isActive = true
        carLbl.topAnchor.constraint(equalTo: drivernamelbl.bottomAnchor, constant: 0).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[dateTimeLbl(140)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[drivernamelbl(23)]-(2)-[carLbl(22)]", options: [], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[driverprofilepicture(45)]-(15)-[drivernamelbl]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[driverprofilepicture(45)]-(15)-[carLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[rating(15)]-(5)-[ratingLbl(35)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingLbl.centerYAnchor.constraint(equalTo: rating.centerYAnchor, constant: 0).isActive = true
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator2]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[totalFareDisLbl]-(10)-[distancelbl(80)]-(15)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        distancelbl.centerYAnchor.constraint(equalTo: totalFareDisLbl.centerYAnchor, constant: 0).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator3]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[billdetailslbl(150)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[zigzagImgView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[totheaderlbl]-(10)-[totLbl(120)]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        cancelBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelBtn]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        baseView.bringSubviewToFront(backBtn)
        
    }
}
