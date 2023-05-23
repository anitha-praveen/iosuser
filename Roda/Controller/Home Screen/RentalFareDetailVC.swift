//
//  RentalFareDetailVC.swift
//  Roda
//
//  Created by Apple on 11/07/22.
//

import UIKit

class RentalFareDetailVC: UIViewController {

    let fareDetailView = RentalFareDetailView()
    var selectedPackageType: RentalPackageType?
    var selectedPackage: RentalPackageList?
    override func viewDidLoad() {
        super.viewDidLoad()

        fareDetailView.setupViews(Base: self.view)
        fareDetailView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed(_ :)), for: .touchUpInside)
        setupData()
    }
    
    func setupData() {
        
        if self.selectedPackageType?.isPromoApplied ?? false {
            self.fareDetailView.lblTotalAmount.text = (self.selectedPackageType?.currency ?? "") + " " + (self.selectedPackageType?.totalPromoAmount ?? "")
        } else {
            self.fareDetailView.lblTotalAmount.text = (self.selectedPackageType?.currency ?? "") + " " + (self.selectedPackageType?.totalAmout ?? "")
        }
        
        //fareDetailView.lblTotalAmount.text = (self.selectedPackageType?.currency ?? "") + (self.selectedPackageType?.totalAmout ?? "")
        
        fareDetailView.lblTotalHint.text = (self.selectedPackage?.hours ?? "") + " " + (self.selectedPackage?.distance ?? "")
        
        let descriptionArray = ["txt_exclude_toll_parking".localize(),
                                "txt_extra_km_rental_desc".localize(),
                                "txt_outzone_rental_desc".localize()]
        
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
