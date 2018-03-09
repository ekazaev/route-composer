//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default split container step
public class SplitControllerStep: BasicStep {

    /// Creates a default UISplitViewController and applies an action if it is provided.
    ///
    /// - parameter action: action to be applied to the created UISplitViewController
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: SplitControllerFactory(action: action))
    }

    /// Creates a default UISplitViewController step.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public override init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context, F.ViewController: UISplitViewController {
        super.init(finder: finder, factory: factory)
    }

}
