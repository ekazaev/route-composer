//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Returns the root view controller of the window.
public struct RootViewControllerStep: RoutingStep, PerformableStep {

    /// Constructor
    public init() {
    }

    func perform<D: RoutingDestination>(for destination: D) -> StepResult {
        return StepResult(UIWindow.key?.rootViewController)
    }

}
