//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default navigation container step
public class NavigationControllerStep: BasicContainerStep<NilFinder<UINavigationController, Any?>, NavigationControllerFactory, UINavigationController>, RoutingStep {

    /// Creates a default `UINavigationController` and applies an action if it is provided.
    ///
    /// - Parameters:
    ///     - action: `Action` to be applied to the created `UINavigationController`
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory(action: action))
    }

}
