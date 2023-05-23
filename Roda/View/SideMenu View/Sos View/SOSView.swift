//
//  SOSView.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class SOSView: UIView {

    let backBtn = UIButton()
    let addBtn = UIButton()
    
    let lineBar = UIView()
    
    let sosheadinglbl = UILabel()
    let soshintlbl = UILabel()
    var soslisttbv = UITableView()
    
    var transparentView = UIView()
    var sosDetailView = UIView()
    var sosDetailHeader = UILabel()
    var sosDetailTitlelbl = UILabel()
    var sosDetailTitleTxtFld = UITextField()
    var sosDetailPhoneNumLbl = UILabel()
    var sosDetailPhoneNumTxtfld = UITextField()
    

    var sosDetailSubmitBtn = UIButton()
    
    var layoutDict = [String: AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        baseView.addSubview(backBtn)
        
        addBtn.setTitle("txt_Add".localize().uppercased(), for: .normal)
        addBtn.setTitleColor(.themeColor, for: .normal)
        addBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.backgroundColor = .secondaryColor
        layoutDict["addBtn"] = addBtn
        baseView.addSubview(addBtn)
        
        lineBar.backgroundColor = .hexToColor("DADADA")
        lineBar.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lineBar"] = lineBar
        baseView.addSubview(lineBar)

        sosheadinglbl.text = "txt_sos".localize()
        sosheadinglbl.textAlignment = APIHelper.appTextAlignment
        sosheadinglbl.font = UIFont.appBoldTitleFont(ofSize: 26)
        sosheadinglbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosheadinglbl"] = sosheadinglbl
        baseView.addSubview(sosheadinglbl)

        soshintlbl.numberOfLines = 0
        soshintlbl.lineBreakMode = .byWordWrapping
        soshintlbl.text = "text_soscontent".localize()
        soshintlbl.textAlignment = APIHelper.appTextAlignment
        soshintlbl.font = UIFont.appFont(ofSize: 16)
        soshintlbl.textColor = .gray
        soshintlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["soshintlbl"] = soshintlbl
        baseView.addSubview(soshintlbl)

        soslisttbv.alwaysBounceVertical = false
        soslisttbv.allowsSelection = true
        soslisttbv.separatorStyle = .none
        soslisttbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["soslisttbv"] = soslisttbv
        baseView.addSubview(soslisttbv)
        
        transparentView.isHidden = true
        transparentView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.7)
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["transparentView"] = transparentView
        baseView.addSubview(transparentView)
    
        sosDetailView.backgroundColor = .secondaryColor
        sosDetailView.layer.borderWidth = 2
        sosDetailView.layer.borderColor = UIColor.themeColor.cgColor
        sosDetailView.layer.cornerRadius = 15
        sosDetailView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosDetailView"] = sosDetailView
        transparentView.addSubview(sosDetailView)
        
        sosDetailHeader.text = "txt_add_emergency".localize()
        sosDetailHeader.font = UIFont.appSemiBold(ofSize: 18)
        sosDetailHeader.textAlignment = .center
        sosDetailHeader.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosDetailHeader"] = sosDetailHeader
        sosDetailView.addSubview(sosDetailHeader)
        
        sosDetailTitlelbl.text = "text_title".localize()
        sosDetailTitlelbl.font = UIFont.appBoldFont(ofSize: 12)
        sosDetailTitlelbl.textAlignment = APIHelper.appTextAlignment
        sosDetailTitlelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosDetailTitlelbl"] = sosDetailTitlelbl
        sosDetailView.addSubview(sosDetailTitlelbl)
        
        sosDetailTitleTxtFld.layer.borderColor = UIColor.txtColor.cgColor
        sosDetailTitleTxtFld.layer.borderWidth = 1
        sosDetailTitleTxtFld.layer.cornerRadius = 10
        sosDetailTitleTxtFld.addIcon(UIImage(named: ""))
        sosDetailTitleTxtFld.textAlignment = APIHelper.appTextAlignment
        sosDetailTitleTxtFld.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosDetailTitleTxtFld"] = sosDetailTitleTxtFld
        sosDetailView.addSubview(sosDetailTitleTxtFld)
        
        sosDetailPhoneNumLbl.text = "hint_phone_number".localize()
        sosDetailPhoneNumLbl.font = UIFont.appBoldFont(ofSize: 12)
        sosDetailPhoneNumLbl.textAlignment = APIHelper.appTextAlignment
        sosDetailPhoneNumLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosDetailPhoneNumLbl"] = sosDetailPhoneNumLbl
        sosDetailView.addSubview(sosDetailPhoneNumLbl)

        sosDetailPhoneNumTxtfld.layer.borderColor = UIColor.txtColor.cgColor
        sosDetailPhoneNumTxtfld.layer.borderWidth = 1
        sosDetailPhoneNumTxtfld.layer.cornerRadius = 10
        sosDetailPhoneNumTxtfld.addIcon(UIImage(named: ""))
        sosDetailPhoneNumTxtfld.keyboardType = .numberPad
        sosDetailPhoneNumTxtfld.textAlignment = APIHelper.appTextAlignment
        sosDetailPhoneNumTxtfld.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosDetailPhoneNumTxtfld"] = sosDetailPhoneNumTxtfld
        sosDetailView.addSubview(sosDetailPhoneNumTxtfld)
        
        

        sosDetailSubmitBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        sosDetailSubmitBtn.setTitle("text_submit".localize(), for: .normal)
        sosDetailSubmitBtn.setTitleColor(.themeTxtColor, for: .normal)
        sosDetailSubmitBtn.layer.cornerRadius = 25
        sosDetailSubmitBtn.translatesAutoresizingMaskIntoConstraints = false
        sosDetailSubmitBtn.backgroundColor = .themeColor
        layoutDict["sosDetailSubmitBtn"] = sosDetailSubmitBtn
        sosDetailView.addSubview(sosDetailSubmitBtn)
        
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        soslisttbv.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-5-[lineBar(1)]-15-[sosheadinglbl(30)]-(20)-[soshintlbl]-(20)-[soslisttbv]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[addBtn]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        addBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineBar]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosheadinglbl]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[soshintlbl]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(4)-[soslisttbv]-(4)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        transparentView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        transparentView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[transparentView]|", options: [], metrics: nil, views: layoutDict))
        
        sosDetailView.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor).isActive = true
        transparentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosDetailView]-(16)-|", options: [], metrics: nil, views: layoutDict))

        sosDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[sosDetailHeader(30)]-10-[sosDetailTitlelbl(20)]-(5)-[sosDetailTitleTxtFld(50)]-10-[sosDetailPhoneNumLbl(20)]-(5)-[sosDetailPhoneNumTxtfld(50)]-15-[sosDetailSubmitBtn(50)]-20-|", options: [], metrics: nil, views: layoutDict))
        sosDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosDetailHeader]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        sosDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosDetailTitlelbl]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        sosDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosDetailTitleTxtFld]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        sosDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosDetailPhoneNumLbl]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        sosDetailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[sosDetailPhoneNumTxtfld]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        sosDetailSubmitBtn.centerXAnchor.constraint(equalTo: sosDetailView.centerXAnchor).isActive = true
    }
}

class SOSListTableViewCell: UITableViewCell {
    
    var shadowView = UIView()
    var titleBgView = UIView()
    var sosnameLbl = UILabel()
    var sosDeleteBtn = UIButton(type:.custom)

    var numBgView = UIView()
    var sosnumberLbl = UILabel()
    var soscallBtn = UIButton(type:.custom)
    
    var layoutDict = [String:AnyObject]()
    
    var callAction:(()->Void)?
    var deleteAction:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    func setUpViews() {
        
        contentView.isUserInteractionEnabled = true
        
        selectionStyle = .none
        
        shadowView.layer.cornerRadius = 5
        shadowView.layer.masksToBounds = false
        shadowView.backgroundColor = .secondaryColor
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["shadowView"] = shadowView
        addSubview(shadowView)
        shadowView.addShadow()
        
        titleBgView.backgroundColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1)
        titleBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["titleBgView"] = titleBgView
        shadowView.addSubview(titleBgView)
        
        sosnameLbl.textColor = .secondaryColor
        sosnameLbl.font = UIFont.appFont(ofSize: 18)
        sosnameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosnameLbl"] = sosnameLbl
        titleBgView.addSubview(sosnameLbl)
        
        sosDeleteBtn.isHidden = true
        sosDeleteBtn.addTarget(self, action: #selector(deleteNum(_ :)), for: .touchUpInside)
        sosDeleteBtn.isUserInteractionEnabled = true
        sosDeleteBtn.imageView?.contentMode = .scaleAspectFit
        sosDeleteBtn.imageView?.tintColor = .secondaryColor
        sosDeleteBtn.setImage(UIImage(named: "deletecardicon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        sosDeleteBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosDeleteBtn"] = sosDeleteBtn
        titleBgView.addSubview(sosDeleteBtn)
        
        numBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["numBgView"] = numBgView
        shadowView.addSubview(numBgView)
        
        sosnumberLbl.font = UIFont.appFont(ofSize: 18)
        sosnumberLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sosnumberLbl"] = sosnumberLbl
        numBgView.addSubview(sosnumberLbl)
        
        soscallBtn.isUserInteractionEnabled = true
        soscallBtn.addTarget(self, action: #selector(callNum(_ :)), for: .touchUpInside)
        soscallBtn.imageView?.contentMode = .scaleAspectFill
        soscallBtn.imageView?.tintColor = .themeColor
        soscallBtn.setImage(UIImage(named: "call")?.withRenderingMode(.alwaysTemplate), for: .normal)
        soscallBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["soscallBtn"] = soscallBtn
        numBgView.addSubview(soscallBtn)
        

        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[shadowView]-(10)-|", options: [], metrics: nil, views: layoutDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[shadowView]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        shadowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleBgView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        shadowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleBgView(40)][numBgView(50)]|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        titleBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[sosnameLbl]-(10)-[sosDeleteBtn(30)]-20-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        titleBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[sosnameLbl]-(5)-|", options: [], metrics: nil, views: layoutDict))
        numBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[sosnumberLbl]-(10)-[soscallBtn(50)]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        numBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[soscallBtn]-5-|", options: [], metrics: nil, views: layoutDict))
        numBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[sosnumberLbl]-(5)-|", options: [], metrics: nil, views: layoutDict))
        
        titleBgView.clipsToBounds = false
        titleBgView.layer.cornerRadius = 5
        titleBgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        sosnameLbl.textAlignment = APIHelper.appTextAlignment
        sosnumberLbl.textAlignment = APIHelper.appTextAlignment
    }
    
    @objc func callNum(_ sender: UIButton) {
        if let action = self.callAction {
            action()
        }
    }
    
    @objc func deleteNum(_ sender: UIButton) {
        if let action = self.deleteAction {
            action()
        }
    }
}
