//
//  ComplaintModel.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Foundation

struct Complaint {
    var id: String?
    var slug: String?
    var title: String?
    init(_ dict:[String:AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let slug = dict["slug"] {
            self.slug = "\(slug)"
        }
        if let title = dict["title"] as? String {
            self.title = title
        }
    }
}
