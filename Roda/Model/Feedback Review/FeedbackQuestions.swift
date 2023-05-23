//
//  FeedbackQuestions.swift
//  Roda
//
//  Created by Apple on 08/07/22.
//

import Foundation

struct FeedbackQuestions: Equatable,Codable {
    
    var id: String?
    var question: String?
    var answer: String? = "YES"
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let question = dict["questions"] as? String {
            self.question = question
        }
    }
}
