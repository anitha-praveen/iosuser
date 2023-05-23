//
//  FAQModel.swift
//  Taxiappz
//
//  Created by spextrum on 29/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Foundation

struct FAQ {
    var id:Int
    var question:String
    var answer:String
    var isExpanded = false
    init?(_ dict: [String:AnyObject]) {
        if let id = dict["id"] as? Int,
            let question = dict["question"] as? String,
            let answer = dict["answer"] as? String {
                self.id = id
                self.question = question
                self.answer = answer
        } else {
            return nil
        }
    }
}
