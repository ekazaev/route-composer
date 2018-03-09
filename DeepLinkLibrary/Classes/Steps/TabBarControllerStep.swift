//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default tab bar container step
public class TabBarControllerStep: BasicStep {

    /// Creates a default UITabBarController and applies an action if it is provided.
    ///
    /// - parameter action: action to be applied to the created UITabBarController
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: TabBarControllerFactory(action: action))
    }

    /// Creates a default UITabBarController step.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public override init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context, F.ViewController: UITabBarController {
        super.init(finder: finder, factory: factory)
    }


}
