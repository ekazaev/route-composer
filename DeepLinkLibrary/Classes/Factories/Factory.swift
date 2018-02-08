//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Factory
/// action: router applies action to integrate view controller created by build() in the existing view controller stack
/// build(): builds a view controller that will be pushed to the viw stack
public protocol Factory: class {
    associatedtype V: UIViewController
    associatedtype A

    var action: Action { get }

    /// If factory can tell to router before it will actually start to route to this view controller
    /// if it can be build ot not - it should overload this method - router will call it before the routing
    /// process and if factory is not able to build a view controller (example: it has to build a product view
    /// controller but there is no product code in arguments) it can stop router from routing to this destination
    /// and the result of routing will be .unhandled without any changes in view controller stack.
    func prepare(with arguments: A?) -> RoutingResult

    func build(with logger: Logger?) -> V?

}

extension Factory {

    public func prepare(with arguments: A?) -> RoutingResult {
        return .handled
    }

}

public protocol AbstractFactory: class {
    var action: Action { get }
    func prepare(with arguments: Any?) -> RoutingResult
    func hasContainer() -> ContainerFactory?
    func build(with logger: Logger?) -> UIViewController?
}

class FactoryWrapper<F:Factory>: AbstractFactory {

    let factory: F

    let action: Action

    init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func hasContainer() -> ContainerFactory? {
        guard let container = factory as? ContainerFactory else {
            return nil
        }
        return container
    }

    func prepare(with arguments: Any?) -> RoutingResult {
        guard let typedArguments = arguments as? F.A? else {
            print("\(factory) does not accept \(String(describing: arguments)) as a parameter.")
            return .unhandled
        }
        return factory.prepare(with: typedArguments)
    }

    func build(with logger: Logger?) -> UIViewController? {
        return factory.build(with: logger)
    }
}