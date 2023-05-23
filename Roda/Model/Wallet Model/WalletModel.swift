//
//  WalletModel.swift
//  Taxiappz
//
//  Created by Apple on 22/02/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import Foundation

struct WalletHistory {
    
    var dateStr: String?
    var amount: String?
    var currency: String?
    var requestId: String?
    var purpose:  String?
    var type: String?
    
    init(_ dict: [String: AnyObject]) {
        if let datestr = dict["updated_at"] as? String {
            self.dateStr = datestr
        }
        if let amount = dict["amount"] {
            self.amount = "\(amount)"
        }
        if let currency = dict["currency"] as? String {
            self.currency = currency
        }
        if let id = dict["transact_id"] as? String {
            self.requestId = id
        }
        if let purpose = dict["purpose"] as? String {
            self.purpose = purpose
        }
        if let type = dict["type"] as? String {
            self.type = type
        }
    }
}
