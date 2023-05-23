//
//  BookingView.swift
//  Roda
//
//  Created by Apple on 12/04/22.
//

import UIKit
import GoogleMaps
class BookingView: UIView {
    
    let btnBack = UIButton()
    let mapview = GMSMapView()
    
    let viewMyself = UIView()
    let lblMyself = UILabel()
    let arrowMyself = UIImageView()
    
    let typesContentView = UIView()
    let collectionvw = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let viewFare = UIView()
    let lblFareTitle = UILabel()
    let btnFareDetail = UIButton()
    let lblAmount = UILabel()
    let lblPromoAmount = UILabel()
    
    let stackFare = UIStackView()
    let promoHint = UILabel()
    
    let payPromoStackView = UIStackView()
    let btnPaymentMode = UIButton()
    let btnApplyPromo = UIButton()
    
    let stackBookRide = UIStackView()
    let btnBookNow = UIButton()
    let btnCall = UIButton()
    
    let btnNotes = UIButton()
    
   
    let viewAddress = UIView()
    let viewPickup = UIView()
    let pickupColor = UIView()
    let pickupTxt = UITextField()
    
    let stackvw = UIStackView()
    
    let viewStop = UIView()
    let stopColor = UIView()
    let stopTxt = UITextField()
    
    let viewDrop = UIView()
    let dropColor = UIView()
    let dropTxt = UILabel()//UITextField()
    

    let viewDate = UIView()
    let imgCalender = UIImageView()
    let lblDate = UILabel()
    
    let noServiceView = UIView()
    let imgNoService = UIImageView()
    let lblNoService = UILabel()

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
        
        btnBack.setAppImage("backDark")
        btnBack.backgroundColor = .secondaryColor
        btnBack.addShadow()
        btnBack.layer.cornerRadius = 20.0
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        viewMyself.layer.cornerRadius = 5
        viewMyself.backgroundColor = .hexToColor("f3f3f3")
        layoutDict["viewMyself"] = viewMyself
        viewMyself.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewMyself)
        
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
        
        
        viewAddress.layer.cornerRadius = 10
        viewAddress.backgroundColor = .secondaryColor
        viewAddress.addShadow()
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewAddress)
        
        
        
        layoutDict["viewPickup"] = viewPickup
        viewPickup.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(viewPickup)
        
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
        viewAddress.addSubview(addressSeparator)
        
        let addressVerticalLine = UIView()
        addressVerticalLine.backgroundColor = .hexToColor("DADADA")
        layoutDict["addressVerticalLine"] = addressVerticalLine
        addressVerticalLine.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(addressVerticalLine)
        
        viewDate.isUserInteractionEnabled = true
        viewDate.layer.cornerRadius = 5
        viewDate.backgroundColor = .txtColor
        layoutDict["viewDate"] = viewDate
        viewDate.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(viewDate)
        
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
        
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        layoutDict["stackvw"] = stackvw
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(stackvw)
        
        viewStop.isHidden = true
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
        stopTxt.isUserInteractionEnabled = false
        stopTxt.textAlignment = APIHelper.appTextAlignment
        stopTxt.textColor = .txtColor
        stopTxt.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["stopTxt"] = stopTxt
        stopTxt.translatesAutoresizingMaskIntoConstraints = false
        viewStop.addSubview(stopTxt)
        

        layoutDict["viewDrop"] = viewDrop
        viewDrop.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewDrop)
        
        dropColor.backgroundColor = .red
        layoutDict["dropColor"] = dropColor
        dropColor.translatesAutoresizingMaskIntoConstraints = false
        viewDrop.addSubview(dropColor)
        
        dropTxt.tag = 101
        dropTxt.text = "txt_your_drop_location".localize()
        dropTxt.isUserInteractionEnabled = true
        dropTxt.textAlignment = APIHelper.appTextAlignment
        dropTxt.textColor = .txtColor
        dropTxt.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["dropTxt"] = dropTxt
        dropTxt.translatesAutoresizingMaskIntoConstraints = false
        viewDrop.addSubview(dropTxt)
        
        
        
        

        // ------------TypesContent
        
        typesContentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        typesContentView.layer.cornerRadius = 20
        typesContentView.addShadow()
        typesContentView.backgroundColor = .secondaryColor
        layoutDict["typesContentView"] = typesContentView
        typesContentView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(typesContentView)
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionvw.collectionViewLayout = collectionLayout
        collectionvw.backgroundColor = .secondaryColor
        collectionvw.showsHorizontalScrollIndicator = false
        layoutDict["collectionvw"] = collectionvw
        collectionvw.translatesAutoresizingMaskIntoConstraints = false
        typesContentView.addSubview(collectionvw)
        
        stackFare.axis = .vertical
        stackFare.distribution = .fill
        layoutDict["stackFare"] = stackFare
        stackFare.translatesAutoresizingMaskIntoConstraints = false
        typesContentView.addSubview(stackFare)
        
        promoHint.isHidden = true
        promoHint.text = "txt_promo_not_applicable_for_this_type".localize()
        promoHint.textColor = .txtColor
        promoHint.textAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .right:.left
        promoHint.font = UIFont.appRegularFont(ofSize: 12)
        layoutDict["promoHint"] = promoHint
        promoHint.translatesAutoresizingMaskIntoConstraints = false
        stackFare.addArrangedSubview(promoHint)
        
        layoutDict["viewFare"] = viewFare
        viewFare.translatesAutoresizingMaskIntoConstraints = false
        typesContentView.addSubview(viewFare)
        
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
        lblAmount.font = UIFont.appSemiBold(ofSize: 25)
        layoutDict["lblAmount"] = lblAmount
        lblAmount.translatesAutoresizingMaskIntoConstraints = false
        viewFare.addSubview(lblAmount)
        
        lblPromoAmount.isHidden = true
        lblPromoAmount.textColor = .txtColor
        lblPromoAmount.textAlignment = APIHelper.appLanguageDirection == .directionLeftToRight ? .right:.left
        lblPromoAmount.font = UIFont.appSemiBold(ofSize: 25)
        layoutDict["lblPromoAmount"] = lblPromoAmount
        lblPromoAmount.translatesAutoresizingMaskIntoConstraints = false
        viewFare.addSubview(lblPromoAmount)
        
        let typeSeparator = UIView()
        typeSeparator.backgroundColor = .hexToColor("f3f3f3")
        layoutDict["typeSeparator"] = typeSeparator
        typeSeparator.translatesAutoresizingMaskIntoConstraints = false
        typesContentView.addSubview(typeSeparator)
        
        payPromoStackView.axis = .horizontal
        payPromoStackView.distribution = .fillEqually
        layoutDict["payPromoStackView"] = payPromoStackView
        payPromoStackView.translatesAutoresizingMaskIntoConstraints = false
        typesContentView.addSubview(payPromoStackView)
        
        if APIHelper.appLanguageDirection == .directionRightToLeft  {
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
        
        btnApplyPromo.addBorder(edges: .left, colour: .hexToColor("f3f3f3"), thickness: 1)
        if APIHelper.appLanguageDirection == .directionRightToLeft {
            btnApplyPromo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        } else {
            btnApplyPromo.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
        
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
        typesContentView.addSubview(stackBookRide)

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
        
        btnNotes.isHidden = true
        btnNotes.setImage(UIImage(named: "ic_note"), for: .normal)
        btnNotes.layer.cornerRadius = 5
        btnNotes.backgroundColor = .themeColor
        layoutDict["btnNotes"] = btnNotes
        btnNotes.translatesAutoresizingMaskIntoConstraints = false
       // stackBookRide.addArrangedSubview(btnNotes)
        
        noServiceView.isHidden = true
        noServiceView.layer.cornerRadius = 30
        noServiceView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        noServiceView.backgroundColor = .secondaryColor
        layoutDict["noServiceView"] = noServiceView
        noServiceView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(noServiceView)
        
        imgNoService.image = UIImage(named: "nonServiceZone")
        imgNoService.contentMode = .scaleAspectFit
        layoutDict["imgNoService"] = imgNoService
        imgNoService.translatesAutoresizingMaskIntoConstraints = false
        noServiceView.addSubview(imgNoService)
        
        lblNoService.text = "txt_no_service_available_pls_tryAgain".localize()
        lblNoService.numberOfLines = 0
        lblNoService.lineBreakMode = .byWordWrapping
        lblNoService.textColor = .txtColor
        lblNoService.textAlignment = .center
        lblNoService.font = UIFont.appSemiBold(ofSize: 25)
        layoutDict["lblNoService"] = lblNoService
        lblNoService.translatesAutoresizingMaskIntoConstraints = false
        noServiceView.addSubview(lblNoService)
        
        // --------------------
        
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: typesContentView.topAnchor, constant: 20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(40)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnBack(40)]", options: [], metrics: nil, views: layoutDict))
        
        
        viewMyself.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewMyself]-10-|", options: [], metrics: nil, views: layoutDict))
        
        viewMyself.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblMyself]-8-[arrowMyself(15)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewMyself.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblMyself(30)]-5-|", options: [], metrics: nil, views: layoutDict))
        arrowMyself.heightAnchor.constraint(equalToConstant: 15).isActive = true
        arrowMyself.centerYAnchor.constraint(equalTo: lblMyself.centerYAnchor, constant: 0).isActive = true
        
         
        
        typesContentView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[typesContentView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        typesContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[collectionvw(100)]-10-[stackFare][viewFare]-5-[typeSeparator(1)]-5-[payPromoStackView]-10-[stackBookRide(48)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        typesContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        typesContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackFare]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        typesContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewFare]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        typesContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[typeSeparator]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        typesContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[payPromoStackView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        typesContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackBookRide]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        promoHint.heightAnchor.constraint(equalToConstant: 25).isActive = true
       
        viewFare.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblFareTitle]-5-[btnFareDetail(20)]-16-[lblAmount]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        lblFareTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        viewFare.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblAmount][lblPromoAmount]|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        lblFareTitle.centerYAnchor.constraint(equalTo: viewFare.centerYAnchor, constant: 0).isActive = true
        btnFareDetail.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnFareDetail.centerYAnchor.constraint(equalTo: lblFareTitle.centerYAnchor, constant: 0).isActive = true
        
       
        //------------------
        
        btnPaymentMode.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnApplyPromo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // -----------------Book now
        
        btnCall.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        btnNotes.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        // -------------------viewAddress
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewAddress]-10-[typesContentView]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[viewAddress]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewPickup]-8-[addressSeparator(1)]-8-[stackvw]-8-|", options: [], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[viewPickup]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[stackvw]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[addressSeparator]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewDate.centerYAnchor.constraint(equalTo: addressSeparator.centerYAnchor, constant: 0).isActive = true
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewDate]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[lblDate]-4-|", options: [], metrics: nil, views: layoutDict))
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[imgCalender(15)]-4-[lblDate]-4-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgCalender.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imgCalender.centerYAnchor.constraint(equalTo: lblDate.centerYAnchor, constant: 0).isActive = true
        
      
        viewPickup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[pickupColor(10)]-10-[pickupTxt]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewPickup.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pickupTxt(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pickupColor.centerYAnchor.constraint(equalTo: pickupTxt.centerYAnchor, constant: 0).isActive = true
        
        viewDrop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[dropColor(10)]-10-[dropTxt]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDrop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dropTxt(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        dropColor.centerYAnchor.constraint(equalTo: dropTxt.centerYAnchor, constant: 0).isActive = true
        
        viewStop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[stopColor(10)]-10-[stopTxt]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewStop.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stopTxt(30)]|", options: [], metrics: nil, views: layoutDict))
        stopColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stopColor.centerYAnchor.constraint(equalTo: stopTxt.centerYAnchor, constant: 0).isActive = true
        
        
        addressVerticalLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        addressVerticalLine.centerXAnchor.constraint(equalTo: pickupColor.centerXAnchor, constant: 0).isActive = true
        addressVerticalLine.topAnchor.constraint(equalTo: pickupColor.bottomAnchor, constant: 0).isActive = true
        addressVerticalLine.bottomAnchor.constraint(equalTo: dropColor.topAnchor, constant: 0).isActive = true
        
        // --------------No service view
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[noServiceView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        noServiceView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        noServiceView.heightAnchor.constraint(equalTo: typesContentView.heightAnchor, constant: 0).isActive = true
        
        noServiceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[imgNoService(100)]-20-[lblNoService]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblNoService]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgNoService.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgNoService.centerXAnchor.constraint(equalTo: noServiceView.centerXAnchor, constant: 0).isActive = true
        
    }
    
}



class RideTypesCollectionCell: UICollectionViewCell {
    
    let viewContent = UIView()
    let lblEtaMin = UILabel()
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
        
        lblEtaMin.font = UIFont.appSemiBold(ofSize: 14)
        lblEtaMin.textAlignment = .center
        lblEtaMin.textColor = .txtColor
        layoutDict["lblEtaMin"] = lblEtaMin
        lblEtaMin.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblEtaMin)
        
        
        lblTypeName.textAlignment = .center
        lblTypeName.textColor = .txtColor
        layoutDict["lblTypeName"] = lblTypeName
        lblTypeName.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTypeName)
        

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblEtaMin][imgview(50)][lblTypeName]-5-|", options: [], metrics: nil, views: layoutDict))

        imgview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgview.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true

        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblEtaMin]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTypeName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
      
        colorBackground.widthAnchor.constraint(equalToConstant: 50).isActive = true
        colorBackground.centerXAnchor.constraint(equalTo: imgview.centerXAnchor, constant: 0).isActive = true
        colorBackground.heightAnchor.constraint(equalToConstant: 50).isActive = true
        colorBackground.centerYAnchor.constraint(equalTo: imgview.centerYAnchor, constant: 0).isActive = true
        
    }
}
