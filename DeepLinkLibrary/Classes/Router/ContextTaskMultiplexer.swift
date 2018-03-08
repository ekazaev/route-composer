//
//  ContextTaskMultiplexer.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

class ContextTaskMultiplexer: AnyContextTask, CustomStringConvertible {

    private let tasks: [AnyContextTask]

    init(_ tasks: [AnyContextTask]) {
        self.tasks = tasks
    }

    func prepare<D: RoutingDestination>(with context: Any?, for destination: D) throws {
        try self.tasks.forEach({ try $0.prepare(with: context, for: destination) })
    }

    func apply<D: RoutingDestination>(on viewController: UIViewController, with context: Any?, for destination: D) {
        self.tasks.forEach({ $0.apply(on: viewController, with: context, for: destination) })
    }

    var description: String {
        return String(describing: tasks)
    }

}
