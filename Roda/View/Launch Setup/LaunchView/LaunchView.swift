//
//  LaunchView.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit

class LaunchView: UIView {
    
   
    /*
    let logoImgView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "Taxiappznew.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: -1)
    }()
    */
   let logoImgView = UIImageView()
    
    var layoutDic = [String:AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        logoImgView.image = UIImage(named: "splash")
        logoImgView.contentMode = .scaleAspectFit
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["logoImgView"] = logoImgView
        baseView.addSubview(logoImgView)
        
       
       
        logoImgView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        logoImgView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoImgView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        logoImgView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
    }
}
