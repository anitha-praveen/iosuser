//
//  AppLocationManager.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import Foundation
import CoreLocation
import Alamofire
import GoogleMaps

@objc protocol AppLocationManagerDelegate {
    func appLocationManager(didUpdateLocations locations: [CLLocation])
    @objc optional func appLocationManager(didUpdateHeading newHeading: CLHeading)
     @objc optional func applocationManager(didChangeAuthorization status: CLAuthorizationStatus)
}

class AppLocationManager:NSObject,CLLocationManagerDelegate {
    static let shared = AppLocationManager()
    var delegate:AppLocationManagerDelegate?
    var locationManager = CLLocationManager()
    var currentHeading: CLHeading?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func stopTracking() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
    }

    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("locationManager didVisit")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError")
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("locationManager didExitRegion")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("locationManager didEnterRegion")
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        print("locationManagerShouldDisplayHeadingCalibration")
        return false
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("locationManager didStartMonitoringFor")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        self.currentHeading = newHeading
        delegate?.appLocationManager?(didUpdateHeading: newHeading)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        delegate?.appLocationManager(didUpdateLocations: locations)
    }

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("locationManager didFinishDeferredUpdatesWithError")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       
        delegate?.applocationManager?(didChangeAuthorization: status)

        print("locationManager didChangeAuthorization")
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("locationManager didDetermineState")
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("locationManager didRangeBeacons")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("locationManager monitoringDidFailFor")
    }

    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("locationManager rangingBeaconsDidFailFor")
    }

    
}

extension UIViewController {
    
    func getaddress(_ position:CLLocationCoordinate2D,completion:@escaping (String)->()) {
        let userLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { placemarks, _ in
            if let placeArray = placemarks, !placeArray.isEmpty {
                if let placemark = placemarks?.first {
                    let outputString = [placemark.subThoroughfare,
                                        placemark.thoroughfare,
                                        placemark.subLocality,
                                        placemark.locality,
                                        placemark.postalCode,
                                        placemark.country].compactMap { $0 }.joined(separator: ", ")
                    completion(outputString)
                }
            } else {
                self.getaddressFromGoogle(position, completion: { address in
                    completion(address)
                })
            }
        })
    }
    
    func getaddressFromGoogle(_ position:CLLocationCoordinate2D,completion:@escaping (String)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
           
            let queryItems = [URLQueryItem(name: "latlng", value: "\(position.latitude),\(position.longitude)"),URLQueryItem(name: "key", value: APIHelper.shared.gmsServiceKey)]
           
            let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/geocode/json", queryItem: queryItems)
        
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                  
                    print(response.result.value as AnyObject)
                   
                    if let result = response.result.value as? [String:AnyObject] {
                        if let status = result["status"] as? String, status == "OK" {
                            if let results = result["results"] as? [[String:AnyObject]] {
                                print(results)
                                if let result = results.first {
                                    print(result)
                                    if let address = result["formatted_address"] as? String {
                                        completion(address)
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func getCoordinates(_ address:String,placeId: String,completion:@escaping (CLLocationCoordinate2D)->()) {
        let gCoder = CLGeocoder()
        gCoder.geocodeAddressString(address) { (placeMarks, error) in
            if error != nil {
                self.getCoordFromGoogle(placeId) { (location) in
                    completion(location)
                }
            } else {
                if let placeMarks = placeMarks, !placeMarks.isEmpty {
                    if let coord = placeMarks.first?.location?.coordinate {
                        completion(coord)
                    }
                } else {
                    self.getCoordFromGoogle(placeId) { (location) in
                        completion(location)
                    }
                }
            }
        }
    }
    
    func getCoordFromGoogle(_ placeId:String,completion:@escaping (CLLocationCoordinate2D)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            let queryItem = [URLQueryItem(name: "place_id", value: "\(placeId)"),
                             URLQueryItem(name: "key", value: APIHelper.shared.gmsServiceKey)]
            let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/geocode/json", queryItem: queryItem)
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    print(response.result.value as AnyObject)   // result of response serialization
                    if let result = response.result.value as? [String:AnyObject] {
                        if let status = result["status"] as? String, status == "OK" {
                            if let results = result["results"] as? [[String:AnyObject]] {
                                print(results)
                                if let result = results.first {
                                    print(result)
                                    if let geo = result["geometry"] as? [String:AnyObject],let loc = geo["location"]as? [String:AnyObject] {
                                        if let lat = loc["lat"] as? Double,let long = loc["lng"] as? Double {
                                            let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                                completion(coord)
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        } else {
            print("disConnected")
        }
    }
}

extension URLComponents {
  
    func googleURLComponents(_ path: String,queryItem: [URLQueryItem]) -> String {
        APIHelper.googleApiComponents.scheme = "https"
        APIHelper.googleApiComponents.host = "maps.googleapis.com"
        APIHelper.googleApiComponents.path = path
        APIHelper.googleApiComponents.queryItems = queryItem
        if let url = APIHelper.googleApiComponents.url {
            return url.absoluteString
        } else {
            return ""
        }
       
    }
}

//Haversine function to get bearing between 2 locations
extension CLLocationCoordinate2D {
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude)
        let lon2 = degreesToRadians(point.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radiansBearing)
    }
}

public class AnimatedPolyLine: GMSPolyline {
    var animationPolyline = GMSPolyline()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    private var repeats:Bool!
    override init() {
        super.init()
    }
    deinit {
        print("de init called")
    }
    convenience init(_ points: String,repeats:Bool) {
        self.init()
        self.repeats = repeats
        self.path = GMSPath.init(fromEncodedPath: points)!
        self.strokeColor = .red
        self.strokeWidth = 4.0
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        let count = self.path!.count()
       
        let interval = count < 200 ? 0.1 : 0.01
        self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
    }
    @objc func animatePolylinePath(_ sender:Timer) {
        
        if self.i < (self.path?.count())! {
            self.animationPath.add((self.path?.coordinate(at: self.i))!)
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.themeColor
            self.animationPolyline.strokeWidth = 4
            self.animationPolyline.map = self.map
            self.i += 1
        } else {
            if self.repeats {
                self.i = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }
            else {
                sender.invalidate()
                if self.timer != nil
                {
                    self.timer = nil
                }
            }
        }

    }
}
