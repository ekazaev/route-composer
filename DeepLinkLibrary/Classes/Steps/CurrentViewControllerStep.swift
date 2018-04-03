//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Returns the topmost presented view controller.
public class CurrentViewControllerStep: RoutingStep, PerformableStep {

    public init() {
    }

    func perform<D: RoutingDestination>(for destination: D) -> StepResult {
        let window = UIWindow.key
        return StepResult(window?.topmostViewController)
    }

}

