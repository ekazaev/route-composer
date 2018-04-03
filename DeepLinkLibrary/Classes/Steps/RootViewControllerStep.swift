//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Returns the root view controller of the window.
public class RootViewControllerStep: RoutingStep, PerformableStep {

    public init() {
    }

    func perform<D: RoutingDestination>(for destination: D) -> StepResult {
        return StepResult(UIWindow.key?.rootViewController)
    }

}
