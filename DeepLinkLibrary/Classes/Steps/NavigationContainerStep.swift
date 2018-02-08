//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default navigation container step
public class NavigationContainerStep: ChainableStep {

    /// Creates a default UINavigationController and applies an action if it is provided.
    ///
    /// - parameter action: action to be applied to the created UINavigationController
    public init(action: Action) {
        super.init(factory: NavigationControllerFactory(action: action))
    }

    /// NavigationContainerStep init method
    ///
    /// - parameter factory: Factory that provides a UINavigationViewController
    public init(factory: Factory) {
        super.init(factory: factory)
    }

}
