//
//  PaymentSelectModel.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Foundation
import UIKit

// passing seleced payment option via delegate
protocol PaymentDidSelectDelegate {
    func selectedPaymentOption(payment: PaymentType)
}

enum PaymentType:String, CaseIterable {
    
    case cash = "1"
    case card = "0"
    case Wallet = "2"

    var id: Int {
        switch self {
        
        case .cash: return 1
        case .card: return 0
        case .Wallet: return 2
        }
    }
    var title: String {
        switch self {
        case .cash: return "txt_cash".localize().uppercased()
        case .card: return "txt_card".localize().uppercased()
        case .Wallet: return "txt_wallet".localize().uppercased()
        }
    }
    var image: UIImage {
        switch self {
        
        case .cash: return UIImage(named:"ic_pay_cash") ?? UIImage()
        case .card: return UIImage(named:"ic_pay_mastro") ?? UIImage()
        case .Wallet: return UIImage(named:"paymentwallet") ?? UIImage()
        }
    }
}
