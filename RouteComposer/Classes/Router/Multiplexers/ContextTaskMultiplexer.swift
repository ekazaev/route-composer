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

    mutating func prepare<Context>(with context: Context) throws {
        tasks = try tasks.map({
            var contextTask = $0
            try contextTask.prepare(with: context)
            return contextTask
        })
    }

    func perform<Context>(on viewController: UIViewController, with context: Context) throws {
        try tasks.forEach({ try $0.perform(on: viewController, with: context) })
    }

    var description: String {
        return String(describing: tasks)
    }

}
