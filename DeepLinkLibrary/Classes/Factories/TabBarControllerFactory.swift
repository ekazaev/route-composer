//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

public protocol TabBarControllerFactoryAction: Action {

}

public class TabBarControllerFactory: Factory, ContainerFactory {

    public typealias V = UITabBarController
    public typealias A = Any

    public let action: Action

    var factories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
    }

    public func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        var rest: [AnyFactory] = []
        self.factories = factories.filter { factory in
            guard let _ = factory.action as? TabBarControllerFactoryAction else {
                rest.append(factory)
                return false
            }
            return true
        }

        return rest
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
