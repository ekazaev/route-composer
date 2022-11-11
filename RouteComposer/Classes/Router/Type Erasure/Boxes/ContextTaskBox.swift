//
// RouteComposer
// ContextTaskBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

struct ContextTaskBox<CT: ContextTask>: AnyContextTask, PreparableEntity, MainThreadChecking, CustomStringConvertible {

    var contextTask: CT

    var isPrepared = false

    init(_ contextTask: CT) {
        self.contextTask = contextTask
    }

    mutating func prepare(with context: Any?) throws {
        guard let typedContext = Any?.some(context as Any) as? CT.Context else {
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: CT.Context.self,
                                            .init("\(String(describing: contextTask.self)) does not accept \(String(describing: context.self)) as a context."))
        }
        try contextTask.prepare(with: typedContext)
        isPrepared = true
    }

    func perform(on viewController: UIViewController, with context: Any?) throws {
        guard let typedViewController = viewController as? CT.ViewController,
              let typedContext = Any?.some(context as Any) as? CT.Context else {
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: CT.Context.self,
                                            .init("\(String(describing: contextTask.self)) does not accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        assertIfNotPrepared()
        try contextTask.perform(on: typedViewController, with: typedContext)
    }

    var description: String {
        String(describing: contextTask)
    }

}
