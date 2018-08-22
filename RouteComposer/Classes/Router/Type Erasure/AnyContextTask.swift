//
//  AnyContextTask.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for ContextTask protocol
protocol AnyContextTask {

    func prepare<D: RoutingDestination>(with context: Any?, for destination: D) throws

    func apply<D: RoutingDestination>(on viewController: UIViewController, with context: Any?, for destination: D) throws

}

class ContextTaskBox<CT: ContextTask>: AnyContextTask, CustomStringConvertible {

    let contextTask: CT

    init(_ contextTask: CT) {
        self.contextTask = contextTask
    }

    func prepare<D: RoutingDestination>(with context: Any?, for destination: D) throws {
        guard let typedContext = context as? CT.Context else {
            throw RoutingError.message("\(String(describing: contextTask)) does not support context \(String(describing: context))")
        }
        try contextTask.prepare(with: typedContext)
    }

    func apply<D: RoutingDestination>(on viewController: UIViewController, with context: Any?, for destination: D) throws {
        guard let typedViewController = viewController as? CT.ViewController,
              let typedContext = context as? CT.Context else {
            throw RoutingError.message("\(String(describing: contextTask)) does not support context \(String(describing: context))")
        }
        try contextTask.apply(on: typedViewController, with: typedContext)
    }

    var description: String {
        return String(describing: contextTask)
    }

}
