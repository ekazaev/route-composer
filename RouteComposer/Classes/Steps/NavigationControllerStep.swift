//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import UIKit

/// Default navigation container step
public class NavigationControllerStep<Context>: SingleContainerStep<NilFinder<UINavigationController, Context>, NavigationControllerFactory<Context>> {

    /// Constructor
    public init() {
        super.init(finder: NilFinder(), factory: NavigationControllerFactory())
    }

}
