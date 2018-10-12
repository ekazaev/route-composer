//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Default navigation container step
public class NavigationControllerStep<Context>: SingleContainerStep<NilFinder<UINavigationController, Context>, NavigationControllerFactory<Context>> {

    /// Constructor
    public init() {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory())
    }

}
