//
// RouteComposer
// ChildCoordinator.swift
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

/// Helps to build a child view controller stack
public struct ChildCoordinator {

    // MARK: Properties

    var childFactories: [(factory: PostponedIntegrationFactory, context: AnyContext)]

    /// Returns `true` if the coordinator contains child factories to build
    public var isEmpty: Bool {
        childFactories.isEmpty
    }

    // MARK: Methods

    init(childFactories: [(factory: PostponedIntegrationFactory, context: AnyContext)]) {
        self.childFactories = childFactories
    }

    /// Builds child view controller stack with the context instance provided.
    ///
    /// - Parameters:
    ///   - existingViewControllers: Current view controller stack of the container.
    /// - Returns: Built child view controller stack
    public func build(integrating existingViewControllers: [UIViewController] = []) throws -> [UIViewController] {
        var childrenViewControllers = existingViewControllers
        for factory in childFactories {
            try factory.factory.build(with: factory.context, in: &childrenViewControllers)
        }
        return childrenViewControllers
    }

}
