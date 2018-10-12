//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Default split container step
public final class SplitControllerStep<Context>: SingleContainerStep<NilFinder<UISplitViewController, Context>, SplitControllerFactory<Context>> {

    /// Constructor.
    public init() {
        super.init(finder: NilFinder(), factory: SplitControllerFactory())
    }

}
