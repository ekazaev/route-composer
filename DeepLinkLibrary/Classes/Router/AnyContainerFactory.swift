//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public protocol AnyContainerFactory {

    func merge(_ factories: [AnyFactory]) -> [AnyFactory]

}

class ContainerFactoryBox<F: Factory&ContainerFactory>: AnyFactory, AnyContainerFactory {

    let factory: F
    let action: Action

    init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        return factory.merge(factories)
    }

    func prepare(with arguments: Any?, logger: Logger?) -> RoutingResult {
        guard let typedArguments = arguments as? F.A? else {
            logger?.log(.warning("\(String(describing:factory)) does not accept \(String(describing: arguments)) as a parameter."))
            return .unhandled
        }
        return factory.prepare(with: typedArguments, logger: logger)
    }

    func build(with logger: Logger?) -> UIViewController? {
        return factory.build(with: logger)
    }
}


