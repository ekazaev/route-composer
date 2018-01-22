//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default navigation container step
public class NavigationContainerStep: ChainableStep {

    /// Created a default UINavigationController and applies an action if it was provided.
    ///
    /// - Parameter action: action to be applied to a created UIVanigationController
    public init(action: ViewControllerAction? = nil) {
        super.init(factory:NavigationControllerFactory(action: action))
    }

    /// NavigationContainerStep init method
    ///
    /// - Parameter factory: Factory that creates UINavigationViewController
    public init(factory: Factory? = nil) {
        super.init(factory: factory)
    }

}
