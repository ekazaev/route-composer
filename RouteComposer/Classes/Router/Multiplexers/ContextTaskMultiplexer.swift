//
// RouteComposer
// ContextTaskMultiplexer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

struct ContextTaskMultiplexer: AnyContextTask, CustomStringConvertible {

    private var tasks: [AnyContextTask]

    init(_ tasks: [AnyContextTask]) {
        self.tasks = tasks
    }

    mutating func prepare(with context: Any?) throws {
        tasks = try tasks.map {
            var contextTask = $0
            try contextTask.prepare(with: context)
            return contextTask
        }
    }

    func perform(on viewController: UIViewController, with context: Any?) throws {
        try tasks.forEach { try $0.perform(on: viewController, with: context) }
    }

    var description: String {
        String(describing: tasks)
    }

}
