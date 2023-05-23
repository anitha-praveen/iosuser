//
//  PaymentOptionVC.swift
//  Roda
//
//  Created by Apple on 26/08/22.
//

import UIKit

class PaymentOptionVC: UIViewController {
    
    private let paymentView = PaymentOptionView()
    
    var paymentOptions = [PaymentOption]()
    var selectedPaymentOption: PaymentOption?
    
    var callBack:((PaymentOption)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        paymentView.setupViews(Base: self.view)
        setupDelegate()
        setupAction()
    }
    
    func setupDelegate() {
        paymentView.tblPayOptions.dataSource = self
        paymentView.tblPayOptions.delegate = self
        paymentView.tblPayOptions.register(PaymentOptionCell.self, forCellReuseIdentifier: "payoptioncell")
    }
    
    func setupAction() {
        self.paymentView.backBtn.addTarget(self, action: #selector(backBtnPressed(_:)), for: .touchUpInside)
        self.paymentView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed(_ :)), for: .touchUpInside)
        
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnConfirmPressed(_ sender: UIButton) {
        if let selectedPayment = self.selectedPaymentOption {
            self.callBack?(selectedPayment)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
                                                                                 
                                                                                
//MARK: - Delegates
extension PaymentOptionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payoptioncell") as? PaymentOptionCell ?? PaymentOptionCell()
        
        cell.textLabel?.text = self.paymentOptions[indexPath.row].title
        cell.detailTextLabel?.text = self.paymentOptions[indexPath.row].desc
        cell.imageView?.image = UIImage(named: self.paymentOptions[indexPath.row].image)
        
        if self.selectedPaymentOption == self.paymentOptions[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPaymentOption = self.paymentOptions[indexPath.row]
        self.paymentView.tblPayOptions.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
