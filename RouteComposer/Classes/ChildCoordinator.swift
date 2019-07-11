//
// Created by Eugene Kazaev on 07/09/2018.
//

import Foundation
import UIKit

/// Helps to build a child view controller stack
public struct ChildCoordinator<Context> {

    // MARK: Properties

    var childFactories: [PostponedIntegrationFactory<Context>]

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
