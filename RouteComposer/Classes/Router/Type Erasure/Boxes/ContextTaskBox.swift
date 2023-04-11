//
// RouteComposer
// ContextTaskBox.swift
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

struct ContextTaskBox<CT: ContextTask>: AnyContextTask, PreparableEntity, MainThreadChecking, CustomStringConvertible {

    var contextTask: CT

    var isPrepared = false

    init(_ contextTask: CT) {
        self.contextTask = contextTask
    }

    mutating func prepare(with context: AnyContext) throws {
        let typedContext: CT.Context = try context.value()
        try contextTask.prepare(with: typedContext)
        isPrepared = true
    }

    func perform(on viewController: UIViewController, with context: AnyContext) throws {
        guard let typedViewController = viewController as? CT.ViewController else {
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: CT.Context.self,
                                            .init("\(String(describing: contextTask.self)) does not accept \(String(describing: context.self)) as a context."))
        }
        let typedContext: CT.Context = try context.value()

        assertIfNotMainThread()
        assertIfNotPrepared()
        try contextTask.perform(on: typedViewController, with: typedContext)
    }

    var description: String {
        String(describing: contextTask)
    }

}
