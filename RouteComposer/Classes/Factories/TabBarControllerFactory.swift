//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// `Container` `Factory` that creates `UITabBarController`
public class TabBarControllerFactory: SimpleContainerFactory {

    public typealias ViewController = UITabBarController

    public typealias Context = Any?

    public typealias SupportedAction = TabBarControllerAction

    public let action: Action

    public var factories: [ChildFactory<Context>] = []

    /// Constructor
    ///
    /// - Parameter action: `Action` instance.
    public init(action: Action) {
        self.action = action
    }

    public func build(with context: Context) throws -> ViewController {
        let viewControllers = try buildChildrenViewControllers(with: context)
        guard viewControllers.count > 0 else {
            throw RoutingError.message("Unable to build UITabBarController due to 0 amount of child view controllers")
        }
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
    
}
