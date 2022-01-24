//
// RouteComposer
// ChildCoordinator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

/// Helps to build a child view controller stack
public struct ChildCoordinator<Context> {

    // MARK: Properties

    var childFactories: [PostponedIntegrationFactory<Context>]

    /// Returns `true` if the coordinator contains child factories to build
    public var isEmpty: Bool {
        childFactories.isEmpty
    }

    // MARK: Methods

    init(childFactories: [PostponedIntegrationFactory<Context>]) {
        self.childFactories = childFactories
    }

    /// Builds child view controller stack with the context instance provided.
    ///
    /// - Parameters:
    ///   - context: A `Context` instance that is provided to the `Router`.
    ///   - existingViewControllers: Current view controller stack of the container.
    /// - Returns: Built child view controller stack
    public func build(with context: Context, integrating existingViewControllers: [UIViewController] = []) throws -> [UIViewController] {
        var childrenViewControllers = existingViewControllers
        for factory in childFactories {
            try factory.build(with: context, in: &childrenViewControllers)
        }
        return childrenViewControllers
    }

}

#endif
