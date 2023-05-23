//
//  LanguageModel.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import Foundation

typealias Option = (text: String, identifier: String,from: String)
protocol LanguageSelectionDelegate {
    func selectLanguage(_ option: Option)
}

struct AvailableLanguageModel {
    var code: String?
    var name: String?
    var id: Int?
    var updateTime: Double?
    init?(_ dict: [String: AnyObject]) {
        if let code = dict["code"] as? String {
            self.code = code
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let id = dict["id"] as? Int {
            self.id = id
        }
        if let updateTime = dict["updated_date"] as? Double {
            self.updateTime = updateTime
        }
    }
}
