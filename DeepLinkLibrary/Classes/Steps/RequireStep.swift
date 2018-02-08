//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Default step that builds a dependency from another screen assembly
public class RequireStep: RoutingStep {
    public var interceptor: RouterInterceptor?
    
    public var postTask: PostRoutingTask?

    let assembly: RoutingStep

    public func perform(with arguments: Any?) -> StepResult {
        return .continueRouting(nil)
    }
    
    public var previousStep: RoutingStep? {
        return assembly
    }

    /// Default constructor
    ///
    /// - Parameter assembly: The screen assembly required to execute this step.
    public init(_ step: RoutingStep) {
        self.assembly = step
    }

}
