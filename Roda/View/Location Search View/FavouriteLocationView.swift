//
//  FavouriteLocationView.swift
//  Roda
//
//  Created by Apple on 14/04/22.
//

import UIKit

class FavouriteLocationView: UIView {

    private let viewContent = UIView()
    private let lblSaveFavourite = UILabel()
    let lblAddress = UILabel()
    
    let btnHome = UIButton()
    let btnWork = UIButton()
    let btnOthers = UIButton()
    let btnCancel = UIButton()
    let btnSave = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        viewContent.layer.cornerRadius = 20
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        lblSaveFavourite.text = "txt_save_as_fav".localize()
        lblSaveFavourite.font = UIFont.appBoldFont(ofSize: 20)
        lblSaveFavourite.textAlignment = APIHelper.appTextAlignment
        lblSaveFavourite.textColor = .txtColor
        layoutDict["lblSaveFavourite"] = lblSaveFavourite
        lblSaveFavourite.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblSaveFavourite)
        
        lblAddress.lineBreakMode = .byWordWrapping
        lblAddress.numberOfLines = 0
        lblAddress.font = UIFont.appRegularFont(ofSize: 16)
        lblAddress.textAlignment = APIHelper.appTextAlignment
        lblAddress.textColor = .hexToColor("B1B1B1")
        layoutDict["lblAddress"] = lblAddress
        lblAddress.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblAddress)
        
        btnHome.isSelected = true
        btnHome.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btnHome.setTitle("txt_Home".localize(), for: .normal)
        btnHome.setImage(UIImage(named: "ic_radio_select"), for: .selected)
        btnHome.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnHome.setTitleColor(.txtColor, for: .normal)
        btnHome.titleLabel?.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["btnHome"] = btnHome
        btnHome.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnHome)
        
        btnWork.isSelected = false
        btnWork.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btnWork.setTitle("txt_Work".localize(), for: .normal)
        btnWork.setImage(UIImage(named: "ic_radio_select"), for: .selected)
        btnWork.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnWork.setTitleColor(.txtColor, for: .normal)
        btnWork.titleLabel?.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["btnWork"] = btnWork
        btnWork.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnWork)
        
        btnOthers.isSelected = false
        btnOthers.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btnOthers.setTitle("txt_Other".localize(), for: .normal)
        btnOthers.setImage(UIImage(named: "ic_radio_select"), for: .selected)
        btnOthers.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnOthers.setTitleColor(.txtColor, for: .normal)
        btnOthers.titleLabel?.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["btnOthers"] = btnOthers
        btnOthers.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnOthers)
        
        btnCancel.layer.cornerRadius = 5
        btnCancel.setTitle("text_cancel".localize(), for: .normal)
        btnCancel.titleLabel?.font = UIFont.appRegularFont(ofSize: 16)
        btnCancel.setTitleColor(.txtColor, for: .normal)
        btnCancel.backgroundColor = .hexToColor("D9D9D9")
        layoutDict["btnCancel"] = btnCancel
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnCancel)
        
        btnSave.layer.cornerRadius = 5
        btnSave.setTitle("txt_Save_place".localize(), for: .normal)
        btnSave.titleLabel?.font = UIFont.appBoldFont(ofSize: 18)
        btnSave.setTitleColor(.themeTxtColor, for: .normal)
        btnSave.backgroundColor = .themeColor
        layoutDict["btnSave"] = btnSave
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnSave)
        
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblSaveFavourite][lblAddress]-15-[btnHome(30)]-20-[btnSave(45)]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblSaveFavourite]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblAddress]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnHome]-10-[btnWork(==btnHome)]-10-[btnOthers(==btnHome)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnCancel]-10-[btnSave(==btnCancel)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
    }

}
