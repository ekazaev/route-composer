//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

///  The `ContainerFactory` that creates a `UITabBarController` instance.
public struct TabBarControllerFactory<C>: SimpleContainerFactory {

    /// `UITabBarControllerDelegate` reference
    private(set) public weak var delegate: UITabBarControllerDelegate?

    /// Block to configure `UITabBarController`
    public let configuration: ((_: UITabBarController) -> Void)?

    /// Constructor
    public init(delegate: UITabBarControllerDelegate? = nil,
                configuration: ((_: UITabBarController) -> Void)? = nil) {
        self.delegate = delegate
        self.configuration = configuration
    }

    public func build(with context: C, integrating viewControllers: [UIViewController]) throws -> UITabBarController {
        guard !viewControllers.isEmpty else {
            throw RoutingError.compositionFailed(RoutingError.Context("Unable to build UITabBarController due " +
                    "to 0 amount of the children view controllers"))
        }
        let tabBarController = UITabBarController()
        if let delegate = delegate {
            tabBarController.delegate = delegate
        }
        if let configuration = configuration {
            configuration(tabBarController)
        }
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }

}
