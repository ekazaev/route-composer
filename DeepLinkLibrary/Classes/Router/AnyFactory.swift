//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

public protocol AnyFactory: class {
    var action: Action { get }
    func prepare(with arguments: Any?) -> RoutingResult
    func build(with logger: Logger?) -> UIViewController?
}

protocol AnyContainerFactory {

    func merge(_ factories: [AnyFactory]) -> [AnyFactory]

}

class FactoryBox<F:Factory>:AnyFactory {

    let factory: F

    let action: Action

    init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func prepare(with arguments: Any?) -> RoutingResult {
        guard let typedArguments = arguments as? F.A? else {
            print("\(String(describing:factory)) does not accept \(String(describing: arguments)) as a parameter.")
            return .unhandled
        }
        return factory.prepare(with: typedArguments)
    }

    func build(with logger: Logger?) -> UIViewController? {
        return factory.build(with: logger)
    }
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

    func prepare(with arguments: Any?) -> RoutingResult {
        guard let typedArguments = arguments as? F.A? else {
            print("\(String(describing:factory)) does not accept \(String(describing: arguments)) as a parameter.")
            return .unhandled
        }
        return factory.prepare(with: typedArguments)
    }

    func build(with logger: Logger?) -> UIViewController? {
        return factory.build(with: logger)
    }
}
