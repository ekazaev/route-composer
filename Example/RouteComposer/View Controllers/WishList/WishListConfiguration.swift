//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

struct WishListConfiguration {
    static let wishListScreen = StepAssembly(
            finder: ClassFinder<WishListViewController, WishListContext>(),
            factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "WishListViewController"))
            .add(LoginInterceptor())
            .add(WishListContextTask())
            .using(UINavigationController.pushToNavigation())
            .from(NavigationControllerStep())
            .using(GeneralAction.presentModally(presentationStyle: .formSheet))
            .from(GeneralStep.current())
            .assemble()

    static func favorites() -> ExampleDestination<WishListViewController, WishListContext> {
        return ExampleDestination(step: wishListScreen, context: WishListContext.favorites)
    }

    static func collections() -> ExampleDestination<WishListViewController, WishListContext> {
        return ExampleDestination(step: wishListScreen, context: WishListContext.collections)
    }

}
