//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

struct ContextTaskBox<CT: ContextTask>: AnyContextTask, PreparableEntity, MainThreadChecking, CustomStringConvertible {

    var contextTask: CT

    var isPrepared = false

    init(_ contextTask: CT) {
        self.contextTask = contextTask
    }

    mutating func prepare<Context>(with context: Context) throws {
        guard let typedContext = Any?.some(context as Any) as? CT.Context else {
            throw RoutingError.typeMismatch(CT.Context.self, .init("\(String(describing: contextTask.self)) does not " +
                    "accept \(String(describing: context.self)) as a context."))
        }
        try contextTask.prepare(with: typedContext)
        isPrepared = true
    }

    func perform<Context>(on viewController: UIViewController, with context: Context) throws {
        guard let typedViewController = viewController as? CT.ViewController,
              let typedContext = Any?.some(context as Any) as? CT.Context else {
            throw RoutingError.typeMismatch(CT.Context.self, .init("\(String(describing: contextTask.self)) does not " +
                    "accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        assertIfNotPrepared()
        try contextTask.perform(on: typedViewController, with: typedContext)
    }

    var description: String {
        return String(describing: contextTask)
    }

}
