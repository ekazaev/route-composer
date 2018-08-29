//
//  ChildFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 03/03/2018.
//

import Foundation
import UIKit

/// An instance of `ChildFactory` builds a `UIViewController` that will be later integrated into the stack by
/// the `Container` `Factory`.
public struct ChildFactory<Context> {

    let factory: AnyFactory

    /// `Action` instance to be applied to a view controller that is going to be built.
    public let action: Action

    init(_ factory: AnyFactory) {
        self.factory = factory
        self.action = factory.action
    }

    /// Builds an instance of `UIViewController` and integrates it into provided view controller stack
    ///
    /// - Parameters:
    ///   - context: An instance of `Context` provided by `Router`.
    ///   - childViewControllers: Array of `UIViewController` instances to be later
    ///   integrated in to container's stack.
    func build(with context: Context, in childViewControllers: inout [UIViewController]) throws {
        let viewController = try factory.build(with: context)
        factory.action.perform(embedding: viewController, in: &childViewControllers)
    }

}
