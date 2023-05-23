//
//  UpdateChecker.swift
//  Taxiappz
//
//  Created by Apple on 22/02/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import Alamofire
class UpdateChecker: NSObject {
    
    public static let shared = UpdateChecker()
    
      func isUpdateAvailable(callback: @escaping (Bool)->Void) {
          let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
          Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(bundleId)").responseJSON { response in
              print("Update Checker Response", response.result.value as Any)
              if let json = response.result.value as? NSDictionary, let results = json["results"] as? NSArray, let entry = results.firstObject as? NSDictionary, let versionStore = entry["version"] as? String, let versionLocal = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                  let arrayStore = versionStore.split(separator: ".").compactMap { Int($0) }
                  let arrayLocal = versionLocal.split(separator: ".").compactMap { Int($0) }
                  
                  if arrayLocal.count != arrayStore.count {
                      callback(true) // different versioning system
                      return
                  }
                  
                  // check each segment of the version
                  for (localSegment, storeSegment) in zip(arrayLocal, arrayStore) {
                      if localSegment < storeSegment {
                          callback(true)
                          return
                      }
                  }
              }
              callback(false) // no new version or failed to fetch app store version
          }
      }
    
  }
