//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

public protocol AnyFactory: class {

    var action: Action { get }

    func prepare(with context: Any?, logger: Logger?) -> RoutingResult

    func build(with logger: Logger?) -> UIViewController?

}

class FactoryBox<F:Factory>:AnyFactory {

    let factory: F

    let action: Action

    init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func prepare(with context: Any?, logger: Logger?) -> RoutingResult {
        guard let typedContext = context as? F.C? else {
            logger?.log(.warning("\(String(describing:factory)) does not accept \(String(describing: context)) as a context."))
            return .unhandled
        }
        return factory.prepare(with: typedContext, logger: logger)
    }

    func build(with logger: Logger?) -> UIViewController? {
        return factory.build(logger: logger)
    }
}
