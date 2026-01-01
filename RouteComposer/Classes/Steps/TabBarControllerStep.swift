//
// RouteComposer
// TabBarControllerStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// Default tab bar container step
public final class TabBarControllerStep<VC: UITabBarController, Context>: SingleContainerStep<NilFinder<VC, Context>, TabBarControllerFactory<VC, Context>> {

    // MARK: Methods

    /// Constructor
    public init() {
        super.init(finder: NilFinder(), factory: TabBarControllerFactory<VC, Context>())
    }

}

// MARK: Shorthands

public extension DestinationStep where VC == UITabBarController {
    /// Default tab bar container step
    static var tabBarController: TabBarControllerStep<UITabBarController, Context> {
        TabBarControllerStep()
    }
}

public extension ActionToStepIntegrator where VC == UITabBarController {
    /// Default tab bar container step
    static var tabBarController: TabBarControllerStep<UITabBarController, Context> {
        TabBarControllerStep()
    }
}
