//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Default tab bar container step
public final class TabBarControllerStep<Context>: SingleContainerStep<NilFinder<UITabBarController, Context>, TabBarControllerFactory<Context>> {

    /// Constructor
    public init() {
        super.init(finder: NilFinder(), factory: TabBarControllerFactory())
    }

}
