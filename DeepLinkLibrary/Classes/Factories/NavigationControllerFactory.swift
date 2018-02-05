//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol NavigationControllerFactoryAction: ViewControllerAction {

}

open class NavigationControllerFactory: ContainerFactory {

    public let action: ViewControllerAction?

    var factories: [Factory] = []

    public init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    public func merge(_ factories: [Factory]) -> [Factory] {
        var rest: [Factory] = []
        self.factories = factories.filter { factory in
            guard let _ = factory.action as? NavigationControllerFactoryAction else {
                rest.append(factory)
                return false
            }
            return true
        }

        return rest
    }

    open func build(with logger: Logger?) -> UIViewController? {
        guard factories.count > 0 else {
            return nil
        }

        let navigationController = UINavigationController()

        var viewControllers: [UIViewController] = []
        self.factories.forEach { factory in
            guard let viewController = factory.build(with: logger) else {
                return
            }
            factory.action?.performMerged(viewController: viewController, containerViewControllers: &viewControllers, logger: logger)
        }

        guard viewControllers.count > 0 else {
            logger?.log(.error("Unable to build UINavigationController due to 0 amount of child view controllers"))
            return nil
        }

        navigationController.viewControllers = viewControllers
        return navigationController
    }
}