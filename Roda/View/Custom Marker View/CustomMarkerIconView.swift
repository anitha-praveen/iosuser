//
//  CustomMarkerIconView.swift
//  Taxiappz
//
//  Created by Apple on 07/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import Foundation
import UIKit
import MarqueeLabel

class PickupMarkerView: UIView {
    
    let viewContent = UIView()
    let imgView = UIImageView()
    let lblPickupAt = UILabel()
    let lblPickupAddress = MarqueeLabel()
    let btnFav = UIButton()
    
    let line = UIView()
    let imgLocation = UIImageView()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {

        viewContent.layer.cornerRadius = 5
        viewContent.backgroundColor = .secondaryColor
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewContent"] = viewContent
        addSubview(viewContent)
        
        imgView.layer.cornerRadius = 5
        imgView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        imgView.image = UIImage(named: "ic_img_marker")
        imgView.contentMode = .center
        imgView.backgroundColor = .secondThemeColor
        imgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgView"] = imgView
        viewContent.addSubview(imgView)
        
        lblPickupAt.isHidden = true
        lblPickupAt.text = "txt_pickup_at".localize()
        lblPickupAt.textColor = .hexToColor("ACB1C0")
        lblPickupAt.font = UIFont.appSemiBold(ofSize: 11)
        lblPickupAt.textAlignment = APIHelper.appTextAlignment
        lblPickupAt.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblPickupAt"] = lblPickupAt
        viewContent.addSubview(lblPickupAt)
        
        lblPickupAddress.text = "txt_your_loc".localize()
        lblPickupAddress.type = .continuous
        //lbl.speed = .duration(15)
        lblPickupAddress.animationCurve = .easeInOut
        lblPickupAddress.fadeLength = 10.0
        lblPickupAddress.leadingBuffer = 0.0
        lblPickupAddress.trailingBuffer = 20.0
        lblPickupAddress.textColor = .txtColor
        lblPickupAddress.font = UIFont.appMediumFont(ofSize: 15)
        lblPickupAddress.textAlignment = APIHelper.appTextAlignment
        lblPickupAddress.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblPickupAddress"] = lblPickupAddress
        viewContent.addSubview(lblPickupAddress)
        
        btnFav.setImage(UIImage(named: "ic_unfav"), for: .normal)
        btnFav.imageView?.contentMode = .scaleAspectFit
        btnFav.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnFav"] = btnFav
        viewContent.addSubview(btnFav)
        
        line.isHidden = true
        line.backgroundColor = .txtColor
        line.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["line"] = line
        addSubview(line)
        
        
        imgLocation.image = UIImage(named: "ic_pick_pin")
        imgLocation.contentMode = .scaleAspectFit
        imgLocation.backgroundColor = .clear
        imgLocation.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgLocation"] = imgLocation
        addSubview(imgLocation)
        
        
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent(200)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent(40)]-5-[imgLocation(30)]", options: [], metrics: nil, views: layoutDict))
        
        line.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        line.bottomAnchor.constraint(equalTo: imgLocation.centerYAnchor, constant: -5).isActive = true
        line.widthAnchor.constraint(equalToConstant: 3).isActive = true
        line.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        imgLocation.widthAnchor.constraint(equalToConstant: 26).isActive = true
        imgLocation.centerXAnchor.constraint(equalTo: line.centerXAnchor, constant: 0).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgView(40)]-5-[lblPickupAddress]-5-[btnFav(20)]-5-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgView(40)]|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblPickupAddress]-5-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        btnFav.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnFav.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        
    }
}

class PickupPointIconView: UIView {
    
    let viewContent = UIView()
    let lblPickupAt = UILabel()
    let lblPickupAddress = UILabel()
    let btnArrow = UIButton()
    let imgLocation = UIImageView()
    
    let viewEta = UIView()
    let lblEta = UILabel()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {

        viewContent.isUserInteractionEnabled = true
        viewContent.layer.cornerRadius = 5
        viewContent.backgroundColor = .secondaryColor
        viewContent.addShadow()
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewContent"] = viewContent
        addSubview(viewContent)
        
        viewEta.backgroundColor = .themeColor
        viewEta.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewEta"] = viewEta
        viewContent.addSubview(viewEta)
        
        lblEta.text = "NA".localize()
        lblEta.textAlignment = .center
        lblEta.font = UIFont.appSemiBold(ofSize: 12)
        lblEta.textColor = .secondaryColor
        lblEta.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblEta"] = lblEta
        viewEta.addSubview(lblEta)
        
        lblPickupAt.text = "txt_pickup_at".localize()
        lblPickupAt.textColor = .hexToColor("ACB1C0")
        lblPickupAt.font = UIFont.appSemiBold(ofSize: 11)
        lblPickupAt.textAlignment = APIHelper.appTextAlignment
        lblPickupAt.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblPickupAt"] = lblPickupAt
        viewContent.addSubview(lblPickupAt)
        
        lblPickupAddress.textColor = .themeTxtColor
        lblPickupAddress.font = UIFont.appMediumFont(ofSize: 12)
        lblPickupAddress.textAlignment = APIHelper.appTextAlignment
        lblPickupAddress.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblPickupAddress"] = lblPickupAddress
        viewContent.addSubview(lblPickupAddress)
        
        btnArrow.setImage(UIImage(named: "rightArr"), for: .normal)
        btnArrow.imageView?.contentMode = .scaleAspectFit
        btnArrow.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnArrow"] = btnArrow
        viewContent.addSubview(btnArrow)
        
        
        imgLocation.image = UIImage(named: "ic_destination_pin")
        imgLocation.contentMode = .scaleAspectFit
        imgLocation.backgroundColor = .clear
        imgLocation.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgLocation"] = imgLocation
        addSubview(imgLocation)
        
        
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent(180)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent(40)]-5-[imgLocation(25)]", options: [], metrics: nil, views: layoutDict))
        
        imgLocation.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imgLocation.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewEta(50)]-3-[lblPickupAt]-5-[btnArrow(20)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[lblPickupAt(15)][lblPickupAddress(20)]-3-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        viewEta.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewEta.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        
        btnArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnArrow.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        
        
        viewEta.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblEta]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewEta.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblEta]|", options: [], metrics: nil, views: layoutDict))
        
    }
}


class DropPointIconView: UIView {
    
    let viewContent = UIView()
    let lblDropAt = UILabel()
    let lblDropAddress = UILabel()
    let btnArrow = UIButton()
    let imgLocation = UIImageView()
    
    let viewDistance = UIView()
    let lblDistance = UILabel()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {

        
        viewContent.layer.cornerRadius = 5
        viewContent.backgroundColor = .secondaryColor
        viewContent.addShadow()
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewContent"] = viewContent
        addSubview(viewContent)
        
        viewDistance.isHidden = true
        viewDistance.backgroundColor = .themeColor
        viewDistance.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewDistance"] = viewDistance
        viewContent.addSubview(viewDistance)
        
        lblDistance.textAlignment = .center
        lblDistance.font = UIFont.appSemiBold(ofSize: 12)
        lblDistance.textColor = .secondaryColor
        lblDistance.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblDistance"] = lblDistance
        viewDistance.addSubview(lblDistance)
        
        lblDropAt.text = "txt_drop_at".localize()
        lblDropAt.textColor = .hexToColor("ACB1C0")
        lblDropAt.font = UIFont.appSemiBold(ofSize: 11)
        lblDropAt.textAlignment = APIHelper.appTextAlignment
        lblDropAt.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblDropAt"] = lblDropAt
        viewContent.addSubview(lblDropAt)
        
        lblDropAddress.textColor = .themeTxtColor
        lblDropAddress.font = UIFont.appMediumFont(ofSize: 12)
        lblDropAddress.textAlignment = APIHelper.appTextAlignment
        lblDropAddress.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblDropAddress"] = lblDropAddress
        viewContent.addSubview(lblDropAddress)
        
        btnArrow.setImage(UIImage(named: "rightArr"), for: .normal)
        btnArrow.imageView?.contentMode = .scaleAspectFit
        btnArrow.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnArrow"] = btnArrow
        viewContent.addSubview(btnArrow)
        
        
        imgLocation.image = UIImage(named: "ic_destination_pin")
        imgLocation.contentMode = .scaleAspectFit
        imgLocation.backgroundColor = .clear
        imgLocation.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgLocation"] = imgLocation
        addSubview(imgLocation)
        
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent(180)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent(40)]-5-[imgLocation(25)]|", options: [], metrics: nil, views: layoutDict))
        
        imgLocation.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imgLocation.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        viewDistance.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewDistance.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewDistance(50)]-3-[lblDropAt]-5-[btnArrow(20)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[lblDropAt(15)][lblDropAddress(20)]-3-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        btnArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnArrow.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0).isActive = true
        
        
        viewDistance.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblDistance]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDistance.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblDistance]|", options: [], metrics: nil, views: layoutDict))
    }
}
