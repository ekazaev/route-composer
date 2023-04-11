//
// RouteComposer
// ConcreteContainerAdapter.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

/// Provides universal properties and methods of the `ContainerViewController` instance.
public protocol ConcreteContainerAdapter: ContainerAdapter {

    // MARK: Associated types

    /// Type of `ContainerViewController`
    associatedtype Container: ContainerViewController

    // MARK: Methods to implement

    /// Constructor
    init(with viewController: Container)

}
