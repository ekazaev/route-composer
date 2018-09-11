//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Returns the root view controller of the key window.
public struct RootViewControllerStep: RoutingStepWithContext, PerformableStep {

    public typealias Context = Any?

    /// Constructor
    public init() {
    }

    func perform(for destination: Any?) -> StepResult {
        return StepResult(UIWindow.key?.rootViewController)
    }

}
