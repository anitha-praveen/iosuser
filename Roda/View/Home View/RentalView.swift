//
//  RentalView.swift
//  Roda
//
//  Created by Apple on 02/05/22.
//

import UIKit
import GoogleMaps
class RentalView: UIView {
    
    let mapview = GMSMapView()
    let markerView = UIImageView()
    
    let btnBack = UIButton()
    
    let titleView = UIView()
    let txtTitle = UITextField()
    
    let locationView = UIView()
    let locationColor = UIView()
    let txtLocation = UITextField()
    let btnEditLocation = UIButton()
    
    let viewContent = UIView()
    let lblSelectPackage = UILabel()
    let viewDate = UIView()
    let imgCalender = UIImageView()
    let lblDate = UILabel()
    
    let packageCollectionvw = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let packageTypesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let stackPromo = UIStackView()
    let promoHint = UILabel()
    
    let viewFare = UIView()
    let lblFareTitle = UILabel()
    let btnFareDetail = UIButton()
    let lblAmount = UILabel()
    let lblPromoAmount = UILabel()
    
    let payPromoStackView = UIStackView()
    let btnPaymentMode = UIButton()
    let btnApplyPromo = UIButton()
    
    let stackBookRide = UIStackView()
    let btnBookNow = UIButton()
    let btnCall = UIButton()

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
        txtTitle.text = "txt_rental".localize()
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
        
        // -------------
        
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.addShadow()
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        lblSelectPackage.text = "txt_select_package".localize()
        lblSelectPackage.textAlignment = APIHelper.appTextAlignment
        lblSelectPackage.font = UIFont.appBoldFont(ofSize: 16)
        lblSelectPackage.textColor = .txtColor
        layoutDict["lblSelectPackage"] = lblSelectPackage
        lblSelectPackage.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblSelectPackage)
        
        viewDate.isUserInteractionEnabled = true
        viewDate.layer.cornerRadius = 5
        viewDate.backgroundColor = .txtColor
        layoutDict["viewDate"] = viewDate
        viewDate.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewDate)
        
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
        
        let packageLayout = UICollectionViewFlowLayout()
        packageLayout.scrollDirection = .horizontal
        packageLayout.minimumInteritemSpacing = 0
        packageCollectionvw.collectionViewLayout = packageLayout
        packageCollectionvw.alwaysBounceHorizontal = false
        packageCollectionvw.backgroundColor = .secondaryColor
        packageCollectionvw.showsHorizontalScrollIndicator = false
        layoutDict["packageCollectionvw"] = packageCollectionvw
        packageCollectionvw.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(packageCollectionvw)
        
        let packageTypeLayout = UICollectionViewFlowLayout()
        packageTypeLayout.scrollDirection = .horizontal
        packageTypesCollectionView.collectionViewLayout = packageTypeLayout
        packageTypesCollectionView.backgroundColor = .secondaryColor
        packageTypesCollectionView.showsHorizontalScrollIndicator = false
        layoutDict["packageTypesCollectionView"] = packageTypesCollectionView
        packageTypesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(packageTypesCollectionView)
        
        stackPromo.axis = .vertical
        stackPromo.distribution = .fill
        layoutDict["stackPromo"] = stackPromo
        stackPromo.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackPromo)
        
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
        viewContent.addSubview(viewFare)
        
        lblFareTitle.text = "txt_total_fare_estimation".localize()
        lblFareTitle.textColor = .txtColor
        lblFareTitle.textAlignment = APIHelper.appTextAlignment
        lblFareTitle.font = UIFont.appMediumFont(ofSize: 16)
        layoutDict["lblFareTitle"] = lblFareTitle
        lblFareTitle.translatesAutoresizingMaskIntoConstraints = false
        viewFare.addSubview(lblFareTitle)
        
       // btnFareDetail.isHidden = true
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
        
        let typeSeparator = UIView()
        typeSeparator.backgroundColor = .hexToColor("f3f3f3")
        layoutDict["typeSeparator"] = typeSeparator
        typeSeparator.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(typeSeparator)
        
        payPromoStackView.axis = .horizontal
        payPromoStackView.distribution = .fillEqually
        layoutDict["payPromoStackView"] = payPromoStackView
        payPromoStackView.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(payPromoStackView)
        
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

        
        stackBookRide.axis = .horizontal
        stackBookRide.distribution = .fill
        stackBookRide.spacing = 8
        layoutDict["stackBookRide"] = stackBookRide
        stackBookRide.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(stackBookRide)

        btnBookNow.setTitle("txt_book_now".localize(), for: .normal)
        btnBookNow.layer.cornerRadius = 5
        btnBookNow.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        btnBookNow.setTitleColor(.themeTxtColor, for: .normal)
        btnBookNow.backgroundColor = .themeColor
        layoutDict["btnBookNow"] = btnBookNow
        btnBookNow.translatesAutoresizingMaskIntoConstraints = false
        stackBookRide.addArrangedSubview(btnBookNow)
        
        btnCall.isHidden = true
        btnCall.setImage(UIImage(named: "call_black"), for: .normal)
        btnCall.layer.cornerRadius = 5
        btnCall.backgroundColor = .themeColor
        layoutDict["btnCall"] = btnCall
        btnCall.translatesAutoresizingMaskIntoConstraints = false
        stackBookRide.addArrangedSubview(btnCall)
        
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
        
        // ----------------------
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewDate]-10-[packageCollectionvw(50)]-16-[packageTypesCollectionView(80)]-10-[stackPromo][viewFare]-5-[typeSeparator(1)]-5-[payPromoStackView]-10-[stackBookRide(40)]-10-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewDate]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[lblDate]-4-|", options: [], metrics: nil, views: layoutDict))
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[imgCalender(15)]-4-[lblDate]-4-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgCalender.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imgCalender.centerYAnchor.constraint(equalTo: lblDate.centerYAnchor, constant: 0).isActive = true
        
        lblSelectPackage.centerYAnchor.constraint(equalTo: viewDate.centerYAnchor, constant: 0).isActive = true
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblSelectPackage]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[packageCollectionvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[packageTypesCollectionView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackPromo]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewFare]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[typeSeparator]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[payPromoStackView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackBookRide]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        btnCall.widthAnchor.constraint(equalToConstant: 40).isActive = true
    
        promoHint.heightAnchor.constraint(equalToConstant: 25).isActive = true
        viewFare.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblFareTitle]-5-[btnFareDetail(20)]-16-[lblAmount]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        lblFareTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        viewFare.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblAmount][lblPromoAmount]|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        lblFareTitle.centerYAnchor.constraint(equalTo: viewFare.centerYAnchor, constant: 0).isActive = true
        btnFareDetail.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnFareDetail.centerYAnchor.constraint(equalTo: lblFareTitle.centerYAnchor, constant: 0).isActive = true
        
        btnPaymentMode.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnApplyPromo.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

}


class PackageTypesCollectionCell: UICollectionViewCell {
    
    let viewContent = UIView()
    let imgview = UIImageView()
    let lblTypeName = UILabel()
    let lblMin = UILabel()
    
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
        
        lblMin.font = UIFont.appSemiBold(ofSize: 14)
        lblMin.textAlignment = .center
        layoutDict["lblMin"] = lblMin
        lblMin.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblMin)
        
        lblTypeName.font = UIFont.appSemiBold(ofSize: 14)
        lblTypeName.textAlignment = .center
        layoutDict["lblTypeName"] = lblTypeName
        lblTypeName.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTypeName)
        

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblMin][imgview(50)][lblTypeName]|", options: [], metrics: nil, views: layoutDict))

        imgview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgview.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true

        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblMin]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTypeName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        colorBackground.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorBackground.centerXAnchor.constraint(equalTo: imgview.centerXAnchor, constant: 0).isActive = true
        colorBackground.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorBackground.centerYAnchor.constraint(equalTo: imgview.centerYAnchor, constant: 0).isActive = true
    }
}
