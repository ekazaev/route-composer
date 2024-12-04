//
// RouteComposer
// NavigationControllerStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// Default navigation container step
public final class NavigationControllerStep<VC: UINavigationController, Context>: SingleContainerStep<NilFinder<VC, Context>, NavigationControllerFactory<VC, Context>> {

    // MARK: Methods

    /// Constructor
    public init() {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory<VC, Context>())
    }

}
