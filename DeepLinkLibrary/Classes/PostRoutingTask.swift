//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

/// PostRoutingTask
/// The task to be executed after deep linking happened.
public protocol PostRoutingTask {

    associatedtype ViewController: UIViewController

    associatedtype Context

    /// Method to be executed by Router after all the view controller has been build in to stack.
    ///
    /// - Parameters:
    ///   - viewController: UIViewController that this post task has been attached to
    ///   - context: Context object instance that been passed to the Router
    ///   - routingStack: All the ViewControllers that been built by Router to reach final destination
    func execute(on viewController: ViewController, with context: Context?, routingStack: [UIViewController])

}
