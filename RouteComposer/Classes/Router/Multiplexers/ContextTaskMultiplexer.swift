//
// RouteComposer
// ContextTaskMultiplexer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

struct ContextTaskMultiplexer: AnyContextTask, CustomStringConvertible {

    private var tasks: [AnyContextTask]

    init(_ tasks: [AnyContextTask]) {
        self.tasks = tasks
    }

    mutating func prepare<Context>(with context: Context) throws {
        tasks = try tasks.map {
            var contextTask = $0
            try contextTask.prepare(with: context)
            return contextTask
        }
    }

    func perform<Context>(on viewController: UIViewController, with context: Context) throws {
        try tasks.forEach { try $0.perform(on: viewController, with: context) }
    }

    var description: String {
        String(describing: tasks)
    }

}

#endif
