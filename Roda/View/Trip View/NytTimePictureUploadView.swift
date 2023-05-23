//
//  NytTimePictureUploadView.swift
//  Roda
//
//  Created by Apple on 07/07/22.
//

import UIKit

class NytTimePictureUploadView: UIView {
    
    let uploadPhotoView = UIView()
    let lblUploadPhotoTitle = UILabel()
    let lblUploadPhotoHint = UILabel()
    
    let stackvw = UIStackView()
    let driverImage = UIImageView()
    
    let stackBtns = UIStackView()
    let btnRetake = UIButton()
    let btnProceed = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        uploadPhotoView.layer.cornerRadius = 20
        uploadPhotoView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        uploadPhotoView.backgroundColor = .secondaryColor
        layoutDict["uploadPhotoView"] = uploadPhotoView
        uploadPhotoView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(uploadPhotoView)
        
        
        lblUploadPhotoTitle.text = "txt_snap_title".localize()
        lblUploadPhotoTitle.textAlignment = APIHelper.appTextAlignment
        lblUploadPhotoTitle.textColor = .txtColor
        lblUploadPhotoTitle.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblUploadPhotoTitle"] = lblUploadPhotoTitle
        lblUploadPhotoTitle.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoView.addSubview(lblUploadPhotoTitle)
        
        lblUploadPhotoHint.text = "txt_snap_desc_user".localize()
        lblUploadPhotoHint.numberOfLines = 0
        lblUploadPhotoHint.lineBreakMode = .byWordWrapping
        lblUploadPhotoHint.textAlignment = APIHelper.appTextAlignment
        lblUploadPhotoHint.textColor = .txtColor
        lblUploadPhotoHint.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblUploadPhotoHint"] = lblUploadPhotoHint
        lblUploadPhotoHint.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoView.addSubview(lblUploadPhotoHint)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        layoutDict["stackvw"] = stackvw
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoView.addSubview(stackvw)
        
        driverImage.image = UIImage(named: "profilePlaceHolder")
        driverImage.contentMode = .scaleAspectFit
        layoutDict["driverImage"] = driverImage
        driverImage.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(driverImage)
        
        stackBtns.axis = .horizontal
        stackBtns.distribution = .fillEqually
        stackBtns.spacing = 8
        layoutDict["stackBtns"] = stackBtns
        stackBtns.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoView.addSubview(stackBtns)
        
        btnRetake.setTitle("txt_retake".localize(), for: .normal)
        btnRetake.layer.cornerRadius = 8
        btnRetake.layer.borderWidth = 1
        btnRetake.layer.borderColor = UIColor.themeColor.cgColor
        btnRetake.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnRetake.setTitleColor(.txtColor, for: .normal)
        btnRetake.backgroundColor = .secondaryColor
        layoutDict["btnRetake"] = btnRetake
        btnRetake.translatesAutoresizingMaskIntoConstraints = false
        stackBtns.addArrangedSubview(btnRetake)
        
        btnProceed.setTitle("txt_proceed".localize(), for: .normal)
        btnProceed.layer.cornerRadius = 8
        btnProceed.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnProceed.setTitleColor(.themeTxtColor, for: .normal)
        btnProceed.backgroundColor = .themeColor
        layoutDict["btnProceed"] = btnProceed
        btnProceed.translatesAutoresizingMaskIntoConstraints = false
        stackBtns.addArrangedSubview(btnProceed)
        
        
        uploadPhotoView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[uploadPhotoView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        uploadPhotoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[lblUploadPhotoTitle(30)]-12-[lblUploadPhotoHint]-15-[stackvw]-25-[stackBtns]-25-|", options: [], metrics: nil, views: layoutDict))
        
        uploadPhotoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblUploadPhotoTitle]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        uploadPhotoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblUploadPhotoHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        stackvw.widthAnchor.constraint(equalToConstant: 90).isActive = true
        stackvw.centerXAnchor.constraint(equalTo: uploadPhotoView.centerXAnchor, constant: 0).isActive = true
        
        driverImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        uploadPhotoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackBtns]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        btnProceed.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnRetake.heightAnchor.constraint(equalToConstant: 40).isActive = true
       
    }

}
