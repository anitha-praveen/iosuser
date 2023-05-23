//
//  FavouriteView.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit

class FavouriteView: UIView {
    
    let backBtn = UIButton()
    let addBtn = UIButton()
    let titleLbl = UILabel()
    let favListTB = UITableView()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        [backBtn, titleLbl, favListTB, addBtn, favListTB].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            baseView.addSubview($0)
        }
        
        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        
        addBtn.setTitle("txt_Add".localize(), for: .normal)
        addBtn.setTitleColor(.themeColor, for: .normal)
        addBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 19)
        addBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        addBtn.setImage(UIImage(named: "redPlus"), for: .normal)
        addBtn.imageView?.contentMode = .scaleAspectFill
        addBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        addBtn.contentMode = .scaleAspectFit
        addBtn.backgroundColor = .secondaryColor
        layoutDict["addBtn"] = addBtn
        
        titleLbl.text = "txt_my_fav".localize()
        titleLbl.font = .appSemiBold(ofSize: 30)
        titleLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        
       
        favListTB.alwaysBounceVertical = false
        favListTB.tableFooterView = UIView()
        layoutDict["favListTB"] = favListTB
        favListTB.reloadData()
        
        
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor , constant: 20).isActive = true
        favListTB.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backBtn(30)]-15-[titleLbl(40)]-20-[favListTB]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(30)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[addBtn(80)]-15-|", options: [], metrics: nil, views: layoutDict))
        addBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 0).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[favListTB]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}

class FavCell: UITableViewCell {

    var imgView = UIImageView()
    var textLbl = UILabel()
    let addressLbl = UILabel()
    var deleteBtn = UIButton()
    var favDeleteBtnAction:(()->Void)?
    
    var layoutDic = [String:AnyObject]()

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
        self.addSubview(imgView)
        self.addSubview(textLbl)
        self.addSubview(addressLbl)
        self.addSubview(deleteBtn)
        
        imgView.tintColor = .themeColor
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imgView"] = imgView
        
        textLbl.textAlignment = APIHelper.appTextAlignment
        textLbl.textColor = .txtColor
        textLbl.font = UIFont.appSemiBold(ofSize: 16)
        textLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["textLbl"] = textLbl
        
        addressLbl.textAlignment = APIHelper.appTextAlignment
        addressLbl.textColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
        addressLbl.font = UIFont.appRegularFont(ofSize: 14)
        addressLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addressLbl"] = addressLbl
        
        deleteBtn.addTarget(self, action: #selector(favDeleteBtnTapped(_:)), for: .touchUpInside)
        deleteBtn.setImage(UIImage(named: "deleteIcon"), for: .normal)
        deleteBtn.imageView?.contentMode = .scaleAspectFit
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["deleteBtn"] = deleteBtn

       
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[imgView(22)]-(15)-[textLbl]-(10)-[deleteBtn(22)]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        imgView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        imgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[textLbl(25)]-(3)-[addressLbl(>=25)]-(10)-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        deleteBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        deleteBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    @objc func favDeleteBtnTapped(_ sender: UIButton) {
        if let deleteAction = favDeleteBtnAction {
            let alert = UIAlertController(title: APIHelper.shared.appName, message: "txt_delete_alert".localize(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "text_no".localize(), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "text_yes".localize().uppercased(), style: .default, handler: { (action) in
                deleteAction()
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
    }
}
extension UITableView {

    func isLast(for indexPath: IndexPath) -> Bool {

        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1

        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
}

