//
//  SOSModel.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Foundation

struct SOSContact {
    var id: String?
    var slug: String?
    var name: String?
    var number: String?
    var description: String?
    var createdBy: Int?
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let name = dict["title"] as? String {
            self.name = name
        }
        if let number = dict["phone_number"] as? String {
            self.number = number
        }
        if let desc = dict["description"] as? String {
            self.description = desc
        }
        if let createdBy = dict["created_by"] as? Int {
            self.createdBy = createdBy
        }
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
    }
}
