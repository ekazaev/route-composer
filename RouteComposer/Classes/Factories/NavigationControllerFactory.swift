//
// RouteComposer
// NavigationControllerFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// The `ContainerFactory` that creates a `UINavigationController` instance.
public struct NavigationControllerFactory<VC: UINavigationController, C>: ContainerFactory {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    /// A Xib file name
    public let nibName: String?

    /// A `Bundle` instance
    public let bundle: Bundle?

    /// `UINavigationControllerDelegate` reference
    public private(set) weak var delegate: UINavigationControllerDelegate?

    /// The additional configuration block
    public let configuration: ((_: VC) -> Void)?

    // MARK: Methods

    /// Constructor
    public init(nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil,
                delegate: UINavigationControllerDelegate? = nil,
                configuration: ((_: VC) -> Void)? = nil) {
        self.nibName = nibNameOrNil
        self.bundle = nibBundleOrNil
        self.delegate = delegate
        self.configuration = configuration
    }

    public func build(with context: C, integrating coordinator: ChildCoordinator) throws -> VC {
        let navigationController = VC(nibName: nibName, bundle: bundle)
        if let delegate {
            navigationController.delegate = delegate
        }
        if !coordinator.isEmpty {
            navigationController.viewControllers = try coordinator.build(integrating: navigationController.viewControllers)
        }
        if let configuration {
            configuration(navigationController)
        }
        return navigationController
    }

}
