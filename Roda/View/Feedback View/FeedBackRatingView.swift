//
//  FeedBackRatingView.swift
//  Taxiappz
//
//  Created by Apple on 18/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import HCSStarRatingView
import GoogleMaps
class FeedBackRatingView: UIView {
    
    
    let titleView = UIView()
    let titleLbl = UILabel()

    let viewDriver = UIView()
    let imgProfile = UIImageView()
    let lblDriverName = UILabel()
    let lblCarNum = UILabel()
    let lblCarType = UILabel()
    
    let lblHint = UILabel()
    
    let lblHowisTrip = UILabel()
    let rating = HCSStarRatingView()
    
    let questionView = UIView()
    let tblQuestions = UITableView()
    
    
    let btnSubmit = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .hexToColor("f3f3f3")
        
        titleView.layer.cornerRadius = 10
       // titleView.addShadow()
        titleView.backgroundColor = .secondaryColor
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "txt_rating".localize().uppercased()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = .center
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        viewDriver.addShadow()
        viewDriver.backgroundColor = .secondaryColor
        viewDriver.layer.cornerRadius = 8
        layoutDict["viewDriver"] = viewDriver
        viewDriver.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewDriver)
        
        
        imgProfile.image = UIImage(named: "profilePlaceHolder")
        imgProfile.backgroundColor = .hexToColor("ACB1C0")
        imgProfile.layer.cornerRadius = 8
        imgProfile.clipsToBounds = true
        layoutDict["imgProfile"] = imgProfile
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        viewDriver.addSubview(imgProfile)
        
        lblDriverName.textColor = .txtColor
        lblDriverName.font = UIFont.appMediumFont(ofSize: 25)
        lblDriverName.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblDriverName"] = lblDriverName
        lblDriverName.translatesAutoresizingMaskIntoConstraints = false
        viewDriver.addSubview(lblDriverName)
        
        
        lblCarNum.textColor = .hexToColor("525252")
        lblCarNum.textAlignment = APIHelper.appTextAlignment
        lblCarNum.font = UIFont.appMediumFont(ofSize: 16)
        layoutDict["lblCarNum"] = lblCarNum
        lblCarNum.translatesAutoresizingMaskIntoConstraints = false
        viewDriver.addSubview(lblCarNum)
        
        lblCarType.textColor = .hexToColor("525252")
        lblCarType.textAlignment = APIHelper.appTextAlignment
        lblCarType.font = UIFont.appMediumFont(ofSize: 14)
        layoutDict["lblCarType"] = lblCarType
        lblCarType.translatesAutoresizingMaskIntoConstraints = false
        viewDriver.addSubview(lblCarType)
        
        lblHint.textAlignment = .center
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .hexToColor("606060")
        lblHint.font = UIFont.appRegularFont(ofSize: 14)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHint)
    
        let ratingContent = UIView()
        ratingContent.backgroundColor = .secondaryColor
        ratingContent.layer.cornerRadius = 8
        ratingContent.addShadow()
        layoutDict["ratingContent"] = ratingContent
        ratingContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(ratingContent)
        
        lblHowisTrip.textAlignment = .center
        lblHowisTrip.textColor = .hexToColor("2F2E2E")
        lblHowisTrip.font = UIFont.appBoldFont(ofSize: 18)
        layoutDict["lblHowisTrip"] = lblHowisTrip
        lblHowisTrip.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(lblHowisTrip)
        
        
        rating.value = 5
        rating.allowsHalfStars = true
        rating.accurateHalfStars = true
        rating.isUserInteractionEnabled = false
        rating.tintColor = .themeColor
        layoutDict["rating"] = rating
        rating.translatesAutoresizingMaskIntoConstraints = false
        ratingContent.addSubview(rating)
        
        
        questionView.backgroundColor = .secondaryColor
        questionView.layer.cornerRadius = 8
        questionView.addShadow()
        layoutDict["questionView"] = questionView
        questionView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(questionView)
        
        tblQuestions.showsVerticalScrollIndicator = false
        tblQuestions.alwaysBounceVertical = false
        layoutDict["tblQuestions"] = tblQuestions
        tblQuestions.translatesAutoresizingMaskIntoConstraints = false
        questionView.addSubview(tblQuestions)
      
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnSubmit.setTitleColor(.themeTxtColor, for: .normal)
        btnSubmit.backgroundColor = .themeColor
        layoutDict["btnSubmit"] = btnSubmit
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnSubmit)
        
        
        // -------------Title
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[titleView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[titleLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // --------------
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-10-[viewDriver]-10-[lblHint]-10-[ratingContent]-10-[questionView]-10-[btnSubmit(45)]", options: [], metrics: nil, views: layoutDict))
        
        

        // --------------Driver View
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[viewDriver]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewDriver.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[imgProfile(80)]-12-[lblDriverName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDriver.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[imgProfile(80)]-8-|", options: [], metrics: nil, views: layoutDict))
        viewDriver.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblDriverName(30)][lblCarNum(25)][lblCarType(25)]-8-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        // -------------------
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[lblHint]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // ---------------------
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[ratingContent]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblHowisTrip(30)]-8-[rating(30)]-8-|", options: [], metrics: nil, views: layoutDict))
       
         ratingContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHowisTrip]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
         
         rating.widthAnchor.constraint(equalToConstant: 250).isActive = true
         rating.centerXAnchor.constraint(equalTo: ratingContent.centerXAnchor, constant: 0).isActive = true
         
        
        // --------------------
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[questionView]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        questionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[tblQuestions]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        questionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[tblQuestions]-5-|", options: [], metrics: nil, views: layoutDict))
        
        
        // ------------------
        
        btnSubmit.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[btnSubmit]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

       
    }
}

class FeedbackQuestionCell: UITableViewCell {
    
    let lblQuestion = UILabel()
    let btnLike = UIButton()
    let btnDislike = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        
        self.selectionStyle = .none
        
        lblQuestion.numberOfLines = 0
        lblQuestion.lineBreakMode = .byWordWrapping
        lblQuestion.textAlignment = APIHelper.appTextAlignment
        lblQuestion.textColor = .txtColor
        lblQuestion.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblQuestion"] = lblQuestion
        lblQuestion.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblQuestion)
        
        btnLike.isSelected = true
        btnLike.setImage(UIImage(named: "ic_like"), for: .selected)
        btnLike.setImage(UIImage(named: "ic_like_deselect"), for: .normal)
        layoutDict["btnLike"] = btnLike
        btnLike.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnLike)
        
        btnDislike.isSelected = false
        btnDislike.setImage(UIImage(named: "ic_dislike"), for: .selected)
        btnDislike.setImage(UIImage(named: "ic_dislike_deselect"), for: .normal)
        layoutDict["btnDislike"] = btnDislike
        btnDislike.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnDislike)
        
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[lblQuestion(>=50)]-12-|", options: [], metrics: nil, views: layoutDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblQuestion]-10-[btnLike(30)]-20-[btnDislike(30)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        btnLike.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnLike.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        btnDislike.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnDislike.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
    }
}


/*
class FeedBackRatingView: UIView {
    
    
    let lblHowisTrip = UILabel()
    let lblHint = UILabel()
    let lblRateMode = UILabel()
    let imgRateMode = UIImageView()
    let slider = UISlider()
    let commentView = UITextView()
    let btnSubmit = UIButton()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .hexToColor("FFBBBB")
        
        lblHowisTrip.textAlignment = .center
        lblHowisTrip.textColor = UIColor(red: 34/255.0, green: 43/255.0, blue: 69/255.0, alpha: 1)
        lblHowisTrip.font = UIFont.appBoldFont(ofSize: 20)
        layoutDict["lblHowisTrip"] = lblHowisTrip
        lblHowisTrip.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHowisTrip)
        
        lblHint.textAlignment = .center
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .gray
        lblHint.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHint)
        
        lblRateMode.text = "Very Bad"
        lblRateMode.textAlignment = .center
        lblRateMode.textColor = .hexToColor("2F2E2E")
        lblRateMode.font = UIFont.appBoldFont(ofSize: 35)
        layoutDict["lblRateMode"] = lblRateMode
        lblRateMode.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblRateMode)
        
        imgRateMode.image = UIImage(named: "img_rating_very_bad")
        imgRateMode.contentMode = .scaleAspectFit
        layoutDict["imgRateMode"] = imgRateMode
        imgRateMode.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(imgRateMode)
        
        slider.setThumbImage(UIImage(named: "img_slider"), for: .normal)
        slider.maximumValue = 5
        slider.minimumValue = 1
        layoutDict["slider"] = slider
        slider.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(slider)
        
        commentView.layer.borderColor = UIColor.gray.cgColor
        commentView.layer.borderWidth = 0.5
        commentView.textColor = .gray
        commentView.layer.cornerRadius = 5
        commentView.font = UIFont.appFont(ofSize: 14)
        commentView.textAlignment = APIHelper.appTextAlignment
        //commentView.addShadow()
        commentView.backgroundColor = UIColor(red: 228/255.0, green: 233/255.0, blue: 242/255.0, alpha: 0.5)
        layoutDict["commentView"] = commentView
        commentView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(commentView)
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnSubmit.setTitleColor(.themeColor, for: .normal)
        btnSubmit.backgroundColor = .txtColor
        layoutDict["btnSubmit"] = btnSubmit
        btnSubmit.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnSubmit)
        
        lblHowisTrip.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        btnSubmit.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblHowisTrip(30)]-8-[lblHint]-20-[lblRateMode(40)]-10-[imgRateMode]-20-[slider(30)]-30-[commentView(130)]-(15)-[btnSubmit(45)]", options: [], metrics: nil, views: layoutDict))
        lblHint.setContentHuggingPriority(.defaultHigh, for: .vertical)
      
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHowisTrip]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblHint]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblRateMode]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        imgRateMode.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imgRateMode.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[slider]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[commentView]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnSubmit]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    
   
    }
}

extension UIView {
   func createDashedLine(width: CGFloat, color: CGColor) {
      let caShapeLayer = CAShapeLayer()
      caShapeLayer.strokeColor = color
      caShapeLayer.lineWidth = width
      caShapeLayer.lineDashPattern = [12,16]
      let cgPath = CGMutablePath()
      let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
      cgPath.addLines(between: cgPoint)
      caShapeLayer.path = cgPath
      layer.addSublayer(caShapeLayer)
   }
}
*/
