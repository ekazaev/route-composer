//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol NavigationControllerFactoryAction: Action {

}

open class NavigationControllerFactory: Factory, ContainerFactory {

    public typealias V = UINavigationController
    public typealias A = Any

    public let action: Action

    var factories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
    }

    public func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        var rest: [AnyFactory] = []
        self.factories = factories.filter { factory in
            guard let _ = factory.action as? NavigationControllerFactoryAction else {
                rest.append(factory)
                return false
            }
            return true
        }

        return rest
    }

    open func build(with logger: Logger?) -> V? {
        guard factories.count > 0 else {
            logger?.log(.error("Unable to build UINavigationController due to 0 amount of child factories"))
            return nil
        }

        let navigationController = UINavigationController()

        var viewControllers: [UIViewController] = []
        self.factories.forEach { factory in
            guard let viewController = factory.build(with: logger) else {
                return
            }
            factory.action.performMerged(viewController: viewController, containerViewControllers: &viewControllers, logger: logger)
        }

        guard viewControllers.count > 0 else {
            logger?.log(.error("Unable to build UINavigationController due to 0 amount of child view controllers"))
            return nil
        }

        navigationController.viewControllers = viewControllers
        return navigationController
    }
}