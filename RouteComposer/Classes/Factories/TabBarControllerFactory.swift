//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

///  The `Container` that creates a `UITabBarController` instance.
public struct TabBarControllerFactory: SimpleContainer {

    public typealias ViewController = UITabBarController

    public typealias Context = Any?

    /// `UITabBarControllerDelegate` reference
    public weak var delegate: UITabBarControllerDelegate?

    /// Constructor
    public init(delegate: UITabBarControllerDelegate? = nil) {
        self.delegate = delegate
    }

    public func build(with context: Context, integrating viewControllers: [UIViewController]) throws -> ViewController {
        guard !viewControllers.isEmpty else {
            throw RoutingError.compositionFailed(RoutingError.Context(debugDescription: "Unable to build UITabBarController due to 0 amount " +
                    "of the children view controllers"))
        }
        let tabBarController = UITabBarController()
        if let delegate = delegate {
            tabBarController.delegate = delegate
        }
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }

}
