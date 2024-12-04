//
// RouteComposer
// PostRoutingTaskMultiplexer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

struct PostRoutingTaskMultiplexer: AnyPostRoutingTask, CustomStringConvertible {

    private let tasks: [AnyPostRoutingTask]

    init(_ tasks: [AnyPostRoutingTask]) {
        self.tasks = tasks
    }

    func perform(on viewController: UIViewController, with context: AnyContext, routingStack: [UIViewController]) throws {
        try tasks.forEach { try $0.perform(on: viewController, with: context, routingStack: routingStack) }
    }

    var description: String {
        String(describing: tasks)
    }

}
