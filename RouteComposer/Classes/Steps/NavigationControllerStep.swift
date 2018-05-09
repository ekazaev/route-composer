//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default navigation container step
public class NavigationControllerStep: BasicContainerStep<NilFinder<UINavigationController, Any?>, NavigationControllerFactory, UINavigationController>, RoutingStep {

    /// Creates the default `UINavigationController` and applies an `Action` if it is provided.
    ///
    /// - Parameters:
    ///     - action: The `Action` to be applied to the created `UINavigationController`
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory(action: action))
    }

}
