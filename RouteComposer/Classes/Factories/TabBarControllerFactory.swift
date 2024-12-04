//
// RouteComposer
// TabBarControllerFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

///  The `ContainerFactory` that creates a `UITabBarController` instance.
public struct TabBarControllerFactory<VC: UITabBarController, C>: ContainerFactory {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    /// A Xib file name
    public let nibName: String?

    /// A `Bundle` instance
    public let bundle: Bundle?

    /// `UITabBarControllerDelegate` reference
    public private(set) weak var delegate: UITabBarControllerDelegate?

    /// The additional configuration block
    public let configuration: ((_: VC) -> Void)?

    // MARK: Methods

    /// Constructor
    public init(nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil,
                delegate: UITabBarControllerDelegate? = nil,
                configuration: ((_: VC) -> Void)? = nil) {
        self.nibName = nibNameOrNil
        self.bundle = nibBundleOrNil
        self.delegate = delegate
        self.configuration = configuration
    }

    public func build(with context: C, integrating coordinator: ChildCoordinator) throws -> VC {
        let tabBarController = VC(nibName: nibName, bundle: bundle)
        if let delegate {
            tabBarController.delegate = delegate
        }
        if !coordinator.isEmpty {
            tabBarController.viewControllers = try coordinator.build(integrating: tabBarController.viewControllers ?? [])
        }
        if let configuration {
            configuration(tabBarController)
        }
        return tabBarController
    }

}
