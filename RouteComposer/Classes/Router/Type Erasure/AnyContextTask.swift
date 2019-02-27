//
//  AnyContextTask.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

protocol AnyContextTask {

    mutating func prepare(with context: Any?) throws

    func apply(on viewController: UIViewController, with context: Any?) throws

}

struct ContextTaskBox<CT: ContextTask>: AnyContextTask, AnyPreparableEntity, MainThreadChecking, CustomStringConvertible {

    var contextTask: CT

    var isPrepared = false

    init(_ contextTask: CT) {
        self.contextTask = contextTask
    }

    mutating func prepare(with context: Any?) throws {
        guard let typedContext = Any?.some(context as Any) as? CT.Context else {
            throw RoutingError.typeMismatch(CT.Context.self, .init("\(String(describing: contextTask.self)) does not " +
                            "accept \(String(describing: context.self)) as a context."))
        }
        try contextTask.prepare(with: typedContext)
        isPrepared = true
    }

    func apply(on viewController: UIViewController, with context: Any?) throws {
        guard let typedViewController = viewController as? CT.ViewController,
              let typedContext = Any?.some(context as Any) as? CT.Context else {
            throw RoutingError.typeMismatch(CT.Context.self, .init("\(String(describing: contextTask.self)) does not " +
                    "accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        assertIfNotPrepared()
        try contextTask.apply(on: typedViewController, with: typedContext)
    }

    var description: String {
        return String(describing: contextTask)
    }

}
