//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default split container step
public class SplitControllerStep: BasicContainerStep<UISplitViewController> {

    /// Creates a default UISplitViewController and applies an action if it is provided.
    ///
    /// - parameter action: action to be applied to the created UISplitViewController
    public init(action: Action) {
        super.init(finder: NilFinder(), factory: SplitControllerFactory(action: action))
    }

}
