//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Returns root view controller of the window.
public class RootViewControllerStep: RoutingStep {

    public let previousStep: RoutingStep? = nil

    public init() {
    }

    public func perform(with arguments: Any?) -> StepResult {
        return StepResult(UIWindow.key?.rootViewController)
    }

}
