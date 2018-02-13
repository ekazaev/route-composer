//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

public protocol TabBarControllerFactoryAction: Action {

}

public class TabBarControllerFactory: MergingContainerFactory {

    public typealias V = UITabBarController
    public typealias A = Any
    public typealias ActionType = TabBarControllerFactoryAction

    public let action: Action

    public var factories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
    }

    open func build(with logger: Logger?) -> V? {
        guard factories.count > 0 else {
            return nil
        }

        let tabBarController = UITabBarController()

        var viewControllers: [UIViewController] = []
        self.factories.forEach { factory in
            guard let viewController = factory.build(with: logger) else {
                return
            }
            factory.action.performMerged(viewController: viewController, containerViewControllers: &viewControllers, logger: logger)
        }

        if viewControllers.count > 0 {
            tabBarController.viewControllers = viewControllers
        }

        return tabBarController
    }
}
