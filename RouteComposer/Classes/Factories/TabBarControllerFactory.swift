//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

///  The `Container` that creates a `UITabBarController` instance.
public struct TabBarControllerFactory: SimpleContainerFactory {

    public typealias ViewController = UITabBarController

    public typealias Context = Any?

    public typealias SupportedAction = TabBarControllerAction

    public var factories: [ChildFactory<Context>] = []

    /// `UITabBarControllerDelegate` delegate
    public weak var delegate: UITabBarControllerDelegate?

    /// Constructor
    public init(delegate: UITabBarControllerDelegate? = nil) {
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
