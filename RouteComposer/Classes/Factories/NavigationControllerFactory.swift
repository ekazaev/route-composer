//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import UIKit

/// The `ContainerFactory` that creates a `UINavigationController` instance.
public struct NavigationControllerFactory<C>: SimpleContainerFactory {

    /// `UINavigationControllerDelegate` reference
    private(set) public weak var delegate: UINavigationControllerDelegate?

    /// Block to configure `UINavigationController`
    public let configuration: ((_: UINavigationController) -> Void)?

    /// Constructor
    public init(delegate: UINavigationControllerDelegate? = nil,
                configuration: ((_: UINavigationController) -> Void)? = nil) {
        self.delegate = delegate
        self.configuration = configuration
    }

    public func build(with context: C, integrating viewControllers: [UIViewController]) throws -> UINavigationController {
        guard !viewControllers.isEmpty else {
            throw RoutingError.compositionFailed(.init("Unable to build UINavigationController due to 0 amount " +
                    "of the children view controllers"))
        }
        let navigationController = UINavigationController()
        if let delegate = delegate {
            navigationController.delegate = delegate
        }
        if let configuration = configuration {
            configuration(navigationController)
        }
        navigationController.viewControllers = viewControllers
        return navigationController
    }

}
