//
//  Historydetailsvc.swift
//  tapngo
//
//  Created by Mohammed Arshad on 19/02/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import GoogleMaps
import Kingfisher
import HCSStarRatingView

class Historydetailsvc: UIViewController {
    
    private let historyDetailsView = HistoryDetailsView()

    var currency: String?
    
    typealias InvoiceContent = (key:String,value:String, textColor:UIColor, note: String?)
    var invoiceContents = [InvoiceContent]()
    
    var rideHistory: HistroyDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpViews()
        setupDriverData()
        setupInvoiceData()
        
    }
    
    func setUpViews() {
        self.historyDetailsView.setupViews(Base: self.view)
        self.setupTarget()
        
    }
    
    func setupTarget() {
       
        historyDetailsView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
    }
}

extension Historydetailsvc {

    @objc func backBtnAction(_ sender: UIButton){
        self.rideHistory = nil
        self.currency = nil
        self.navigationController?.popViewController(animated: true)
    }
}

extension Historydetailsvc {
   
    func setupDriverData() {
        if let driverdict = self.rideHistory?.driverDetail {
            if let firstName = driverdict.firstName {
                self.historyDetailsView.drivernamelbl.text = firstName.localizedCapitalized
            }
            
            if let imgStr = driverdict.userProfilePicUrlStr, let url = URL(string: imgStr) {
                self.historyDetailsView.driverprofilepicture.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                self.historyDetailsView.driverprofilepicture.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                self.historyDetailsView.driverprofilepicture.image = UIImage(named: "profilePlaceHolder")
            }
            
// Using S3
//            if let urlStr = driverdict.userProfilePicUrlStr {
//                self.retriveImgFromBucket(key: urlStr) { img in
//                    self.historyDetailsView.driverprofilepicture.image = img
//                }
//
//            }
        }
        
        if let typeName = self.rideHistory?.typeName {
            self.historyDetailsView.lblVehicleTypeName.text = typeName
        }
        if let vehicleNum = self.rideHistory?.carDetail?.carNumber {
            self.historyDetailsView.lblVehicleNumber.text =  vehicleNum
        }
        
        if let vehicleImage = self.rideHistory?.vehicleHighLightImage {
            if let url = URL(string: vehicleImage) {
                let resource = ImageResource(downloadURL: url)
                self.historyDetailsView.vehicleImageView.kf.setImage(with: resource)
            }
        }
        if let rating = self.rideHistory?.driverRating  {
            self.historyDetailsView.ratingLbl.set(text: rating, with: UIImage(named: "star"))
        }
        
        if let picklocation = self.rideHistory?.pickLocation {
            self.historyDetailsView.pickupaddrlbl.text = picklocation
        }
        if let droplocation = self.rideHistory?.dropLocation {
            self.historyDetailsView.dropupaddrlbl.text = droplocation
        }
      
        if let distance = self.rideHistory?.totalDistance, let unit = self.rideHistory?.distanceUnit {
            self.historyDetailsView.lblDistance.text = "\(distance)" + unit
        }
        if let time = self.rideHistory?.totalTime  {
            
            if let minTime = Int("\(time)") {
                if minTime <= 1 {
                    let mins = " " + "1 " + "txt_min".localize()
                    self.historyDetailsView.tripTimeLbl.text = mins
                } else if minTime < 60 {
                    let mins = " " + "\(minTime) " + "txt_min".localize()
                    self.historyDetailsView.tripTimeLbl.text = mins
                    
                } else {
                    let hours = minTime / 60
                    let minutes = minTime % 60
                    
                    let mins = " " + "\(hours) " + "txt_hr".localize() + "\(minutes) " + "txt_min".localize()
                    self.historyDetailsView.tripTimeLbl.text = mins
                }
            } else {
                self.historyDetailsView.tripTimeLbl.text = "\(time)" + "txt_min".localize()
            }
        }
        if let time = self.rideHistory?.tripStartTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            if let date = dateFormatter.date(from: time) {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.historyDetailsView.dateLbl.text = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "hh:mm a"
                self.historyDetailsView.timeLbl.text = dateFormatter.string(from: date)
                
            }
        }
        if let endTime = self.rideHistory?.tripEndTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            if let date = dateFormatter.date(from: endTime) {
                dateFormatter.dateFormat = "hh:mm a"
                self.historyDetailsView.endTimeLbl.text = dateFormatter.string(from: date)
            }
            
            if let serviceCategory = self.rideHistory?.serviceCategory, serviceCategory == "OUTSTATION" {
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                if let date = dateFormatter.date(from: endTime) {
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    self.historyDetailsView.endTimeLbl.text = dateFormatter.string(from: date)
                    dateFormatter.dateFormat = "hh:mm a"
                    self.historyDetailsView.tripTimeLbl.text = dateFormatter.string(from: date)
                    
                }
            }
        }
        
        
    }
}
extension Historydetailsvc {
    func setupInvoiceData() {
        
        if let currency = self.rideHistory?.requestBill?.currency {
            self.currency = currency
        }
        if let total = self.rideHistory?.requestBill?.totalAmount {
            self.historyDetailsView.totalValueLbl.text = (self.currency ?? "") + " " + total
            self.historyDetailsView.lblTripAmount.text = (self.currency ?? "") + total
        }
        
        
        if let serviceCategory = self.rideHistory?.serviceCategory, serviceCategory == "OUTSTATION" {
           
            if let basePrice = self.rideHistory?.requestBill?.basePrice {
                if self.rideHistory?.outStationTripType == "ONE" {
                    invoiceContents.append((key:"txt_driver_beta".localize(),
                                            value:(currency ?? "") + " " + basePrice, textColor:UIColor.darkGray,note: nil))
                } else {
                    invoiceContents.append((key:"txt_day_rent".localize(),
                                            value:(currency ?? "") + " " + basePrice, textColor:UIColor.darkGray,note: nil))
                }
                
            }
            
            if let distancePrice = self.rideHistory?.requestBill?.distancePrice {
                
                if let totDistance = self.rideHistory?.requestBill?.totalDistance, let pricePerDist = self.rideHistory?.requestBill?.pricePerDistance {
                    if self.rideHistory?.outStationTripType == "ONE" {
                        invoiceContents.append((key:"text_distance_cost".localize(),
                                                value:(self.currency ?? "") + " " + distancePrice, textColor:UIColor.darkGray,note: "(\(totDistance) km * \(pricePerDist))"))
                    } else {
                        invoiceContents.append((key:"text_distance_cost".localize(),
                                                value:(self.currency ?? "") + " " + distancePrice, textColor:UIColor.darkGray,note: "(\(totDistance) km * \(pricePerDist))"))
                    }
                }
   
            }
            if let timePrice = self.rideHistory?.requestBill?.timePrice {
                invoiceContents.append((key:"text_time_cost".localize(),
                                        value:(self.currency ?? "") + " " + timePrice, textColor:UIColor.darkGray,note: nil))
            }
        } else if let serviceCategory = self.rideHistory?.serviceCategory, serviceCategory == "RENTAL" {
            
            if let basePrice = self.rideHistory?.requestBill?.basePrice {
                if let hrs = self.rideHistory?.requestBill?.rentalRidePackageHour, let kms = self.rideHistory?.requestBill?.rentalRidePackageKm {
                   
                    invoiceContents.append((key:"txt_package_cost".localize(),
                                            value:(currency ?? "") + " " + basePrice, textColor:UIColor.darkGray,note: "(\(hrs) hr \(kms) km)"))
                } else {
                    invoiceContents.append((key:"txt_package_cost".localize(),
                                            value:(currency ?? "") + " " + basePrice, textColor:UIColor.darkGray,note: nil))
                }
            }
            
            if let distancePrice = self.rideHistory?.requestBill?.distancePrice {
                if let pendingKm = self.rideHistory?.requestBill?.rentalRidePendingKm {
                    invoiceContents.append((key:"text_distance_cost".localize(),
                                            value:(self.currency ?? "") + " " + distancePrice, textColor:UIColor.darkGray,note: "(\(pendingKm) km * \(self.rideHistory?.requestBill?.pricePerDistance ?? ""))"))
                } else {
                    invoiceContents.append((key:"text_distance_cost".localize(),
                                            value:(self.currency ?? "") + " " + distancePrice, textColor:UIColor.darkGray,note: nil))
                }
                
            }
            if let timePrice = self.rideHistory?.requestBill?.timePrice {
                invoiceContents.append((key:"txt_extra_time_cost".localize(),
                                        value:(self.currency ?? "") + " " + timePrice, textColor:UIColor.darkGray,note: nil))
            }
        } else {
            
            if let basePrice = self.rideHistory?.requestBill?.basePrice {
                invoiceContents.append((key:"text_base_price".localize(),
                                        value:(currency ?? "") + " " + basePrice, textColor:UIColor.darkGray,note: nil))
            }
            
            if let distancePrice = self.rideHistory?.requestBill?.distancePrice {
                invoiceContents.append((key:"text_distance_cost".localize(),
                                        value:(self.currency ?? "") + " " + distancePrice, textColor:UIColor.darkGray,note: nil))
            }
            if let timePrice = self.rideHistory?.requestBill?.timePrice {
                invoiceContents.append((key:"text_time_cost".localize(),
                                        value:(self.currency ?? "") + " " + timePrice, textColor:UIColor.darkGray,note: nil))
            }
        }
        

        if let waitingPrice = self.rideHistory?.requestBill?.waitingPrice {
            invoiceContents.append((key:"waiting_time_price".localize(),
                                    value:(self.currency ?? "") + " " + waitingPrice, textColor:UIColor.darkGray,note: nil))
        }
        if let hillPrice = self.rideHistory?.requestBill?.hillStationPrice {
            invoiceContents.append((key:"txt_hill_price".localize(),
                                    value:(self.currency ?? "") + " " + hillPrice, textColor:UIColor.darkGray,note: nil))
        }
        if let bookingFee = self.rideHistory?.requestBill?.bookingFee {
            invoiceContents.append((key:"txt_booking_fee".localize(),
                                    value:(self.currency ?? "") + " " + bookingFee, textColor:UIColor.darkGray,note: nil))
        }
        if let outZone = self.rideHistory?.requestBill?.outOfZoneFee {
            invoiceContents.append((key:"text_zone_fees".localize(),
                                    value:(self.currency ?? "") + " " + outZone, textColor:UIColor.darkGray,note: nil))
        }
        
        if let promoAmount = self.rideHistory?.requestBill?.promoBonus  {
            
            invoiceContents.append((key:"text_promo_bonus".localize(),
                                    value: "- \((self.currency ?? "")) " + promoAmount, textColor:UIColor.red,note: nil))
            
        }
        if let serviceTax = self.rideHistory?.requestBill?.serviceTax {
            invoiceContents.append((key:"text_setvice_tax".localize() + "txt_includes".localize(),
                                    value:(self.currency ?? "") + " " + serviceTax, textColor:UIColor.darkGray, note: nil))
        }
        
         self.invoiceContents.forEach({
             let viewData = UIView()
             
             let lbl = UILabel()
             lbl.text = $0.key
             lbl.textColor = $0.textColor
             lbl.font = UIFont.appRegularFont(ofSize: 14)
             lbl.textAlignment = APIHelper.appTextAlignment
             lbl.translatesAutoresizingMaskIntoConstraints = false
             viewData.addSubview(lbl)
             
             let lblValue = UILabel()
             lblValue.text = $0.value
             lblValue.textColor = $0.textColor
             lblValue.font = UIFont.appBoldFont(ofSize: 16)
             lblValue.textAlignment = APIHelper.appTextAlignment
             lblValue.translatesAutoresizingMaskIntoConstraints = false
             viewData.addSubview(lblValue)
             
//             let stackNote = UIStackView()
//             stackNote.axis = .vertical
//             stackNote.distribution = .fill
//             stackNote.translatesAutoresizingMaskIntoConstraints = false
//             viewData.addSubview(stackNote)
//
//             let lblNote = UILabel()
//             if $0.note != nil {
//                 lblNote.text = $0.note
//                 lblNote.isHidden = false
//             } else {
//                 lblNote.isHidden = true
//             }
//             lblNote.textColor = $0.textColor
//             lblNote.font = UIFont.appRegularFont(ofSize: 13)
//             lblNote.textAlignment = APIHelper.appTextAlignment
//             lblNote.translatesAutoresizingMaskIntoConstraints = false
//             stackNote.addArrangedSubview(lblNote)
//
//             self.historyDetailsView.stackBill.addArrangedSubview(viewData)
//
//             viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lbl]-8-[lblValue]-8-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
//             lblValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//             viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl(30)][stackNote]-8-|", options: [], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue,"stackNote":stackNote]))
//
//             viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[stackNote]-8-|", options: [], metrics: nil, views: ["stackNote":stackNote]))
//
//             lblNote.heightAnchor.constraint(equalToConstant: 20).isActive = true
             
             if $0.note != nil {
                 
                 let stackNote = UIStackView()
                 stackNote.axis = .vertical
                 stackNote.distribution = .fill
                 stackNote.translatesAutoresizingMaskIntoConstraints = false
                 viewData.addSubview(stackNote)
                 
                 let lblNote = UILabel()
                 if $0.note != nil {
                     lblNote.text = $0.note
                     lblNote.isHidden = false
                 } else {
                     lblNote.isHidden = true
                 }
                 lblNote.textColor = $0.textColor
                 lblNote.font = UIFont.appRegularFont(ofSize: 13)
                 lblNote.textAlignment = APIHelper.appTextAlignment
                 lblNote.translatesAutoresizingMaskIntoConstraints = false
                 stackNote.addArrangedSubview(lblNote)
             
                 self.historyDetailsView.stackBill.addArrangedSubview(viewData)
                 
                 viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lbl]-8-[lblValue]-8-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
                 lblValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                 viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl(30)][stackNote]-8-|", options: [], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue,"stackNote":stackNote]))
                 
                 viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[stackNote]-8-|", options: [], metrics: nil, views: ["stackNote":stackNote]))
                 
                 lblNote.heightAnchor.constraint(equalToConstant: 20).isActive = true
             } else {
                 
                 self.historyDetailsView.stackBill.addArrangedSubview(viewData)
                 
                 viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lbl]-8-[lblValue]-8-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
                 lblValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                 viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl(30)]-8-|", options: [], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
                 
             }
             
         })
        
        if let serviceCategory = self.rideHistory?.serviceCategory, serviceCategory == "OUTSTATION" || serviceCategory == "RENTAL" {
            if let startkm = self.rideHistory?.outStationTripStartkm {
                self.historyDetailsView.lblOutstationStartkmValue.text = "\(startkm)"
            }
            if let endkm = self.rideHistory?.outStationTripEndkm {
                self.historyDetailsView.lblOutstationEndkmValue.text = "\(endkm)"
            }
            self.historyDetailsView.viewOutstationDetail.isHidden = false
        } else {
            self.historyDetailsView.viewOutstationDetail.isHidden = true
        }
    }
}

extension Historydetailsvc {
    
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
class Myscrollview: UIScrollView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.y > 0
    }
    
}
