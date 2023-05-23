//
//  HistoryModel.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Foundation

enum SelectedHistory {
    case scheduled
    case completed
    case cancelled
}

struct HistroyDetail {

    var requestId: String?
    var id: String?
    var enableDispute: Bool?
    var pickLatitude: Double?
    var pickLongitude: Double?
    var dropLatitude: Double?
    var dropLongitude: Double?
    var pickLocation: String?
    var dropLocation: String?
    var isCompleted: Bool?
    var isCancelled: Bool?
    var paymentMethod: String?
    var tripStartTime: String?
    var tripEndTime: String?
    var totalDistance: String?
    var totalTime: String?
    var distanceUnit: String?
    var typeName: String?
    var driverRating: String?
    var carDetail: RideCarDetail?
    var driverDetail: RideDriverDetail?
    var requestBill:HistoryRequestBill?
    var vehicleImage: String?
    var vehicleHighLightImage: String?
    var cancelBy: String?
    var cancelReason: String?
    var serviceCategory: String?
    var rentalPackageHour: String?
    var rentalPackageKm: String?
    var outStationTripStartkm: String?
    var outStationTripEndkm: String?
    var outStationTripType: String?

    init(_ dict: [String: AnyObject]) {
        
        if let data = dict["data"] as? [String: AnyObject] {
            
            if let requestId = data["request_number"] as? String {
                self.requestId = requestId
            }
            if let id = data["id"] as? String {
                self.id = id
            }
            
            if let disputeStatus = data["dispute_status"] as? Bool {
                self.enableDispute = disputeStatus
            }
            
            if let pickLatitude = data["pick_lat"] {
                self.pickLatitude = Double("\(pickLatitude)")
            }
            if let pickLongitude = data["pick_lng"] {
                self.pickLongitude = Double("\(pickLongitude)")
            }
            if let dropLatitude = data["drop_lat"] {
                self.dropLatitude = Double("\(dropLatitude)")
            }
            if let dropLongitude = data["drop_lng"] {
                self.dropLongitude = Double("\(dropLongitude)")
            }
            if let pickLocation = data["pick_address"] as? String {
                self.pickLocation = pickLocation
            }
            if let dropLocation = data["drop_address"] as? String {
                self.dropLocation = dropLocation
            }
            if let payMode = data["payment_opt"] as? String {
                self.paymentMethod = payMode
            }
            if let tripStartTime = data["trip_start_time"] as? String {
                self.tripStartTime = tripStartTime
            }
            if let endTime = data["completed_at"] as? String {
                self.tripEndTime = endTime
            }
            if let isCompleted = data["is_completed"] as? Bool {
                self.isCompleted = isCompleted
            }
            if let isCancelled = data["is_cancelled"] as? Bool {
                self.isCancelled = isCancelled
            }
            if let typeName = data["vehicle_name"] as? String {
                self.typeName = typeName
            }
            if let unit = data["unit"] as? String {
                self.distanceUnit = unit
            }
            if let review = data["driver_overall_rating"] {
                if let rating = Double("\(review)") {
                    self.driverRating = String(format: "%.2f", rating)
                }
            }
            if let totalDistance = data["total_distance"] {
                self.totalDistance = "\(totalDistance)"
            }
            if let totalTime = data["total_time"] {
                self.totalTime = "\(totalTime)"
            }
            
            if let vehicleImage = data["vehicle_image"] as? String {
                self.vehicleImage = vehicleImage
            }
            if let vehicleImage = data["vehicle_highlight_image"] as? String {
                self.vehicleHighLightImage = vehicleImage
            }
            
            if let driverData = data["driver"] as? [String: AnyObject] {
                self.driverDetail = RideDriverDetail(driverData)
            }
            if let carDetails = data["car_details"] as? [String: AnyObject] {
                self.carDetail = RideCarDetail(carDetails)
                
            }
            if let billDetails = data["requestBill"] as? [String: AnyObject] {
                if let billData = billDetails["data"] as? [String: AnyObject] {
                    self.requestBill = HistoryRequestBill(billData)
                }
            }
            
            if let cancelby = data["cancel_method"] as? String {
                self.cancelBy = cancelby
            }
            if let cancelreason = data["custom_reason"] as? String {
                self.cancelReason = cancelreason
            } else if let reason = data["reason"] as? String {
                self.cancelReason = reason
            }
            
            if let serviceType = data["service_category"] as? String {
                self.serviceCategory = serviceType
            }
            if let packageHour = data["package_hour"] {
                self.rentalPackageHour = "\(packageHour)"
            }
            if let packageKm = data["package_km"] {
                self.rentalPackageKm = "\(packageKm)"
            }
            if let startkm = data["start_km"] {
                self.outStationTripStartkm = "\(startkm)"
            }
            if let endkm = data["end_km"] {
                self.outStationTripEndkm = "\(endkm)"
            }
            if let tripType = data["outstation_trip_type"] as? String {
                self.outStationTripType = tripType
            }
        }

    }
}

struct HistoryRequestBill {
    var currency: String?
    var basePrice: String?
    var distancePrice: String?
    var pricePerDistance: String?
    var timePrice: String?
    var pricePerTime: String?
    var promoBonus: String?
    var waitingPrice: String?
    var totalAmount: String?
    var cancellationFee: String?
    var bookingFee: String?
    var serviceTax: String?
    var outOfZoneFee: String?
    var hillStationPrice: String?
    var rentalRidePackageHour: String?
    var rentalRidePackageKm: String?
    var rentalRidePendingKm: String?
    var totalDistance: String?
    init(_ dict: [String: AnyObject]) {
        if let currency = dict["requested_currency_symbol"] as? String {
            self.currency = currency
        }
        self.basePrice = dict.getInAmountFormat(str: "base_price")
        self.distancePrice = dict.getInAmountFormat(str: "distance_price")
        self.pricePerDistance = dict.getInAmountFormat(str: "price_per_distance")
        self.timePrice = dict.getInAmountFormat(str: "time_price")
        self.pricePerTime = dict.getInAmountFormat(str: "price_per_time")
        self.promoBonus = dict.getInAmountFormat(str: "promo_discount")
        self.waitingPrice = dict.getInAmountFormat(str: "waiting_charge")
        self.totalAmount = dict.getInAmountFormat(str: "total_amount")
        self.cancellationFee = dict.getInAmountFormat(str: "cancellation_fee")
        self.bookingFee = dict.getInAmountFormat(str: "booking_fees")
        self.serviceTax = dict.getInAmountFormat(str: "service_tax")
        self.outOfZoneFee = dict.getInAmountFormat(str: "out_of_zone_price")
        self.hillStationPrice = dict.getInAmountFormat(str: "hill_station_price")
        if let packageHrs = dict["package_hours"] {
            self.rentalRidePackageHour = "\(packageHrs)"
        }
        if let packagekm = dict["package_km"] {
            self.rentalRidePackageKm = "\(packagekm)"
        }
        if let pendingkm = dict["pending_km"] {
            self.rentalRidePendingKm = "\(pendingkm)"
        }
        if let totDist = dict["total_distance"] {
            self.totalDistance = "\(totDist)"
        }
        
    }
}

struct RideCarDetail {
    var carModel: String?
    var carNumber: String?
    
    init(_ dict: [String: AnyObject]) {
        if let carModel = dict["car_model"] as? String {
            self.carModel = carModel
        }
        if let carNumber = dict["car_number"] as? String {
            self.carNumber = carNumber
        }
    }
}
struct RideDriverDetail {
    var userProfilePicUrlStr: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?

    init(_ dict: [String: AnyObject]) {
        if let userProfilePicUrlStr = dict["profile_pic"] as? String {
            self.userProfilePicUrlStr = userProfilePicUrlStr
        }
        if let fname = dict["firstname"] as? String {
            self.firstName = fname
        }
        if let lname = dict["lastname"] as? String {
            self.lastName = lname
        }
        if let phone = dict["phone_number"] as? String {
            self.phoneNumber = phone
        }
    }
}
