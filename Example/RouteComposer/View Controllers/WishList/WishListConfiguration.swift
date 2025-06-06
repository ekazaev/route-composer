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
    static let wishListScreen = StepAssembly(
        finder: ClassFinder<WishListViewController, WishListContext>(),
        factory: StoryboardFactory(name: "TabBar", identifier: "WishListViewController"))
        .adding(LoginInterceptor())
        .adding(WishListContextTask())
        .using(UINavigationController.push())
        .from(NavigationControllerStep())
        .using(GeneralAction.presentModally(presentationStyle: .formSheet))
        .from(GeneralStep.current())
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
