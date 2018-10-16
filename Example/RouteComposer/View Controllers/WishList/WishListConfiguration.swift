//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

struct WishListConfiguration {

    static let wishListScreen = DestinationAssembly(from: GeneralStep.current())
            .using(GeneralAction.presentModally(presentationStyle: .formSheet))
            .present(NavigationControllerStep())
            .using(UINavigationController.pushToNavigation())
            .present(SingleStep(finder: ClassFinder<WishListViewController, WishListContext>(),
                    factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "WishListViewController"))
                    .adding(LoginInterceptor())
                    .adding(WishListContextTask()))
            .assemble()

    static func favorites() -> ExampleDestination<WishListViewController, WishListContext> {
        return ExampleDestination(step: wishListScreen, context: WishListContext.favorites)
    }

    static func collections() -> ExampleDestination<WishListViewController, WishListContext> {
        return ExampleDestination(step: wishListScreen, context: WishListContext.collections)
    }

}
