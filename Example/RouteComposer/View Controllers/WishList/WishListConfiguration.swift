//
// RouteComposer
// WishListConfiguration.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import UIKit

struct WishListConfiguration {
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

    static func favorites() -> Destination<WishListViewController, WishListContext> {
        Destination(to: wishListScreen, with: WishListContext.favorites)
    }

    static func collections() -> Destination<WishListViewController, WishListContext> {
        Destination(to: wishListScreen, with: WishListContext.collections)
    }

}
