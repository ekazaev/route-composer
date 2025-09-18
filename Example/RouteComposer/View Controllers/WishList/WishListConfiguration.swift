//
// RouteComposer
// WishListConfiguration.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

enum WishListConfiguration {
    @MainActor
    static let wishListScreen = StepAssembler<WishListViewController, WishListContext>()
        .finder(.classFinder)
        .factory(.storyboardFactory(name: "TabBar", identifier: "WishListViewController"))
        .adding(LoginInterceptor())
        .adding(WishListContextTask())
        .using(.push)
        .from(.navigationController)
        .using(.present(presentationStyle: .formSheet))
        .from(.current)
        .assemble()

    @MainActor
    static func favorites() -> Destination<WishListViewController, WishListContext> {
        Destination(to: wishListScreen, with: WishListContext.favorites)
    }

    @MainActor
    static func collections() -> Destination<WishListViewController, WishListContext> {
        Destination(to: wishListScreen, with: WishListContext.collections)
    }

}
