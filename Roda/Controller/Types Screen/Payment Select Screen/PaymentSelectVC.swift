//
//  PaymentSelectVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 11/08/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit

class PaymentSelectVC: UIViewController {
    
    let paymentSelectView = PaymentSelectView()
    
    var paymentTypeList: [String] = []
    var selectedPaymentType = ""
    var callBack:((String)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondaryColor
        self.navigationController?.navigationBar.isHidden = true
        
        self.setUpViews()
        self.setupTarget()
        
    }
    func setUpViews() {
        paymentSelectView.setupViews(Base: self.view)
        paymentSelectView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed(_ :)), for: .touchUpInside)
    }
    
    func setupTarget() {
        paymentSelectView.cardlisttbv.delegate = self
        paymentSelectView.cardlisttbv.dataSource = self
        paymentSelectView.cardlisttbv.register(PaymentTypesCell.self, forCellReuseIdentifier: "PaymentTypesCell")
        paymentSelectView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        
    }
    
    @objc func backBtnAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnConfirmPressed(_ sender: UIButton) {
        self.callBack?(self.selectedPaymentType)
        self.navigationController?.popViewController(animated: true)
    }
}

extension PaymentSelectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTypesCell") as? PaymentTypesCell ?? PaymentTypesCell()
        
        cell.cardnumbeLbl.text = self.paymentTypeList[indexPath.row]
        
        if self.paymentTypeList[indexPath.row].uppercased() == "CASH" {
            cell.cardImv.image = UIImage(named: "addMoneyDoller")
        } else if self.paymentTypeList[indexPath.row].uppercased() == "CARD" {
            cell.cardImv.image = UIImage(named: "cardImg")
        } else if self.paymentTypeList[indexPath.row].uppercased() == "WALLET" {
            cell.cardImv.image = UIImage(named: "sidemenupaymentWallet")
        } else {
            cell.cardImv.image = UIImage(named: "addMoneyDoller")
        }
       
        if self.selectedPaymentType == self.paymentTypeList[indexPath.row] {
            cell.cardSelectionBtn.isSelected = true
        } else {
            cell.cardSelectionBtn.isSelected = false
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPaymentType = self.paymentTypeList[indexPath.row]
        self.paymentSelectView.cardlisttbv.reloadData()
    }
}
