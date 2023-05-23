//
//  AboutusModel.swift
//  Roda
//
//  Created by Apple on 13/05/22.
//

import Foundation
import UIKit

enum AboutusList: CaseIterable {
    
    case rateApp
    case facebook
    case legal
   
    var title:String {
        switch self {
        
        case .rateApp:
            return "txt_rate_the_app".localize()
        case .facebook:
            return "txt_like_on_fb".localize()
        case .legal:
            return "txt_plain_legal".localize()

        }
    }
    var icon: UIImage? {
        switch self {
        
        case .rateApp:
            return UIImage(named: "ic_rate_app")
        case .facebook:
            return UIImage(named: "ic_like_us")
        case .legal:
            return UIImage(named: "ic_terms_condition")
        }
    }
}
