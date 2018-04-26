//
//  AnyChildFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 03/03/2018.
//

import Foundation
import UIKit

/// An instance that extends `ChildFactory` builds `UIViewController` that will be later integrated into stack by
/// `Container` `Factory`.
public final class ChildFactory<Context>  {

    let factory: AnyFactory

    /// `Action` instance to be applied to a view controller that is going to be built.
    public let action: Action

    init(_ factory: AnyFactory) {
        self.factory = factory
        self.action = factory.action
    }

    /// Builds an instance of `UIViewController` and integrates it into provided view controller stack
    ///
    /// - Parameter context: An instance of `Context` provided by `Router`.
    /// - Parameter containerViewControllers: Array of `UIViewController` instances to be later
    ///   integrated in to container's stack.
    public func build(with context: Context, in containerViewControllers: inout [UIViewController]) throws {
        let viewController = try factory.build(with: context)
        factory.action.perform(embedding: viewController, in: &containerViewControllers)
    }

    func wrapAsAnyFactory() -> AnyFactory {
        return factory
    }

}
