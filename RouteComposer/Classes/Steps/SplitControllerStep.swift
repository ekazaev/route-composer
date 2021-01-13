//
// RouteComposer
// SplitControllerStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import UIKit

/// Default split container step
public final class SplitControllerStep<VC: UISplitViewController, Context>: SingleContainerStep<NilFinder<VC, Context>, SplitControllerFactory<VC, Context>> {

    // MARK: Methods

    /// Constructor.
    public init() {
        super.init(finder: NilFinder(), factory: SplitControllerFactory<VC, Context>())
    }

}

#endif
