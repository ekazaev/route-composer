//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

struct WishListConfiguration {

    static let wishListScreen = StepAssembly(
            finder: ClassFinder<WishListViewController, WishListContent>(),
            factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "WishListViewController", action: NavigationControllerFactory.PushToNavigation()))
            .add(LoginInterceptor())
            .add(WishListContentTask())
            .add(ExampleAnalyticsInterceptor())
            .add(ExampleAnalyticsPostAction())
            .from(NavigationControllerStep(action: GeneralAction.PresentModally(presentationStyle: .formSheet)))
            .from(CurrentViewControllerStep())
            .assemble()

    static func favorites() -> ExampleDestination {
        return ExampleDestination(finalStep: wishListScreen, context: WishListContent.favorites)
    }

    static func collections() -> ExampleDestination {
        return ExampleDestination(finalStep: wishListScreen, context: WishListContent.collections)
    }

}
