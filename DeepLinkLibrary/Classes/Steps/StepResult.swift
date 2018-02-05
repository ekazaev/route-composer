//
//  StepResult.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// Result of step execution.
///
/// - success: Step found it view controller.
/// - continueRouting: Step hasn't foundnd the view controller and router can try to execute previous step if it exists.
/// - failure: Step failed to execute.
public enum StepResult {
    // was "found" before. I think as a step result type with a failure in place it looks nicer to have .success as a positive result.
    case success(UIViewController)
    
    case continueRouting
    
    case failure
    
    /// Default init of StepResult enum
    ///
    /// - parameter: view controller. If view controller is non nil, step result will be .found,
    /// .continueRouting in case view controller is nil.
    init(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            self = .continueRouting
            return
        }
        
        self = .success(viewController)
    }
}
