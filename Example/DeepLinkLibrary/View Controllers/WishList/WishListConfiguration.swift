//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

struct WishListConfiguration {

    static let wishListScreen = ScreenStepAssembly(
            finder: ViewControllerClassFinder<WishListViewController, WishListContext>(),
            factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "WishListViewController", action: PushAction()))
            .add(LoginInterceptor())
            .add(WishListContentTask())
            .add(ExampleAnalyticsInterceptor())
            .add(ExampleAnalyticsPostAction())
            .from(NavigationContainerStep(action: PresentModallyAction(presentationStyle: .formSheet)))
            .from(TopMostViewControllerStep())
            .assemble()

    static func favorites() -> ExampleDestination {
        return ExampleDestination(finalStep: wishListScreen, context: WishListContext(content: WishListContent.favorites))
    }

    static func collections() -> ExampleDestination {
        return ExampleDestination(finalStep: wishListScreen, context: WishListContext(content: WishListContent.collections))
    }

}
