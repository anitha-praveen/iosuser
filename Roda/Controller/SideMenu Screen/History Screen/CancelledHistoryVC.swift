//
//  cancelledhistoryvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 02/03/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import GoogleMaps
import HCSStarRatingView
import NVActivityIndicatorView

class CancelledHistoryVC: UIViewController {
    
    private let cancelledView = CancelledDetailsView()
    
    var rideHistory: HistroyDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
        self.setupdata()
        
        self.setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
    }
    
    func setUpViews() {
        cancelledView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        
        self.cancelledView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        self.cancelledView.cancelBtn.addTarget(self, action: #selector(cancelBtnPressed(_ :)), for: .touchUpInside)
    }

}

extension CancelledHistoryVC {
    @objc func backBtnAction(_ sender: UIButton) {
        self.rideHistory = nil
        self.navigationController?.popViewController(animated: true)
    }
    @objc func cancelBtnPressed(_ sender: UIButton) {
       
    }
}

extension CancelledHistoryVC {

    func setupdata() {
        
        if let driverdict = self.rideHistory?.driverDetail {
            
            if let urlStr = driverdict.userProfilePicUrlStr, let url = URL(string:urlStr) {
                let resource = ImageResource(downloadURL: url)
                self.cancelledView.driverprofilepicture.kf.setImage(with: resource)
                self.cancelledView.driverprofilepicture.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"))
            } else {
                self.cancelledView.driverprofilepicture.image = UIImage(named: "profilePlaceHolder")
            }
            
            if let fname = driverdict.firstName, let lname = driverdict.lastName {
                self.cancelledView.drivernamelbl.text = fname + " " + lname
            } else {
                self.cancelledView.drivernamelbl.text = "----"
            }
            
        }
        if let starrat = self.rideHistory?.driverRating {
            cancelledView.ratingLbl.text = starrat
        }
        
        if let car = self.rideHistory?.typeName ,let res = self.rideHistory?.requestId {
            self.cancelledView.carLbl.text = car + " ( " + res + " )"
        }
        
        if let pickLocation = self.rideHistory?.pickLocation {
            self.cancelledView.pickupaddrlbl.text=pickLocation
        }
        if let dropLocation = self.rideHistory?.dropLocation {
            self.cancelledView.dropupaddrlbl.text = dropLocation
        }
        if let time = self.rideHistory?.tripStartTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            if let date = dateFormatter.date(from: time) {
                dateFormatter.dateFormat = "EEE,MMM dd, hh:mm a"
                self.cancelledView.dateTimeLbl.text = dateFormatter.string(from: date)
            }
        }
        
    }
}

extension CancelledHistoryVC {
  
    func forceLogout() {
        if let root = self.navigationController?.revealViewController().navigationController {
            let firstvc = Initialvc()
            root.view.showToast("text_already_login".localize())
            root.setViewControllers([firstvc], animated: false)
        }
        AppLocationManager.shared.stopTracking()
        APIHelper.shared.deleteUser()
    }
}

