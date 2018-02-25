//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

public protocol TabBarControllerFactoryAction: Action {

}

public class TabBarControllerFactory: SingleActionContainerFactory {

    public typealias ViewController = UITabBarController

    public typealias Context = Any

    public typealias SupportedAction = TabBarControllerFactoryAction

    public let action: Action

    public var factories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
    }

    open func build(with context: Context?) -> FactoryBuildResult {
        switch buildChildrenViewControllers(with: context) {
        case .success(let viewControllers):
            guard viewControllers.count > 0 else {
                return .failure("Unable to build UITabBarController due to 0 amount of child view controllers")
            }
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = viewControllers
            return .success(tabBarController)
        case .failure(let message):
            return .failure(message)
        }
    }
}
