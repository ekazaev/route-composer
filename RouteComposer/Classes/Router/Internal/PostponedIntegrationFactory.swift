//
//  PostponedIntegrationFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 03/03/2018.
//

import Foundation
import UIKit

struct PostponedIntegrationFactory<Context>: CustomStringConvertible {

    var factory: AnyFactory

    var contextTasks: [AnyContextTask]

    init(for factory: AnyFactory, with contextTasks: [AnyContextTask] = []) {
        self.factory = factory
        self.contextTasks = contextTasks
    }

    mutating func add(_ contextTask: AnyContextTask) {
        self.contextTasks.append(contextTask)
    }

    mutating func prepare(with context: Context) throws {
        try factory.prepare(with: context)
        contextTasks = try contextTasks.map({
            var contextTask = $0
            try contextTask.prepare(with: context)
            return contextTask
        })
    }

    func build(with context: Context, in childViewControllers: inout [UIViewController]) throws {
        let viewController = try factory.build(with: context)
        try contextTasks.forEach({ try $0.apply(on: viewController, with: context) })
        try factory.action.perform(embedding: viewController, in: &childViewControllers)
    }

    public var description: String {
        return String(describing: factory)
    }

}
