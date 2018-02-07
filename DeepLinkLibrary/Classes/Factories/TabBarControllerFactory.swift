//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

public protocol TabBarControllerFactoryAction: ViewControllerAction {

}

public class TabBarControllerFactory: ContainerFactory {

    public let action: ViewControllerAction

    var factories: [Factory] = []

    public init(action: ViewControllerAction) {
        self.action = action
    }

    public func merge(_ factories: [Factory]) -> [Factory] {
        var rest: [Factory] = []
        self.factories = factories.filter { factory in
            guard let _ = factory.action as? TabBarControllerFactoryAction else {
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
