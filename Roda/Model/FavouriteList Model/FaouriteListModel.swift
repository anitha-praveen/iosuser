//
//  FaouriteListModel.swift
//  Taxiappz
//
//  Created by spextrum on 26/11/21.
//  Copyright © 2021 Mohammed Arshad. All rights reserved.
//

import Foundation

struct FavouriteLocation {
    enum FavouriteType {
        case home
        case work
        case other
    }
    var title: String?
    var type:FavouriteType = .home
    var place: String?
    var latitude: String?
    var longitude: String?
}

