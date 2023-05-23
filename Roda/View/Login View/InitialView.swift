//
//  InitialView.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit


class Initialview: UIView {
    
    let headerlbl = UILabel()
    
    let viewPhoneNumber = UIView()
    let viewCode = UIView()
    let imgCountry = UIImageView()
    let lblCountry = UILabel()
    let lineView = UIView()
    let phonenumberTfd = UITextField()
    
    var btnLogin = UIButton()
    
    var termsAndConditionView = UITextView()
    
    
    let termsAndConditionsURL = "http://www.example.com/terms";
    let privacyURL = "http://www.example.com/privacy";
    
    var layoutDic = [String:AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        

        headerlbl.numberOfLines = 0
        headerlbl.lineBreakMode = .byWordWrapping
        headerlbl.font = UIFont.appBoldFont(ofSize: 22)
        headerlbl.textColor = .txtColor
        headerlbl.text = "txt_enter_phone_for_verification".localize()
        headerlbl.textAlignment = APIHelper.appTextAlignment
        headerlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerlbl"] = headerlbl
        baseView.addSubview(headerlbl)
        
        
        viewPhoneNumber.isUserInteractionEnabled = true
        viewPhoneNumber.backgroundColor = .secondaryColor
        viewPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewPhoneNumber"] = viewPhoneNumber
        baseView.addSubview(viewPhoneNumber)
        
       
        viewCode.addBorder(edges: .bottom, colour: .txtColor, thickness: 1)
        viewCode.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewCode"] = viewCode
        self.viewPhoneNumber.addSubview(viewCode)
        
        imgCountry.isHidden = true
        imgCountry.kf.indicatorType = .activity
        imgCountry.contentMode = .scaleAspectFit
        imgCountry.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imgCountry"] = imgCountry
       // self.viewCode.addSubview(imgCountry)
        
        lblCountry.textColor = .txtColor
        lblCountry.font = UIFont.appRegularFont(ofSize: 15)
        lblCountry.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblCountry"] = lblCountry
        self.viewCode.addSubview(lblCountry)
        
        lineView.addBorder(edges: .bottom, colour: .txtColor, thickness: 1)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lineView"] = lineView
        self.viewPhoneNumber.addSubview(lineView)
        
        
        phonenumberTfd.backgroundColor = .secondaryColor
        phonenumberTfd.font = UIFont.appRegularFont(ofSize: 15)
        phonenumberTfd.placeholder = "hint_phone_number".localize()
        phonenumberTfd.textAlignment = APIHelper.appTextAlignment
        phonenumberTfd.keyboardType = .phonePad
        phonenumberTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["phonenumberTfd"] = phonenumberTfd
        self.lineView.addSubview(phonenumberTfd)
        
        
        btnLogin.setTitle("txt_send_otp".localize().uppercased(), for: .normal)
        btnLogin.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnLogin.setTitleColor(.themeTxtColor, for: .normal)
        btnLogin.backgroundColor = .themeColor
        btnLogin.layer.cornerRadius = 5
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnLogin"] = btnLogin
        baseView.addSubview(btnLogin)
       
    
        let str = "txt_terms_complete".localize()
        let attributedString = NSMutableAttributedString(string: str)
        var foundRange = attributedString.mutableString.range(of: "txt_terms_of_use".localize())
        attributedString.addAttribute(NSAttributedString.Key.link, value: termsAndConditionsURL, range: foundRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: foundRange)
        foundRange = attributedString.mutableString.range(of: "txt_privacy_policy".localize())
        attributedString.addAttribute(NSAttributedString.Key.link, value: privacyURL, range: foundRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: foundRange)
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.txtColor,
            //NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        termsAndConditionView.linkTextAttributes = linkAttributes
        termsAndConditionView.attributedText = attributedString
        termsAndConditionView.textAlignment = .center
        termsAndConditionView.textColor = .hexToColor("#636363")
        termsAndConditionView.font = UIFont.appRegularFont(ofSize: 16)
        termsAndConditionView.allowsEditingTextAttributes = false
        termsAndConditionView.isEditable = false
        termsAndConditionView.isScrollEnabled = false
        termsAndConditionView.sizeToFit()
        termsAndConditionView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["termsAndConditionView"] = termsAndConditionView
        baseView.addSubview(termsAndConditionView)
        
       
        self.headerlbl.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerlbl(>=30)]-(25)-[viewPhoneNumber(50)]-35-[termsAndConditionView]-15-[btnLogin(50)]", options: [], metrics: nil, views: layoutDic))
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(21)-[headerlbl]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
     
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[viewPhoneNumber]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnLogin]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[termsAndConditionView]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        self.viewPhoneNumber.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[viewCode]-(10)-[lineView]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewCode.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        self.lineView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[phonenumberTfd]-5-|", options: [], metrics: nil, views: layoutDic))
        self.lineView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[phonenumberTfd]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        self.viewPhoneNumber.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView]|", options: [], metrics: nil, views: layoutDic))
        self.viewPhoneNumber.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewCode]|", options: [], metrics: nil, views: layoutDic))
        
        
        self.viewCode.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblCountry]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))//[imgCountry(25)]-5-
        
//        imgCountry.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        imgCountry.centerYAnchor.constraint(equalTo: viewCode.centerYAnchor, constant: 0).isActive = true
        lblCountry.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lblCountry.centerYAnchor.constraint(equalTo: viewCode.centerYAnchor, constant: 0).isActive = true
       
        
        
    }

}


extension UITapGestureRecognizer {

func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    let textStorage = NSTextStorage(attributedString: label.attributedText!)
    
    // Configure layoutManager and textStorage
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    let labelSize = label.bounds.size
    textContainer.size = labelSize
    
    // Find the tapped character location and compare it to the specified range
    let locationOfTouchInLabel = self.location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,y: locationOfTouchInLabel.y - textContainerOffset.y)
    var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    indexOfCharacter = indexOfCharacter + 4
    return NSLocationInRange(indexOfCharacter, targetRange)
}

}
