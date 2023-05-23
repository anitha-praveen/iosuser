//
//  AvailablePromoCell.swift
//  Taxiappz
//
//  Created by Apple on 10/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit

class AvailablePromoCell: UITableViewCell {
    
    let viewContent = UIView()
    let viewPromo = CouponView()
    let imgPromo = UIImageView()
    let lblPromo = UILabel()
    let lblShortDesc = UILabel()
    let lblDescription = UILabel()
    
    let lblOfferAmount = UILabel()
    
    let applyBtn = UIButton()
    
  
    var applyAction:(()->Void)?

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
        
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        viewPromo.backgroundColor = .clear
        layoutDict["viewPromo"] = viewPromo
        viewPromo.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewPromo)
        
        imgPromo.contentMode = .scaleAspectFit
        imgPromo.image = UIImage(named: "Invoiceclock")
        layoutDict["imgPromo"] = imgPromo
        imgPromo.translatesAutoresizingMaskIntoConstraints = false
        viewPromo.addSubview(imgPromo)
        
        lblPromo.textAlignment = APIHelper.appTextAlignment
        lblPromo.textColor = .txtColor
        lblPromo.font = UIFont.appSemiBold(ofSize: 14)
        layoutDict["lblPromo"] = lblPromo
        lblPromo.translatesAutoresizingMaskIntoConstraints = false
        viewPromo.addSubview(lblPromo)
        
        applyBtn.addTarget(self, action: #selector(btnApplyPressed(_ :)), for: .touchUpInside)
        applyBtn.setTitle("txt_Apply".localize().uppercased(), for: .normal)
        applyBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        applyBtn.setTitleColor(UIColor.themeColor.withAlphaComponent(0.3), for: .disabled)
        applyBtn.setTitleColor(UIColor.themeColor, for: .normal)
        applyBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["applyBtn"] = applyBtn
        viewContent.addSubview(applyBtn)
        
        lblShortDesc.textAlignment = APIHelper.appTextAlignment
        lblShortDesc.textColor = .txtColor
        lblShortDesc.font = UIFont.appSemiBold(ofSize: 14)
        layoutDict["lblShortDesc"] = lblShortDesc
        lblShortDesc.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblShortDesc)
        
        lblOfferAmount.textAlignment = APIHelper.appTextAlignment
        lblOfferAmount.textColor = .themeColor
        lblOfferAmount.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["lblOfferAmount"] = lblOfferAmount
        lblOfferAmount.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblOfferAmount)
        
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.textAlignment = APIHelper.appTextAlignment
        lblDescription.textColor = .gray
        lblDescription.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblDescription"] = lblDescription
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblDescription)
        
      
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[viewContent]-10-|", options: [], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[viewContent]-10-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[viewPromo]", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[applyBtn]-10-|", options: [], metrics: nil, views: layoutDict))
        viewPromo.setContentHuggingPriority(.defaultLow, for: .horizontal)
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[viewPromo]-8-[lblShortDesc(30)][lblOfferAmount(25)]-8-[lblDescription]-5-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblShortDesc]-10-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblOfferAmount]-10-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblDescription]-10-|", options: [], metrics: nil, views: layoutDict))
        
        viewPromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[imgPromo(30)]-30-[lblPromo]-30-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        viewPromo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[imgPromo(30)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        applyBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        applyBtn.centerYAnchor.constraint(equalTo: viewPromo.centerYAnchor, constant: 0).isActive = true
        

    }
    
    @objc func btnApplyPressed(_ sender: UIButton) {
        if let action = self.applyAction {
            action()
        }
    }

}


class CouponView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
    
    func setupViews() {
        
        let line = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: 52.5, y: 5))
        path.addLine(to: CGPoint(x: 55, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: 55, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: 52.5, y: self.frame.size.height-5))
        path.addLine(to: CGPoint(x: 50, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        path.close()
        UIColor.hexToColor("#98f086").setFill()
        path.fill()
        line.path = path.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.strokeColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(line)
    }
}
