//
//  AnyContextTask.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// Non typesafe boxing wrapper for ContextTask protocol
protocol AnyContextTask {

    func prepare(with context: Any?) throws

    func apply(on viewController: UIViewController, with context: Any?)

}

class ContextTaskBox<CT: ContextTask>: AnyContextTask, CustomStringConvertible {

    let contextTask: CT

    init(_ contextTask: CT) {
        self.contextTask = contextTask
    }

    func prepare(with context: Any?) throws {
        guard let typedContext = context as? CT.Context? else {
            throw RoutingError.message("\(String(describing: context)) does not support context \(String(describing: context))")
        }
        try contextTask.prepare(with: typedContext)
    }

    func apply(on viewController: UIViewController, with context: Any?) {
        guard let typedViewController = viewController as? CT.ViewController,
              let typedContext = context as? CT.Context? else {
            return
        }
        contextTask.apply(on: typedViewController, with: typedContext)
    }

    var description: String {
        return String(describing: contextTask)
    }

}
