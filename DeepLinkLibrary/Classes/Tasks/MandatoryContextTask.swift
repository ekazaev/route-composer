//
// Created by Eugene Kazaev on 04/03/2018.
//

import Foundation
import UIKit

public protocol MandatoryContextTask: ContextTask {

    /// Method that will be called by the Router to run ContextTask immediately after UIViewController been created
    /// or found
    ///
    /// - Parameters:
    ///   - viewController: View Controller instance described in the step that context task attached to
    ///   - context: Context object that was passed to the router
    func apply(on viewController: ViewController, with context: Context)

}

public extension MandatoryContextTask {

    public func prepare(with context: Context?) throws {
        guard let _ = context else {
            throw RoutingError.message("Context object should be passed to router for \(String(describing: self))")
        }
    }

    public func apply(on viewController: ViewController, with context: Context?) {
        guard let context = context else {
            return
        }
        apply(on: viewController, with: context)
    }

}