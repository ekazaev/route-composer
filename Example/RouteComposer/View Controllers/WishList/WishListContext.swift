//
// RouteComposer
// WishListContext.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import Foundation

enum WishListContext: Int {
    case favorites = 0
    case collections
}

struct WishListDataModel {

    static let data = [
        WishListContext.favorites: ["Gucci", "Dolce & Gabbana", "Anna Valentine", "Lacoste"],
        .collections: ["Shoes", "Dresses", "Hats"]
    ]

}
