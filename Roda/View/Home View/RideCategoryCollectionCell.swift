//
//  RideCategoryCollectionCell.swift
//  Roda
//
//  Created by Apple on 29/04/22.
//

import UIKit

//MARK: - Ride Category
class RideCategoryCollectionCell: UICollectionViewCell {
    
    let viewContent = UIView()
    let imgview = UIImageView()
    let lblTypeName = UILabel()
   
    let backgroundImg = UIImageView()
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
        
        
        backgroundImg.image = UIImage(named: "selected_category_layer")
        layoutDict["backgroundImg"] = backgroundImg
        backgroundImg.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(backgroundImg)
        
        //imgview.backgroundColor = .secondaryColor
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imgview)
        
        lblTypeName.font = UIFont.appRegularFont(ofSize: 15)
        lblTypeName.textAlignment = .center
        lblTypeName.textColor = .txtColor
        layoutDict["lblTypeName"] = lblTypeName
        lblTypeName.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTypeName)
        

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        
       // viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[imgview(60)][lblTypeName]-15-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[imgview(60)]", options: [], metrics: nil, views: layoutDict))

        imgview.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imgview.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true

        lblTypeName.topAnchor.constraint(equalTo: imgview.bottomAnchor, constant: -7).isActive = true
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTypeName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        backgroundImg.leadingAnchor.constraint(equalTo: imgview.leadingAnchor, constant: -10).isActive = true
        backgroundImg.trailingAnchor.constraint(equalTo: imgview.trailingAnchor, constant: 10).isActive = true
        backgroundImg.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backgroundImg.topAnchor.constraint(equalTo: imgview.centerYAnchor, constant: 0).isActive = true
   
        
        
    }
}


//MARK: - PackageList cell
class PackageListCell: UICollectionViewCell {
    
    let viewContent = UIView()
    let lblHour = UILabel()
    let lblDistance = UILabel()

    private var layoutDict = [String: AnyObject]()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
    
    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        
        viewContent.layer.cornerRadius = 8
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        lblHour.font = UIFont.appSemiBold(ofSize: 14)
        lblHour.adjustsFontSizeToFitWidth = true
        lblHour.textAlignment = .center
        lblHour.textColor = .themeTxtColor
        layoutDict["lblHour"] = lblHour
        lblHour.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblHour)
        
        
        lblDistance.font = UIFont.appRegularFont(ofSize: 11)
        lblDistance.adjustsFontSizeToFitWidth = true
        lblDistance.textAlignment = .center
        lblDistance.textColor = .hexToColor("7E7D7D")
        layoutDict["lblDistance"] = lblDistance
        lblDistance.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblDistance)
        

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
    
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblHour][lblDistance]-5-|", options: [], metrics: nil, views: layoutDict))

        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHour]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblDistance]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    
    }
}
