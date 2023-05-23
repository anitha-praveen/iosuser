//
//  SearchLocationModel.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import Foundation
import GoogleMaps
import GooglePlaces
import CoreLocation

struct StopLocationParam : Codable ,Equatable {
    static func == (lhs:StopLocationParam, rhs:StopLocationParam) -> Bool {
        return  lhs.pickupAddress == rhs.pickupAddress && lhs.pickupLat == rhs.pickupLat && lhs.pickupLng == rhs.pickupLng
    }
    let pickupAddress : String
    let pickupLat : Double
    let pickupLng : Double
   
    enum CodingKeys: String, CodingKey {
        case pickupAddress = "address"
        case pickupLat = "latitude"
        case pickupLng = "longitude"
    }
}

struct SearchLocation:Equatable {
    static func == (lhs: SearchLocation, rhs: SearchLocation) -> Bool {
        return lhs.id == rhs.id && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.nickName == rhs.nickName && lhs.slug == rhs.slug && lhs.placeId == rhs.placeId && lhs.googlePlaceId == rhs.googlePlaceId
    }
    var coordinate: CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    var id: Int?
    var latitude: Double?
    var longitude: Double?
    var nickName: String?
    var placeId: String?
    var slug: String?
    
    var googlePlaceId: String?
    var locationType: LocationType
    
    init(_ dict: [String:AnyObject]) {
        
        if let id = dict["id"] as? Int {
            self.id = id
        }
        if let latitude = dict["latitude"] as? Double {
            self.latitude = latitude
        } else if let latitude = dict["latitude"] {
            self.latitude = Double("\(latitude)")
        }
        if let longitude = dict["longitude"] as? Double {
            self.longitude = longitude
        } else if let longitude = dict["longitude"] {
            self.longitude = Double("\(longitude)")
        }
        if let nickName = dict["title"] as? String {
            self.nickName = nickName
        }
        if let address = dict["address"] as? String {
            self.placeId = address
        }
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
        
        self.locationType = .favourite
    }
    
    init(_ googlePlaceId: String,title: String,address: String) {
        self.googlePlaceId = googlePlaceId
        self.nickName = title
        self.placeId = address
        self.locationType = .googleSearch
    }
    init(_ target:CLLocationCoordinate2D) {
        self.latitude = target.latitude
        self.longitude = target.longitude
        self.locationType = .reverseGeoCode
    }
    
    init(_ latitude:Double, longitude: Double, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeId = address
        self.locationType = .favourite
    }
}

enum LocationType {
    case favourite
    case googleSearch
    case reverseGeoCode
}

