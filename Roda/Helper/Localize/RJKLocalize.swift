//
//  RJKLocalize.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import UIKit
import Foundation

class RJKLocalize:NSObject {
    var availableLanguages = [String]()
    var details = [String: String]()

    static let shared = RJKLocalize()
    private override init() {
        super.init()
    }
}
