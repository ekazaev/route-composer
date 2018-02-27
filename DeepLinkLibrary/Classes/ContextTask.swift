//
//  ContextTask.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// ContextTask
/// The task to be executed after UIViewController created or found.
public protocol ContextTask {
    
    associatedtype ViewController: UIViewController
    
    associatedtype Context
    
    /// Method that will be called by the Router to run ContextTask immediately after UIViewController been created
    /// or found
    ///
    /// - Parameters:
    ///   - viewController: View Controller instance described in the step that context task attached to
    ///   - context: Context object that was passed to the router
    func apply(on viewController: ViewController, with context: Context)
    
}
