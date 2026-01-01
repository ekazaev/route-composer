//
// RouteComposer
// SplitControllerStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// Default split container step
public final class SplitControllerStep<VC: UISplitViewController, Context>: SingleContainerStep<NilFinder<VC, Context>, SplitControllerFactory<VC, Context>> {

    // MARK: Methods

    /// Constructor.
    public init() {
        super.init(finder: NilFinder(), factory: SplitControllerFactory<VC, Context>())
    }

}

// MARK: Shorthands

public extension DestinationStep where VC == UISplitViewController {
    /// Default split container step
    static var splitViewController: SplitControllerStep<UISplitViewController, Context> {
        SplitControllerStep()
    }
}

public extension ActionToStepIntegrator where VC == UITabBarController {
    /// Default split container step
    static var splitViewController: SplitControllerStep<UISplitViewController, Context> {
        SplitControllerStep()
    }
}
