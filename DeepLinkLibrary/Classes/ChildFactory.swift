//
//  AnyChildFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 03/03/2018.
//

import Foundation
import UIKit

/// Instance that extends ChildFactory builds UIViewController that will be later integrated in to stack by
/// container factory.
public final class ChildFactory<Context>  {

    let factory: AnyFactory

    /// Action instance to be applied on a view controller that is going to be build.
    public let action: Action

    init(_ factory: AnyFactory) {
        self.factory = factory
        self.action = factory.action
    }

    /// Builds an instance of UIViewController and integrates it in to provided view controller stack
    ///
    /// - Parameter context: An instance of context provided by router.
    /// - Parameter containerViewControllers: Array of UIViewController instances to be later
    ///   integrated in to container's stack.
    public func build(with context: Context?, in containerViewControllers: inout [UIViewController]) throws {
        let viewController = try factory.build(with: context)
        factory.action.performMerged(viewController: viewController, containerViewControllers: &containerViewControllers)
    }

    func wrapAsAnyFactory() -> AnyFactory {
        return factory
    }


}
