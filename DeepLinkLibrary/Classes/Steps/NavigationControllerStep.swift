//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default navigation container step
public class NavigationControllerStep: BasicStep {

    /// Creates a default UINavigationController and applies an action if it is provided.
    ///
    /// - Parameters:
    ///     - action: action to be applied to the created UINavigationController
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory(action: action))
    }

    /// Creates a default UINavigationController step.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public override init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context, F.ViewController: UINavigationController {
        super.init(finder: finder, factory: factory)
    }

}
