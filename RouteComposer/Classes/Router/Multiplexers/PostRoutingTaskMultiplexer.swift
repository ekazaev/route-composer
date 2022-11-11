//
// RouteComposer
// PostRoutingTaskMultiplexer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

struct PostRoutingTaskMultiplexer: AnyPostRoutingTask, CustomStringConvertible {

    private let tasks: [AnyPostRoutingTask]

    init(_ tasks: [AnyPostRoutingTask]) {
        self.tasks = tasks
    }

    func perform(on viewController: UIViewController, with context: Any?, routingStack: [UIViewController]) throws {
        try tasks.forEach { try $0.perform(on: viewController, with: context, routingStack: routingStack) }
    }

    var description: String {
        String(describing: tasks)
    }

}
