//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

enum WishListContent: Int {
    case favorites = 0
    case collections
}

struct WishListDataModel {

    static let data = [
        WishListContent.favorites: ["Gucci", "Dolce & Gabbana", "Anna Valentine", "Lacoste"],
        .collections: ["Shoes", "Dresses", "Hats"]
    ]

}