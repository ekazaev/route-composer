//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol NavigationControllerFactoryAction: Action {

}

/// Container Factory that creates UINavigationController
open class NavigationControllerFactory: SingleActionContainerFactory {

    public typealias ViewController = UINavigationController

    public typealias Context = Any

    public typealias SupportedAction = NavigationControllerFactoryAction

    public let action: Action

    public var factories: [ChildFactory<Context>] = []

    public init(action: Action) {
        self.action = action
    }

    public func build(with context: Context?) throws -> ViewController {
        guard factories.count > 0 else {
            throw RoutingError.message("Unable to build UINavigationController due to 0 amount of child factories")
        }

        let viewControllers = try buildChildrenViewControllers(with: context)
        guard viewControllers.count > 0 else {
            throw RoutingError.message("Unable to build UINavigationController due to 0 amount of child view controllers")
        }
        let navigationController = UINavigationController()
        navigationController.viewControllers = viewControllers
        return navigationController
    }
}
