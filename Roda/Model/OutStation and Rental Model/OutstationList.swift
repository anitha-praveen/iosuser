//
//  OutstationList.swift
//  Roda
//
//  Created by Apple on 22/04/22.
//

import Foundation

struct OutstationList {
    var id: String?
    var cityName: String?
    var distance: String?
    var dropLat: String?
    var dropLong: String?
    var hillStation: String?
    
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let name = dict["drop"] as? String {
            self.cityName = name
        }
        if let distance = dict["distance"] {
            self.distance = "\(distance)"
        }
        if let lat = dict["drop_lat"] {
            self.dropLat = "\(lat)"
        }
        if let lng = dict["drop_lng"] {
            self.dropLong = "\(lng)"
        }
        if let hillstation = dict["hill_station"] as? String {
            self.hillStation = hillstation
        }
    }
}

struct OutstationTypes {
    var distance: String?
    var distancePrice: String?
    var driverBeta: String?
    var vehicleImage: String?
    var vehicleHighlightedImage: String?
    var slug: String?
    var vehicleName: String?
    var totalAmount: String?
    var currency: String?
    var promoTotalAmount: String?
    var isPromoApplied: Bool?
    var twoWayDistancePrice: String?
    var hillPrice: String?
    
    init(_ dict: [String: AnyObject]) {
        if let distance = dict["distance"] {
            self.distance = "\(distance)"
        }
        if let dc = dict["distance_price"] {
            self.distancePrice = "\(dc)"
        }
        if let tdc = dict["distance_price_two_way"] {
            self.twoWayDistancePrice = "\(tdc)"
        }
        if let db = dict["driver_price"] {
            self.driverBeta = "\(db)"
        }
        if let vehicleDetail = dict["get_vehicle"] as? [String: AnyObject] {
            if let image = vehicleDetail["image"] as? String {
                self.vehicleImage = image
            }
            if let highlightImage = vehicleDetail["highlight_image"] as? String {
                self.vehicleHighlightedImage = highlightImage
            }
            if let slug = vehicleDetail["slug"] {
                self.slug = "\(slug)"
            }
            if let name = vehicleDetail["vehicle_name"] as? String {
                self.vehicleName = name
            }
        }
        if let totalAmt = dict["total_amount"] {
            self.totalAmount = "\(totalAmt)"
        }
        if let promoAmt = dict["total_amount_promo"] {
            self.promoTotalAmount = "\(promoAmt)"
        }
        if let currency = dict["currency_symbol"] as? String {
            self.currency = currency
        }
        if let promoApplied = dict["promo_code"] as? Bool {
            self.isPromoApplied = promoApplied
        }
        if let hillPrice = dict["hill_station_price"] {
            self.hillPrice = "\(hillPrice)"
        }
    }
    
}
