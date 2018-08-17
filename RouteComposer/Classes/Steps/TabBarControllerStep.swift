//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Default tab bar container step
public class TabBarControllerStep: BasicContainerStep<NilFinder<UITabBarController, Any?>, TabBarControllerFactory, UITabBarController> {

    /// Creates a default `UITabBarController` and applies an `Action` if it is provided.
    ///
    /// - Parameters:
    ///   - action: The `Action` to be applied to the created `UITabBarController`
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: TabBarControllerFactory(action: action))
    }

}
