//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// The `Container` that creates a `UINavigationController` instance.
public struct NavigationControllerFactory: SimpleContainer {

    public typealias ViewController = UINavigationController

    public typealias Context = Any?

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
            throw RoutingError.message("Unable to build UINavigationController due to 0 amount of child view controllers")
        }
        let navigationController = UINavigationController()
        if let delegate = delegate {
            navigationController.delegate = delegate
        }
        navigationController.viewControllers = viewControllers
        return navigationController
    }

}
