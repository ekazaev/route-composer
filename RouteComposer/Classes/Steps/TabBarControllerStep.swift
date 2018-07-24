//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Default tab bar container step
public class TabBarControllerStep: BasicStep {

    /// Creates a default `UITabBarController` and applies an `Action` if it is provided.
    ///
    /// - parameter action: The `Action` to be applied to the created `UITabBarController`
    public init(action: Action) {
        super.init(finder: NilFinder(), container: TabBarControllerFactory(action: action))
    }

}
