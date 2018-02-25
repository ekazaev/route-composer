//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol NavigationControllerFactoryAction: Action {

}

open class NavigationControllerFactory: SingleActionContainerFactory {

    public typealias ViewController = UINavigationController

    public typealias Context = Any

    public typealias SupportedAction = NavigationControllerFactoryAction

    public let action: Action

    public var factories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
    }

    open func build(with context: Context?) -> FactoryBuildResult {
        guard factories.count > 0 else {
            return .failure("Unable to build UINavigationController due to 0 amount of child factories")
        }

        switch buildChildrenViewControllers(with: context) {
        case .success(let viewControllers):
            guard viewControllers.count > 0 else {
                return .failure("Unable to build UINavigationController due to 0 amount of child view controllers")
            }
            let navigationController = UINavigationController()
            navigationController.viewControllers = viewControllers
            return .success(navigationController)
        case .failure(let message):
            return .failure(message)
        }
    }
}
