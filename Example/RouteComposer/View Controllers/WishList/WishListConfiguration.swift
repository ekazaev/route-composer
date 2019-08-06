//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

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
        return Destination(to: wishListScreen, with: WishListContext.favorites)
    }

    static func collections() -> Destination<WishListViewController, WishListContext> {
        return Destination(to: wishListScreen, with: WishListContext.collections)
    }

}
