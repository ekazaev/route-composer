//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// `Container` `Factory` that creates UINavigationController
public class NavigationControllerFactory: SimpleContainerFactory {

    public typealias ViewController = UINavigationController

    public typealias Context = Any?

    public typealias SupportedAction = NavigationControllerAction

    public let action: Action

    public var factories: [ChildFactory<Context>] = []

    /// Constructor
    ///
    /// - Parameter action: `Action` instance.
    public init(action: Action) {
        self.action = action
    }

    public func build(with context: Context) throws -> ViewController {
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
