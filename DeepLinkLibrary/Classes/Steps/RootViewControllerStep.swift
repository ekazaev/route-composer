//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Returns root view controller of the window.
public class RootViewControllerStep: ChainableStep {

    public init() {
        super.init()
    }

    override public func perform(with arguments: Any?) -> StepResult {
        return StepResult(UIWindow.key?.rootViewController)
    }

}
