//
// RouteComposer
// WishListContext.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

enum WishListContext: Int {
    case favorites = 0
    case collections
}

enum WishListDataModel {

    static let data = [
        WishListContext.favorites: ["Gucci", "Dolce & Gabbana", "Anna Valentine", "Lacoste"],
        .collections: ["Shoes", "Dresses", "Hats"]
    ]

}
