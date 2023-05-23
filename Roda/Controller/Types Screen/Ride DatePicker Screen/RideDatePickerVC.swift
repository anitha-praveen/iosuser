//
//  RideDatePickerVC.swift
//  Taxiappz
//
//  Created by Apple on 18/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
enum RideLaterType {
    case later
    case now
}

class RideDatePickerVC: UIViewController {
    
    let scheduleView = RideDatePickerView()

    var currency = ""
    
    var scheduleTripMinTime: Int?
    
    var selectedDate: Date?
    
    var isForReturnDate = false
    
    var rideLaterType: RideLaterType = .later
    var callBack:((Date, RideLaterType)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let date = self.selectedDate {
            self.scheduleView.datePicker.date = date
        }
        
        
        setupViews()
        
        if self.isForReturnDate {
            self.scheduleView.viewHint.isHidden = true
            self.scheduleView.lblHeader.text = "Return Date"
        }
        
    }
    
    func setupViews() {
        scheduleView.setupViews(Base: self.view)
        scheduleView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed), for: .touchUpInside)
        scheduleView.btnReset.addTarget(self, action: #selector(btnResetPressed), for: .touchUpInside)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scheduleView.viewContent.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func btnConfirmPressed(_ sender: UIButton) {
        self.callBack?(scheduleView.datePicker.date, .later)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnResetPressed(_ sender: UIButton) {
        self.scheduleView.datePicker.date = Date()
        self.callBack?(scheduleView.datePicker.date, .now)
        self.dismiss(animated: true, completion: nil)
    }
    
}
