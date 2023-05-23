//
//  FirebaseObserver.swift
//  Taxiappz
//
//  Created by Realtech Dev Team on 19/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import GeoFire
import Foundation
import FirebaseDatabase

@objc protocol MyFirebaseDelegate: AnyObject {

    @objc optional func driverEnteredFence(_ key: String, location: CLLocation, response: [String: Any])
    @objc optional func driverExitedFence(_ key: String, location: CLLocation, response: [String: Any])
    @objc optional func driverMovesInFence(_ key: String, location: CLLocation, response: [String: Any])
    @objc optional func driverWentOffline(_ key: String)
    @objc optional func driverDataUpdated(_ key: String, response: [String: Any])
    @objc optional func tripStatusReceived(_ tripId: String, response: [String: Any])

}

class FirebaseObserver {

    weak var firebaseDelegate: MyFirebaseDelegate?

    static let shared = FirebaseObserver()

    var ref: DatabaseReference!
    var requestRef: DatabaseReference!
    var geoRef: GeoFire!

    var query: GFCircleQuery?
    var selectedPickupLocation: SearchLocation?
    
    var searchRadius: Double?
    
    private init() {
        
    #if DEBUG
        print("I m running in debug")
//        ref = Database.database(url: "https://development-db-a8581.firebaseio.com/").reference().child("drivers")
//        requestRef = Database.database(url: "https://development-db-a8581.firebaseio.com/").reference().child("requests")
        
        ref = Database.database().reference().child("drivers")
        requestRef = Database.database().reference().child("requests")
    #else
        ref = Database.database().reference().child("drivers")
        requestRef = Database.database().reference().child("requests")
        print("I m released")
    #endif
     
    }

    func addDriverObservers(radius:Double) {
        print("driver search radius",radius)
        geoRef = GeoFire(firebaseRef: ref)

        if FirebaseObserver.shared.selectedPickupLocation != nil {
            if let pickupLoc = FirebaseObserver.shared.selectedPickupLocation?.coordinate {
                self.query = geoRef.query(at: CLLocation(latitude: pickupLoc.latitude, longitude: pickupLoc.longitude), withRadius: radius)
            }
        } else {
            guard let currentLocation = AppLocationManager.shared.locationManager.location else { return }
            
            self.query = geoRef.query(at: currentLocation, withRadius: radius)
        }

        query?.observe(.keyEntered, with: { key, location in
            self.ref.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: Any]
                DispatchQueue.main.async {
                    self.firebaseDelegate?.driverEnteredFence?(key, location: location, response: value!)
                }
            })
        })

        query?.observe(.keyExited, with: { key, location in
            self.ref.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: Any]
                DispatchQueue.main.async {
                    self.firebaseDelegate?.driverExitedFence?(key, location: location, response: value!)
                }
            })
        })

        query?.observe(.keyMoved, with: { key, location in
            self.ref.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: Any]
                DispatchQueue.main.async {
                    self.firebaseDelegate?.driverMovesInFence?(key, location: location, response: value!)
                }
            })
        })
    }

    func addObserverFor(_ driverKey: String) {
        let driverRef = self.ref.child(driverKey)
        driverRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            if let isActive = value!["is_active"] as? Bool {
                if !isActive {
                    DispatchQueue.main.async {
                        self.firebaseDelegate?.driverWentOffline?(driverKey)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.firebaseDelegate?.driverDataUpdated?(driverKey, response: value!)
                    }
                }
            }
        })
    }

    func addTripObserverFor(_ tripId: String) {
        let tripRef = self.requestRef.child(tripId)
        tripRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            DispatchQueue.main.async {
                if value != nil {
                    self.firebaseDelegate?.tripStatusReceived?(tripId, response: value!)
                }
            }
        })
    }

    func removeObserverFor(_ driverKey: String) {
        let driverRef = self.ref.child(driverKey)
        driverRef.removeAllObservers()
    }

    func removeObservers() {
        if ref != nil {
            ref.removeAllObservers()
        }
    }
}
