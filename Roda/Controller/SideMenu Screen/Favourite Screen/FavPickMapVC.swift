//
//  FavPickMapVC.swift
//  Taxiappz
//
//  Created by Ram kumar on 01/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import NVActivityIndicatorView

protocol selectedLocationDelegate: AnyObject {
    func selectAddress(address: String?)
    func selectedLat(lat: String?)
    func selectedLong(long: String?)
}

class FavPickMapVC: UIViewController  {
    
    let topView = UIView()
    let btnBack = UIButton()
    let lblAddress = UILabel()
    let btnSearch = UIButton()
    
    let mapview = GMSMapView()
    let markerImg = UIImageView()
    let btnCurrentLocation = UIButton()

    weak var delegate: selectedLocationDelegate?

    let btnConfirmLocation = UIButton()
    var selectedMarkerLocation: SearchLocation?

    var layoutDict = [String: AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondaryColor
        self.navigationController?.navigationBar.isHidden = true
        currentLocation()
        setupViews()

    }
    
    func setupViews() {
        
        topView.addShadow()
        topView.backgroundColor = .secondaryColor
        layoutDict["topView"] = topView
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topView)
        
        btnBack.setImage(UIImage(named: "ic_back"), for: .normal)
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(btnBack)
        
        lblAddress.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblAddress"] = lblAddress
        lblAddress.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(lblAddress)
        
        btnSearch.setImage(UIImage(named: "ic_search"), for: .normal)
        layoutDict["btnSearch"] = btnSearch
        btnSearch.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(btnSearch)
        
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            self.mapview.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        } else {
            print("Unable to find mapStyle.json")
        }
        mapview.delegate = self
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapview)
        
        markerImg.image = UIImage(named:"ic_flagMarker")
        layoutDict["markerImg"] = markerImg
        markerImg.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(markerImg)
        
        btnConfirmLocation.setTitle("txt_con_loc".localize().uppercased(), for: .normal)
        btnConfirmLocation.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnConfirmLocation.setTitleColor(.secondaryColor, for: .normal)
        btnConfirmLocation.layer.cornerRadius = 5
        btnConfirmLocation.backgroundColor = .themeColor
        layoutDict["btnConfirmLocation"] = btnConfirmLocation
        btnConfirmLocation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnConfirmLocation)
        
        btnCurrentLocation.setImage(UIImage(named: "ic_navigation"), for: .normal)
        layoutDict["btnCurrentLocation"] = btnCurrentLocation
        btnCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnCurrentLocation)
        
        btnConfirmLocation.addTarget(self, action: #selector(btnConfirmLocationPressed(_ :)), for: .touchUpInside)
        btnSearch.addTarget(self, action: #selector(btnSearchLocationPressed(_ :)), for: .touchUpInside)
        btnCurrentLocation.addTarget(self, action: #selector(currentLocation), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        
        
        mapview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        btnConfirmLocation.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[topView][mapview]", options: [], metrics: nil, views: layoutDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[topView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        topView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnBack(30)]-10-[lblAddress]-10-[btnSearch(30)]-20-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        topView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[lblAddress(30)]-20-|", options: [], metrics: nil, views: layoutDict))
        
        
        markerImg.widthAnchor.constraint(equalToConstant: 70).isActive = true
        markerImg.heightAnchor.constraint(equalToConstant: 80).isActive = true
        markerImg.centerXAnchor.constraint(equalTo: mapview.centerXAnchor, constant: 0).isActive = true
        markerImg.centerYAnchor.constraint(equalTo: mapview.centerYAnchor, constant: 0).isActive = true
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnCurrentLocation(50)]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnCurrentLocation(50)]-40-[btnConfirmLocation(48)]", options: [], metrics: nil, views: layoutDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnConfirmLocation]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

    }
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.selectedMarkerLocation = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSearchLocationPressed(_ sender: UIButton) {
        let vc = SearchLocationVC()
      
        vc.selectedLocation = { [weak self] selectedSearchLoc in
            self?.lblAddress.text = selectedSearchLoc.placeId
            self?.selectedMarkerLocation = selectedSearchLoc
            if selectedSearchLoc.locationType == .googleSearch {
                
                if let googlePlaceId = selectedSearchLoc.googlePlaceId {
                   
                    self?.getCoordinates(selectedSearchLoc.placeId ?? "", placeId: googlePlaceId, completion: { (location) in
                        self?.selectedMarkerLocation?.latitude = location.latitude
                        self?.selectedMarkerLocation?.longitude = location.longitude
                        self?.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    })
                }
            }
            else {
                if let lat = selectedSearchLoc.latitude, let long = selectedSearchLoc.longitude {
                    self?.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnConfirmLocationPressed(_ sender: UIButton) {

        delegate?.selectAddress(address: self.selectedMarkerLocation?.placeId)
        delegate?.selectedLat(lat: String(self.mapview.camera.target.latitude))
        delegate?.selectedLong(long: String(self.mapview.camera.target.longitude))
        self.navigationController?.popViewController(animated: true)

    }
    @objc func currentLocation() {

        guard let currentLoc = AppLocationManager.shared.locationManager.location else {
            return
        }
        self.selectedMarkerLocation = SearchLocation(currentLoc.coordinate)
        self.getaddress(currentLoc.coordinate) { address in
            self.selectedMarkerLocation?.placeId = address
            self.lblAddress.text = self.selectedMarkerLocation?.placeId
        }
        let camera = GMSCameraPosition.camera(withLatitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, zoom: 18)
        self.mapview.camera = camera
       
        return
    }
   
}
extension FavPickMapVC:GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("moving")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.selectedMarkerLocation = SearchLocation(position.target)
        self.getaddress(position.target) { address in
            self.selectedMarkerLocation?.placeId = address
            DispatchQueue.main.async {
                self.lblAddress.text = self.selectedMarkerLocation?.placeId
                
            }
        }
        
    }
}
