//
//  TripMeterVerificationView.swift
//  Roda
//
//  Created by Apple on 14/07/22.
//

import UIKit
import Kingfisher

protocol TripMeterVerificationActionDelegate: AnyObject {
     func dismissView()
}

class TripMeterVerificationView: UIView {
    
    private let viewContent:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryColor
        view.addShadow()
        return view
    }()
    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "txt_verfiy_trip_start_km".localize()
        lbl.font = UIFont.appRegularFont(ofSize: 20)
        lbl.textColor = .txtColor
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let lblHint: UILabel = {
        let lbl = UILabel()
        lbl.text = "txt_start_km_desc".localize()
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.font = UIFont.appRegularFont(ofSize: 16)
        lbl.textColor = .txtColor
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let meterImageView: UIImageView = {
        let imgview = UIImageView()
        imgview.translatesAutoresizingMaskIntoConstraints = false
        return imgview
    }()
    
    private let lblStartKm: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.appRegularFont(ofSize: 20)
        lbl.textColor = .txtColor
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let btnOkay: UIButton = {
        let btn = UIButton()
        btn.setTitle("txt_okay".localize(), for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        btn.setTitleColor(.themeTxtColor, for: .normal)
        btn.backgroundColor = .themeColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let btnClose: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_close"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func setData(Image imgStr: String, startkm: String) {
        
        lblStartKm.text = "txt_vehicle_start_km".localize() + ": " + startkm
        
        if let url = URL(string: imgStr) {
            let resource = ImageResource(downloadURL: url)
            self.meterImageView.kf.setImage(with: resource)
        }
        
    }

    var layoutDict = [String: AnyObject]()
    
    weak var actionDelegate: TripMeterVerificationActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        layoutDict["viewContent"] = viewContent
        baseView.addSubview(viewContent)
        
        layoutDict["lblTitle"] = lblTitle
        viewContent.addSubview(lblTitle)
        
        layoutDict["lblHint"] = lblHint
        viewContent.addSubview(lblHint)
        
        layoutDict["meterImageView"] = meterImageView
        viewContent.addSubview(meterImageView)
        
        layoutDict["lblStartKm"] = lblStartKm
        viewContent.addSubview(lblStartKm)
        
        btnOkay.addTarget(self, action: #selector(btnOkayPressed(_ :)), for: .touchUpInside)
        layoutDict["btnOkay"] = btnOkay
        viewContent.addSubview(btnOkay)
        
        btnClose.addTarget(self, action: #selector(btnOkayPressed(_ :)), for: .touchUpInside)
        layoutDict["btnClose"] = btnClose
        viewContent.addSubview(btnClose)
        
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[lblTitle(30)]-15-[lblHint]-15-[meterImageView(200)]-15-[lblStartKm(40)]-20-[btnOkay(40)]-20-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lblHint]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[lblStartKm]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[meterImageView]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[btnOkay]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        btnClose.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnClose.centerYAnchor.constraint(equalTo: lblTitle.centerYAnchor, constant: 0).isActive = true
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnClose(30)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }
    
    @objc func btnOkayPressed(_ sender: UIButton) {
        self.actionDelegate?.dismissView()
    }

}
