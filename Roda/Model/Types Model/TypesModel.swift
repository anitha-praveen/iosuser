//
//  TypesModel.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

struct NewCarModel: Equatable {
    
    static func == (lhs: NewCarModel, rhs: NewCarModel) -> Bool {
        return lhs.typeId == rhs.typeId
    }
    
    var typeId: String?
    var typeName: String?
    var capacity: Int?
    var iconUrlStr: String?
    var iconResource: ImageResource?
    var selectedImageStr: String?
    var selectedTypeImage: ImageResource?
    var totalAmount: String?
    var basePrice: String?
    var baseDistance: String?
    var pricePerDistance: String?
    var pricePerTime: String?
    var waitingPrice: String?
    var bookingFee: String?
    var outOfZoneFee: String?
    var isPromoApplied: Bool?
    var promoTotalAmount: String?
    var promoBonus: String?
    var computedDistance: String?
    var computedPrice: String?
    
    init?(_ dict:[String:AnyObject]) {
    
        if let typeId = dict["type_slug"] as? String {
            self.typeId = typeId
        }
        
        if let name = dict["type_name"] as? String {
            self.typeName = name
        }
        
        if let iconUrlStr = dict["type_image"] as? String, let url = URL(string: iconUrlStr) {
            self.iconUrlStr = iconUrlStr
            self.iconResource = ImageResource(downloadURL: url)
        }
        if let iconUrlStr = dict["type_image_select"] as? String, let url = URL(string: iconUrlStr) {
            self.selectedImageStr = iconUrlStr
            self.selectedTypeImage = ImageResource(downloadURL: url)
        }
        
        if let capacity = dict["capacity"] as? Int {
            self.capacity = capacity
        }
        if let amount = dict["total_amount"] {
            self.totalAmount = "\(amount)"
        }
        if let bp = dict["base_price"] {
            self.basePrice = "\(bp)"
        }
        if let bd = dict["base_distance"] {
            self.baseDistance = "\(bd)"
        }
        if let distancePrice = dict["price_per_distance"] {
            self.pricePerDistance = "\(distancePrice)"
        }
        if let timePrice = dict["price_per_time"] {
            self.pricePerTime = "\(timePrice)"
        }
        if let waitingCharge = dict["waiting_charge"] {
            self.waitingPrice = "\(waitingCharge)"
        }
        if let bookingfees = dict["booking_fees"] {
            self.bookingFee = "\(bookingfees)"
        }
        if let outofzone = dict["out_of_zone_price"] {
            self.outOfZoneFee = "\(outofzone)"
        }
        if let promoApllied = dict["promo_code"] as? Bool {
            self.isPromoApplied = promoApllied
        }
        if let promoAmount = dict["promo_total_amount"] {
            self.promoTotalAmount = "\(promoAmount)"
        }
        if let promoBonus = dict["promo_amount"] {
            self.promoBonus = "\(promoBonus)"
        }
        if let cd = dict["computed_distance"] {
            self.computedDistance = "\(cd)"
        }
        if let cp = dict["computed_price"] {
            self.computedPrice = "\(cp)"
        }
    }
}

enum RideCategory: CaseIterable {
    case daily
    case rental
    case outStation
    
    var name: String {
        switch self {
            
        case .daily:
            return "txt_daily_plain".localize()
        case .rental:
            return "txt_rental".localize()
        case .outStation:
            return "txt_outstation".localize()
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .daily:
            return UIImage(named: "img_local") ?? UIImage()
        case .rental:
            return UIImage(named: "img_rental") ?? UIImage()
        case .outStation:
            return UIImage(named: "img_outstation") ?? UIImage()
        }
    }
    
    var selectedImage: UIImage {
        switch self {
            
        case .daily:
            return UIImage(named: "img_local_selected") ?? UIImage()
        case .rental:
            return UIImage(named: "img_rental_selected") ?? UIImage()
        case .outStation:
            return UIImage(named: "img_outstation_selected") ?? UIImage()
        }
    }
    
}
