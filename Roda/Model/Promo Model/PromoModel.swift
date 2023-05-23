//
//  PromoModel.swift
//  Taxiappz
//
//  Created by Apple on 17/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import Foundation

struct PromoList {
    var id: String?
    var slug: String?
    var promoCode: String?
    var description: String?
    var offerTitle: String?
    var icon: String?
    var promoType: String?
    var amount: String?
    var percentage: String?
    var currency: String?
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
        if let code = dict["promo_code"] as? String {
            self.promoCode = code
        }
        if let desc = dict["description"] as? String {
            self.description = desc
        }
        if let title = dict["select_offer_option_title"] as? String {
            self.offerTitle = title
        }
        if let icon = dict["promo_icon"] as? String {
            self.icon = icon
        }
        if let type = dict["promo_type"] {
            self.promoType = "\(type)"
        }
        if let amt = dict["amount"] {
            self.amount = "\(amt)"
        }
        if let percentage = dict["percentage"] {
            self.percentage = "\(percentage)"
        }
        if let currency = dict["country_symbol"] as? String {
            self.currency = currency
        }
    }
}
