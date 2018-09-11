//
//  StepResult.swift
//  RouteComposer
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// Result of step execution.
///
/// - success: Step found it view controller.
/// - continueRouting: Step hasn't been found the view controller and `Router` can try to
///   execute previous step if it exists.
/// - failure: Step failed to execute.
enum StepResult {

    // I think as a step result type with a failure in place it looks nicer to have `.success` as a positive result.
    case success(UIViewController)

    /// `Factory` instance to be used by `Router` to build a `UIViewController` for this step.
    case continueRouting(AnyFactory?)

    case failure

    /// Default init of StepResult enum
    ///
    /// - Parameters:
    ///   - view controller. If view controller is non nil, step result will be .found,
    /// .continueRouting in case view controller is nil.
    init(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            self = .failure
            return
        }

        self = .success(viewController)
    }

}
