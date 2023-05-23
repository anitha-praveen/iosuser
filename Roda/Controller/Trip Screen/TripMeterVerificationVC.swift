//
//  TripMeterVerificationVC.swift
//  Roda
//
//  Created by Apple on 14/07/22.
//

import UIKit

class TripMeterVerificationVC: UIViewController {

    private let tripMeterView = TripMeterVerificationView()
    
    var meterImage: String?
    var tripStartKm: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        tripMeterView.setupViews(Base: self.view)
        tripMeterView.actionDelegate = self
        setupData()
    }
    
    func setupData() {
        if let image = self.meterImage, let startkm = self.tripStartKm {
            tripMeterView.setData(Image: image, startkm: startkm)
        }
    }
   
}

//MARK: - Action's
extension TripMeterVerificationVC: TripMeterVerificationActionDelegate {
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
