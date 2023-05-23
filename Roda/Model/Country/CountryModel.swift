//
//  File.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import Foundation
import UIKit
protocol CountryPickerDelegate: AnyObject {
    func selectedCountry(_ country: CountryList)
}

struct CountryList {
    var id: String?
    var dialCode: String?
    var countryName: String?
    var isoCode: String?
    var flag: UIImage?
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let code = dict["dial_code"] {
            self.dialCode = "\(code)"
        }
        if let name = dict["name"] as? String {
            self.countryName = name
        }
        if let iso = dict["code"] as? String {
            self.isoCode = "\(iso)"
        }
        
        if let flagStr = dict["flag_base_64"] as? String {
            if let dataDecoded : Data = Data(base64Encoded: flagStr) {
                self.flag = UIImage(data: dataDecoded)
            }
        }
    }
}
