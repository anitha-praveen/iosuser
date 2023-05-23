//
//  SupportModel.swift
//  Taxiappz
//
//  Created by spextrum on 29/12/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Kingfisher
import Foundation

enum SupportMenuType: CaseIterable {
    
    case complaint
    case sos
    //case faq
    
    var title:String {
        switch self {
        
        case .complaint:
            return "txt_complaints".localize()
        case .sos:
            return "txt_sos".localize()
//        case .faq:
//            return "text_faq".localize()
        }
    }
    var icon: UIImage? {
        switch self {
        
        case .complaint:
            return UIImage(named: "ic_sidemenu_complaints")
        case .sos:
            return UIImage(named: "ic_sidemenu_sos")
//        case .faq:
//            return UIImage(named: "sidemenufaq")
        }
    }
}
