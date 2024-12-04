//
// RouteComposer
// ContextTaskMultiplexer.swift
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

struct ContextTaskMultiplexer: AnyContextTask, CustomStringConvertible {

    private var tasks: [AnyContextTask]

    init(_ tasks: [AnyContextTask]) {
        self.tasks = tasks
    }

    mutating func prepare(with context: AnyContext) throws {
        tasks = try tasks.map {
            var contextTask = $0
            try contextTask.prepare(with: context)
            return contextTask
        }
    }

    func perform(on viewController: UIViewController, with context: AnyContext) throws {
        try tasks.forEach { try $0.perform(on: viewController, with: context) }
    }

    var description: String {
        String(describing: tasks)
    }

}
