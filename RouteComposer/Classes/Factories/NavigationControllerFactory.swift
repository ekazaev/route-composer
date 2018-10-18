//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// The `ContainerFactory` that creates a `UINavigationController` instance.
public struct NavigationControllerFactory<C>: SimpleContainerFactory {

    public typealias ViewController = UINavigationController

    public typealias Context = C

    /// `UINavigationControllerDelegate` reference
    public weak var delegate: UINavigationControllerDelegate?

    /// Constructor
    ///
    /// - Parameter delegate: `UINavigationControllerDelegate` instance.
    public init(delegate: UINavigationControllerDelegate? = nil) {
        self.delegate = delegate
    }

    public func build(with context: Context, integrating viewControllers: [UIViewController]) throws -> ViewController {
        guard !viewControllers.isEmpty else {
            throw RoutingError.compositionFailed(RoutingError.Context(debugDescription: "Unable to build UINavigationController due to 0 amount " +
                    "of the children view controllers"))
        }
        let navigationController = UINavigationController()
        if let delegate = delegate {
            navigationController.delegate = delegate
        }
        navigationController.viewControllers = viewControllers
        return navigationController
    }

}
