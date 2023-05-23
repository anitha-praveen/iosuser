//
//  RentalTypeList.swift
//  Roda
//
//  Created by Apple on 02/05/22.
//

import Foundation
import Metal

struct RentalPackageList {
    var id: String?
    var slug: String?
    var hours: String?
    var distance: String?
    
    init(_ dict: [String: AnyObject]) {
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let hrs = dict["hours"] as? String {
            if let type = dict["time_cost_type"] as? String {
                self.hours = hrs + " " + type
            } else {
                self.hours = hrs + " " + "hr"
            }
        }
        if let distance = dict["km"] {
            self.distance = "\(distance) km"
        }
    }
}

struct RentalPackageType {
    var typeId: String?
    var typeName: String?
    var typeImage: String?
    var highlightImage: String?
    var totalAmout: String?
    var id: String?
    var totalPromoAmount: String?
    var isPromoApplied: Bool?
    var currency: String?
    
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let currency = dict["currency_symbol"] as? String {
            self.currency = currency
        }
        if let amount = dict["total_amount"] {
            self.totalAmout = "\(amount)"
        }
        if let promoTotal = dict["total_amount_promo"] {
            self.totalPromoAmount = "\(promoTotal)"
        }
        if let promoApplied = dict["promo_code"] as? Bool {
            self.isPromoApplied = promoApplied
        }
        if let typeObj = dict["get_vehicle"] as? [String: AnyObject] {
            if let name = typeObj["vehicle_name"] as? String {
                self.typeName = name
            }
            if let image = typeObj["image"] as? String {
                self.typeImage = image
            }
            if let img = typeObj["highlight_image"] as? String {
                self.highlightImage = img
            }
            if let slug = typeObj["slug"] as? String {
                self.typeId = slug
            }
        }
    }
}
