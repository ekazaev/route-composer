//
// RouteComposer
// NavigationControllerStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

import UIKit

/// Default navigation container step
public final class NavigationControllerStep<VC: UINavigationController, Context>: SingleContainerStep<NilFinder<VC, Context>, NavigationControllerFactory<VC, Context>> {

    // MARK: Methods

    /// Constructor
    public init() {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory<VC, Context>())
    }

}

#endif
