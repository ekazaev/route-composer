//
//  ContextTaskMultiplexer.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

struct ContextTaskMultiplexer: AnyContextTask, CustomStringConvertible {

    private var tasks: [AnyContextTask]

    init(_ tasks: [AnyContextTask]) {
        self.tasks = tasks
    }

    mutating func prepare<D: RoutingDestination>(with context: Any?, for destination: D) throws {
        self.tasks = try self.tasks.map({
            var contextTask = $0
            try contextTask.prepare(with: context, for: destination)
            return contextTask
        })
    }

    func apply<D: RoutingDestination>(on viewController: UIViewController, with context: Any?, for destination: D) throws {
        try self.tasks.forEach({ try $0.apply(on: viewController, with: context, for: destination) })
    }

    var description: String {
        return String(describing: tasks)
    }

}
