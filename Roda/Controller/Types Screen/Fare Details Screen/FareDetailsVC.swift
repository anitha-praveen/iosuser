//
//  FareDetailsVC.swift
//  Petra Ride
//
//  Created by Spextrum on 03/05/19.
//  Copyright © 2019 Mohammed Arshad. All rights reserved.
//

import UIKit
import Kingfisher

class FareDetailsVC: UIViewController {
    
    let fareDetailsView = FareDetailView()
    var result: [String:AnyObject]?
    
    var currency = ""
    var selectedNewCarModel: NewCarModel?
    
    typealias InvoiceContent = (key: String, value: String)
    var invoiceDetails = [InvoiceContent]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    func setupViews() {
        self.fareDetailsView.setupViews(Base: self.view)
        self.fareDetailsView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        self.fareDetailsView.lblTypeName.text = self.selectedNewCarModel?.typeName
        if let img = self.selectedNewCarModel?.iconResource {
            self.fareDetailsView.imgVehicleType.kf.setImage(with: img)
        }
        if self.selectedNewCarModel?.isPromoApplied ?? false {
            self.fareDetailsView.lblTotalAmount.text = currency + " " + (self.selectedNewCarModel?.promoTotalAmount ?? "")
        } else {
            self.fareDetailsView.lblTotalAmount.text = currency + " " + (self.selectedNewCarModel?.totalAmount ?? "")
        }
        
        let baseDistance = selectedNewCarModel?.baseDistance ?? ""
        invoiceDetails.append((key: "text_base_price".localize() + "\n(for " + baseDistance + " km)", value: currency + " " + (selectedNewCarModel?.basePrice ?? "")))
        
        
        let computedDistance = selectedNewCarModel?.computedDistance ?? ""
        let ratePerKm = selectedNewCarModel?.pricePerDistance ?? ""
        let kmNote = computedDistance + "*" + ratePerKm  + ")"
        if selectedNewCarModel?.computedDistance != nil {
            invoiceDetails.append((key: "txt_RateperKm".localize() + "\n(for " + kmNote , value: currency + " " + (selectedNewCarModel?.computedPrice ?? "")))
        }
        
        invoiceDetails.append((key: "txt_booking_fee".localize(), value: currency + " " + (selectedNewCarModel?.bookingFee ?? "")))
        
        if selectedNewCarModel?.waitingPrice != "0" {
            invoiceDetails.append((key: "txt_waiting_header".localize() + "\n(" + "txt_per_min_price".localize() + ")" , value: currency + " " + (selectedNewCarModel?.waitingPrice ?? "")))
        }
        
        if selectedNewCarModel?.pricePerTime != "0" {
            invoiceDetails.append((key: "txt_Ridetime".localize(), value: currency + " " + (selectedNewCarModel?.pricePerTime ?? "")))
        }
        if selectedNewCarModel?.outOfZoneFee != "0" {
            invoiceDetails.append((key: "text_zone_fees".localize(), value: currency + " " + (selectedNewCarModel?.outOfZoneFee ?? "")))
        }
    
        if let promoBonus = selectedNewCarModel?.promoBonus {
            invoiceDetails.append((key: "text_promo_bonus".localize(), value: "-" + currency + " " + (promoBonus)))
        }
        
        
        self.invoiceDetails.forEach({
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
            
//            let stackNote = UIStackView()
//            lblValue.translatesAutoresizingMaskIntoConstraints = false
//            viewData.addSubview(lblValue)
            
            self.fareDetailsView.stackvw.addArrangedSubview(viewData)
            
            viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lbl]-8-[lblValue]|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
            lblValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            viewData.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbl(>=30)]-8-|", options: [], metrics: nil, views: ["lbl":lbl,"lblValue":lblValue]))
            
        })
        
    }
    
    @objc func btnConfirmPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
