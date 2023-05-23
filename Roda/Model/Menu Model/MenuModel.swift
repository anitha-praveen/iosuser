//
//  MenuModel.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import UIKit
import Kingfisher
import Foundation

enum MenuType: CaseIterable {
   
    case home
    case history
    //case wallet
    case notification
    case support
    //case suggestion
    case referral
    case selectLanguages
    case aboutus
   
    var title:String {
        switch self {
        case .home:
            return "txt_Home".localize()
        case .history:
            return "txt_my_rides".localize()
//        case .wallet:
//            return "txt_wallet".localize()
        case .notification:
            return "txt_noitification".localize()
        case .support:
            return "txt_support".localize()
//        case .suggestion:
//            return "txt_suggestion_title".localize()
        case .referral:
            return "text_refferal".localize()
        case .selectLanguages:
            return "txt_Lang".localize()
        case .aboutus:
            return "txt_about_us".localize()
        
        }
    }
    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "ic_sidemenu_home")
        case .history:
            return UIImage(named: "ic_sidemenu_myrides")
//        case .wallet:
//            return UIImage(named: "sidemenuhistory")
        case .notification:
            return UIImage(named: "ic_sidemenu_notification")
        case .support:
            return UIImage(named: "ic_sidemenu_support")
//        case .suggestion:
//            return UIImage(named: "sidemenusuggestion")
        case .referral:
            return UIImage(named: "ic_sidemenu_referral")
        case .selectLanguages:
            return UIImage(named: "ic_sidemenu_language")
        case .aboutus:
            return UIImage(named: "ic_sidemenu_aboutus")
       
        }
    }
}
