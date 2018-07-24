//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Default split container step
public class SplitControllerStep: BasicStep {

    /// Creates a default `UISplitViewController` and applies an `Action` if it is provided.
    ///
    /// - parameter action: The `Action` to be applied to the created `UISplitViewController`
    public init(action: Action) {
        super.init(finder: NilFinder(), container: SplitControllerFactory(action: action))
    }

}
