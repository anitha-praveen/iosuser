//
//  NKActivityLoader.swift
//  Taxiappz
//
//  Created by Apple on 15/12/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

public final class NKActivityLoader {
    
    static let sharedInstance = NKActivityLoader()
    
    private let restoreIdentifier = "restoreidentifier"
    
    private let messageLbl: UILabel = {
        let messageLbl = UILabel()
        messageLbl.numberOfLines = 0
        messageLbl.lineBreakMode = .byWordWrapping
        messageLbl.textAlignment = .center
        messageLbl.textColor = .secondaryColor
        messageLbl.font = .systemFont(ofSize: 15)
        messageLbl.translatesAutoresizingMaskIntoConstraints = false
        return messageLbl
    }()
    
    
    
//    private let logoImgView: UIImageView = {
//        let imgview = UIImageView()
//        imgview.contentMode = .scaleAspectFit
//        imgview.image = UIImage(named: "loader_img")
//        return imgview
//    }()
    
    private init() {
    }
    
    deinit {
    }
    
    public func show(message msg: String? = nil) {
        
        let containerView = UIView(frame: UIScreen.main.bounds)
        containerView.restorationIdentifier = restoreIdentifier
        containerView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.8)
        
        let logoImgView: UIImageView = {

            guard let gifImage = try? UIImage(gifName: "themeLoader.gif") else {
                return UIImageView()
            }

            return UIImageView(gifImage: gifImage, loopCount: -1)
        }()
        
        logoImgView.startAnimatingGif()
        logoImgView.layer.masksToBounds = false
        logoImgView.layer.cornerRadius = 25
        logoImgView.clipsToBounds = true
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(logoImgView)

        
        messageLbl.text = msg
        containerView.addSubview(messageLbl)
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[logoImgView(50)]-16-[messageLbl]", options: [], metrics: nil, views: ["messageLbl":messageLbl,"logoImgView":logoImgView]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[messageLbl]-60-|", options: [], metrics: nil, views: ["messageLbl":messageLbl]))
        
        logoImgView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoImgView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        logoImgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
       
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        keyWindow.addSubview(containerView)
        
        
    }
    
    public func hide() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
       // logoImgView.stopAnimating()
        for item in keyWindow.subviews
            where item.restorationIdentifier == restoreIdentifier {
            item.removeFromSuperview()
        }
    }

}


