//
// RouteComposer
// ContainerAdapterLocator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

/// Provides `ContainerAdapter` instance.
public protocol ContainerAdapterLocator {

    // MARK: Methods to implement

    /// Returns the `ContainerAdapter` suitable for the `ContainerViewController`
    ///
    /// - Parameter containerViewController: The `ContainerViewController` instance
    /// - Returns: Suitable `ContainerAdapter` instance
    /// - Throws: `RoutingError` if the suitable `ContainerAdapter` can not be provided
    func getAdapter(for containerViewController: ContainerViewController) throws -> ContainerAdapter

}
