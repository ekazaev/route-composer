//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default tab bar container step
public class TabBarControllerStep: BasicContainerStep<UITabBarController> {

    /// Creates a default UITabBarController and applies an action if it is provided.
    ///
    /// - parameter action: action to be applied to the created UITabBarController
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: TabBarControllerFactory(action: action))
    }

}
