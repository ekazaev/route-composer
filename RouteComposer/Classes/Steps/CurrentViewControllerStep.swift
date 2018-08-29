//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Returns the topmost presented view controller.
public struct CurrentViewControllerStep: RoutingStep, PerformableStep {

    /// Constructor
    public init() {
    }

    func perform<D: RoutingDestination>(for destination: D) -> StepResult {
        let window = UIWindow.key
        return StepResult(window?.topmostViewController)
    }

}
