//
//  OutstationFareDetailsVC.swift
//  Roda
//
//  Created by Apple on 13/05/22.
//

import UIKit

class OutstationFareDetailsVC: UIViewController {

    let fareDetailView = OutstationFareDetailView()
    
    var selectedStation: OutstationList?
    var selectedStationTypes: OutstationTypes?
    var isTwoWayTrip: Bool = false
    
    typealias priceData = (key: String, value: String)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fareDetailView.setupViews(Base: self.view)
        fareDetailView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed(_ :)), for: .touchUpInside)
        setupData()
    }
    
    func setupData() {
        
        self.fareDetailView.lblTotalHint.text = "txt_both_up_down_desc".localize()
      
        if self.selectedStationTypes?.isPromoApplied ?? false {
            self.fareDetailView.lblTotalAmount.text = (self.selectedStationTypes?.currency ?? "") + " " + (self.selectedStationTypes?.promoTotalAmount ?? "")
        } else {
            self.fareDetailView.lblTotalAmount.text = (self.selectedStationTypes?.currency ?? "") + " " + (self.selectedStationTypes?.totalAmount ?? "")
        }
        
        var priceDatas = [priceData]()
        var currency = self.selectedStationTypes?.currency ?? ""
        if let distance = self.selectedStationTypes?.distance {
            
            var pricePerKm = ""
            let totDist = (Double(distance) ?? 0) * 2
            var kmPrice: Double = 0.0
            if self.isTwoWayTrip {
                if let pricePerkm = self.selectedStationTypes?.twoWayDistancePrice {
                    pricePerKm = pricePerkm
                    kmPrice = Double(pricePerkm) ?? 0
                }
            } else {
                if let pricePerkm = self.selectedStationTypes?.distancePrice {
                    pricePerKm = pricePerkm
                    kmPrice = Double(pricePerkm) ?? 0
                }
            }
            let totPrice = totDist * kmPrice
            priceDatas.append((key: "text_distance_cost".localize() + " ((\(distance) * 2) * \(pricePerKm))", value: currency + "\(totPrice)"))
        }
        
        
        if self.isTwoWayTrip {
            if let driverBeta = self.selectedStationTypes?.driverBeta {
                priceDatas.append((key: "txt_day_rent".localize(), value: currency + driverBeta))
            }
        } else {
            if let driverBeta = self.selectedStationTypes?.driverBeta {
                priceDatas.append((key: "txt_driver_beta".localize(), value: currency + driverBeta))
            }
        }
        
        if self.selectedStation?.hillStation == "YES" {
            if let hillPrice = self.selectedStationTypes?.hillPrice {
                priceDatas.append((key: "txt_hill_price".localize(), value: currency + hillPrice))
            }
        }
        
        priceDatas.forEach({
            let viewData = UIView()
            let lbl = UILabel()
            lbl.text = $0.key
            lbl.numberOfLines = 0
            lbl.lineBreakMode = .byWordWrapping
            lbl.textColor = .hexToColor("525151")
            lbl.font = UIFont.appRegularFont(ofSize: 14)
            lbl.textAlignment = APIHelper.appTextAlignment
            lbl.translatesAutoresizingMaskIntoConstraints = false
            viewData.addSubview(lbl)
            
            let lblValue = UILabel()
            lblValue.text = $0.value
            lblValue.textColor = .hexToColor("525151")
            lblValue.font = UIFont.appBoldFont(ofSize: 16)
            lblValue.textAlignment = APIHelper.appTextAlignment
            lblValue.translatesAutoresizingMaskIntoConstraints = false
            viewData.addSubview(lblValue)
            
            
            self.fareDetailView.stackPrice.addArrangedSubview(viewData)
            
            viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lbl]-8-[lblValue]|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
            lblValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl]-5-|", options: [], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
            
        })
        
       
        let descriptionArray = ["txt_execludes_toll".localize(),
                                "txt_return_empty_charge".localize(),
                                "txt_ex_interstate_permits".localize(),
                                "txt_drop_extra_charges".localize(),
                                "txt_rental_grace_time_desc".localize()]
        
        descriptionArray.forEach({
            let lblValue = UILabel()
            lblValue.text = "- " + $0
            lblValue.numberOfLines = 0
            lblValue.lineBreakMode = .byWordWrapping
            lblValue.textColor = .hexToColor("525151")
            lblValue.font = UIFont.appRegularFont(ofSize: 13)
            lblValue.textAlignment = APIHelper.appTextAlignment
            lblValue.translatesAutoresizingMaskIntoConstraints = false
            self.fareDetailView.stackview.addArrangedSubview(lblValue)
        })
        
    }
    
    @objc func btnConfirmPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
