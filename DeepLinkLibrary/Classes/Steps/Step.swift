//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Represents step for the router.
public protocol Step {

    /// Factory instance to be used by Router to build a UIViewController for this step.
    var factory: Factory? { get }

    /// Interceptor instance to be executed by router before routing to this step.
    var interceptor: RouterInterceptor? { get }

    /// PostRoutingTask instance to be executed by a router after routing to this step.
    var postTask: PostRoutingTask? { get }

    /// Step to be made by a router before getting to this step.
    var previousStep: Step? { get }

    /// Think about another name. (perform/execute/..)
    ///
    /// - Parameter arguments: Arguments that Router has started with.
    /// - Returns: StepResult enum value, which may contain a view controller in case of .found scenario.
    func getPresentationViewController(with arguments: Any?) -> StepResult

}
