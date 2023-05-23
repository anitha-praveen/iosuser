//
//  LocalDB.swift
//  Taxiappz
//
//  Created by Apple on 07/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import Foundation

class LocalDB: NSObject {
    
    static let shared = LocalDB()
    
    static var choosedContacts = [ContactPerson]()
    static var profilePicData: Data?

}
