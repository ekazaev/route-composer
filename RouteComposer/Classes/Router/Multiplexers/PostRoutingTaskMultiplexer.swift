//
// RouteComposer
// PostRoutingTaskMultiplexer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

struct PostRoutingTaskMultiplexer: AnyPostRoutingTask, CustomStringConvertible {

    private let tasks: [AnyPostRoutingTask]

    init(_ tasks: [AnyPostRoutingTask]) {
        self.tasks = tasks
    }

    func perform<Context>(on viewController: UIViewController, with context: Context, routingStack: [UIViewController]) throws {
        try tasks.forEach { try $0.perform(on: viewController, with: context, routingStack: routingStack) }
    }

    var description: String {
        String(describing: tasks)
    }

}

#endif
