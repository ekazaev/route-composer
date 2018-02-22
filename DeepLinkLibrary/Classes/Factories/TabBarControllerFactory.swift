//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

public protocol TabBarControllerFactoryAction: Action {

}

public class TabBarControllerFactory: MergingContainerFactory {

    public typealias ViewController = UITabBarController

    public typealias Context = Any

    public typealias ActionType = TabBarControllerFactoryAction

    public let action: Action

    public var factories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
    }

    open func build(with context: Context?) -> FactoryBuildResult {
        guard factories.count > 0 else {
            return .failure("No child view controllers provided.")
        }

        let tabBarController = UITabBarController()

        var viewControllers: [UIViewController] = []
        self.factories.forEach { factory in
            guard case let .success(viewController) = factory.build(with: context) else {
                return
            }
            factory.action.performMerged(viewController: viewController, containerViewControllers: &viewControllers)
        }

        if viewControllers.count > 0 {
            tabBarController.viewControllers = viewControllers
        }

        return .success(tabBarController)
    }
}
