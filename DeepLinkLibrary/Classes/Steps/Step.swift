//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Result of step execution.
///
/// - found: Step found it view controller.
/// - continueRouting: Step havent find it view controller and router can try to execute previous step if it exists.
/// - failure: Step tells router to stop routing and retunr .unhandled to a caller.
public enum StepResult {

    case found(UIViewController)

    case continueRouting

    case failure

    /// Default init of StepResult enum
    ///
    /// - Parameter viewController: if passed it will init .found case. .continueRouting otherwise. .failure case
    ///   should be instantiated manually.
    init(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            self = .continueRouting
            return
        }

        self = .found(viewController)
    }
}

/// Represents sptep of a router.
public protocol Step {

    /// Factory instance to be used by Router to build a UIViewController for this step.
    var factory: Factory? { get }

    /// Interceptor instnce to be executed by router before routing to this step.
    var interceptor: RouterInterceptor? { get }

    /// PostRoutingTask instance to be executed by a router after routing to this step.
    var postTask: PostRoutingTask? { get }

    /// Step to be made by a router before getting to this step.
    var prevStep: Step? { get }

    /// Returns a directions to a Router how to deal with this step
    ///
    /// - Parameter arguments: Arguments that Router has started with.
    /// - Returns: StepResult enum value.
    func getPresentationViewController(with arguments: Any?) -> StepResult

}
