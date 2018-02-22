//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol NavigationControllerFactoryAction: Action {

}

open class NavigationControllerFactory: MergingContainerFactory {

    public typealias V = UINavigationController

    public typealias A = Any

    public typealias ActionType = NavigationControllerFactoryAction

    public let action: Action

    public var factories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
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
