//
//  WalletVC.swift
//  Taxiappz
//
//  Created by Apple on 15/02/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire

class WalletVC: UIViewController {

    private let walletView = WalletView()
    private var currency: String?
    private var walletHistory:[WalletHistory]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        getWalletDetail()
        setupViews()
        
    }
    
    func setupViews() {
        walletView.setupViews(Base: self.view)
        setupTarget()
    }
   
    func setupTarget() {
        walletView.tableView.delegate = self
        walletView.tableView.dataSource = self
        walletView.moneyTfd.delegate = self
        walletView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        walletView.btn1.addTarget(self, action: #selector(AmtBtnPressed(_ :)), for: .touchUpInside)
        walletView.btn2.addTarget(self, action: #selector(AmtBtnPressed(_ :)), for: .touchUpInside)
        walletView.addamtbtn.addTarget(self, action: #selector(btnAddAmountPressed(_ :)), for: .touchUpInside)

    }
}

//MARK:- TARET ACTIONS

extension WalletVC {
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.walletHistory = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupText() {
        self.walletView.currencyView.text = self.currency
        self.walletView.btn1.setTitle((self.currency ?? "") + " 500", for: .normal)
        self.walletView.btn2.setTitle((self.currency ?? "") + " 1000", for: .normal)
    }
    
    @objc func AmtBtnPressed(_ sender: UIButton) {
        if sender == walletView.btn1 {
            self.walletView.moneyTfd.text = "500"
        } else if sender == walletView.btn2 {
            self.walletView.moneyTfd.text = "1000"
        }
    }
    
    @objc func btnAddAmountPressed(_ sender: UIButton) {
        if self.walletView.moneyTfd.text == "" {
            self.showAlert("", message: "txt_enter_amount".localize())
        } else {
            self.addMoneyWallet()
        }
    }
}

//MARK:- API'S
extension WalletVC {
    
    func getWalletDetail() {
        NKActivityLoader.sharedInstance.show()
        let url = APIHelper.shared.BASEURL + APIHelper.getWalletAmount
        print("Wallet Get Amount API",url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
            NKActivityLoader.sharedInstance.hide()
            switch response.result {
            case .failure(let error):
                self.showAlert(APIHelper.shared.appName, message: error.localizedDescription)
            case .success(_):
                print(response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let currency = data["currency"] as? String, let total = data["total_amount"] {
                                self.currency = currency
                                self.walletView.lblTotalAmount.text = (self.currency ?? "") + " " + "\(total)"
                                self.setupText()
                            }
                            if let walletTransaction = data["wallet_transaction"] as? [[String: AnyObject]] {
                                self.walletHistory = walletTransaction.compactMap { WalletHistory($0) }
                                self.walletView.tableView.reloadData()
                            }
                        }
                    } else {
                        if let error = result["data"] as? [String:[String]] {
                            let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                            self.showAlert("", message: errMsg)
                        } else if let errMsg = result["error_message"] as? String {
                            self.showAlert("", message: errMsg)
                        } else if let msg = result["message"] as? String {
                            self.showAlert("", message: msg)
                        }
                    }
                }
            }
        }
    }
    func addMoneyWallet() {
        NKActivityLoader.sharedInstance.show()
        var paramDict = Dictionary<String, Any>()
        paramDict["amount"] = self.walletView.moneyTfd.text
        paramDict["purpose"] = "test ram"
        
        let url = APIHelper.shared.BASEURL + APIHelper.addWalletAmount
        print("Add Wallet Amount API",url,paramDict)

        Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
            NKActivityLoader.sharedInstance.hide()
            switch response.result {
            case .failure(let error):
                self.showAlert(APIHelper.shared.appName, message: error.localizedDescription)
            case .success(_):
                print(response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        
                            self.getWalletDetail()
                            self.walletView.moneyTfd.text = ""

                    } else {
                        if let error = result["data"] as? [String:[String]] {
                            let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                            self.showAlert("", message: errMsg)
                        } else if let errMsg = result["error_message"] as? String {
                            self.showAlert("", message: errMsg)
                        } else if let msg = result["message"] as? String {
                            self.showAlert("", message: msg)
                        }
                    }
                }
            }
        }
    }
}
extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletHistoryCell") as? WalletHistoryCell ??
        WalletHistoryCell(style: .default, reuseIdentifier: "WalletHistoryCell")
        
        cell.selectionStyle = .none
        
        if let amount = self.walletHistory?[indexPath.row].amount {
            cell.lblAmount.text = (self.currency ?? "")  + " " + amount
        }
        cell.lblTransactionType.text = self.walletHistory?[indexPath.row].type

        if let addedDate = self.walletHistory?[indexPath.row].dateStr {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let date = dateFormatterGet.date(from: addedDate)
            cell.lblDate.text = dateFormatter.string(from: date!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TRANSACTION"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}
//MARK:- TEXTFIELD DELEGATES

extension WalletVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 5
        let currentString: NSString = self.walletView.moneyTfd.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
    }
}
