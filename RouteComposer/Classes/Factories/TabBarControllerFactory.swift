//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// `Container` `Factory` that creates `UITabBarController`
public struct TabBarControllerFactory: SimpleContainerFactory {

    public typealias ViewController = UITabBarController

    public typealias Context = Any?

    public typealias SupportedAction = TabBarControllerAction

    public let action: Action

    public var factories: [ChildFactory<Context>] = []

    /// `UITabBarControllerDelegate` delegate
    public weak var delegate: UITabBarControllerDelegate?

    /// Constructor
    ///
    /// - Parameter action: `Action` instance.
    public init(action: Action, delegate: UITabBarControllerDelegate? = nil) {
        self.action = action
        self.delegate = delegate
    }

    public func build(with context: Context) throws -> ViewController {
        let viewControllers = try buildChildrenViewControllers(with: context)
        guard !viewControllers.isEmpty else {
            throw RoutingError.message("Unable to build UITabBarController due to 0 amount of child view controllers")
        }
        let tabBarController = UITabBarController()
        if let delegate = delegate {
            tabBarController.delegate = delegate
        }
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }

}
