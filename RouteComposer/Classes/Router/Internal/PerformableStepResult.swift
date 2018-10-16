//
//  PerformableStepResult.swift
//  RouteComposer
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// Result of step execution.
///
/// - success: Step found it view controller.
/// - continueRouting: Step hasn't been found the view controller and `Router` can move to another step if it exists.
/// - failure: Step failed to execute.
enum PerformableStepResult {

    // I think as a step result type with a failure in place it looks nicer to have `.success` as a positive result.
    case success(UIViewController)

    /// `Factory` instance to be used by `Router` to build a `UIViewController` for this step.
    case build(AnyFactory)

    /// No result
    case none

}
