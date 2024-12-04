//
// RouteComposer
// CATransaction+Action.swift
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

/// Extension that wraps an action into `CATransaction`.
///
/// When `DefaultRouter` builds a complicated chain of animated modifications in the `UIViewController`s stack
/// it might be necessary to wrap some actions into single `CATransaction`.
///
/// *Example: When `UINavigationController` does pop, then push of the `UIViewController` and then tries to
/// do some to it or find it with a `Finder`. Then `DefaultRouter` has to wait till the end of the animation.*
public extension CATransaction {

    /// Wraps `Action` in to `CATransaction`
    ///
    /// - Parameter action: `Action` instance
    static func wrap<A: Action>(_ action: A) -> CATransactionWrappedAction<A> {
        CATransactionWrappedAction(action)
    }

    /// Wraps `ContainerAction` in to `CATransaction`
    ///
    /// - Parameter action: `ContainerAction` instance
    static func wrap<A: ContainerAction>(_ action: A) -> CATransactionWrappedContainerAction<A> {
        CATransactionWrappedContainerAction(action)
    }

}

/// `CATransaction` wrapper for `Action`
public struct CATransactionWrappedAction<A: Action>: Action {

    // MARK: Associated types

    /// Type of the `UIViewController` that `Action` can start from.
    public typealias ViewController = A.ViewController

    // MARK: Properties

    let action: A

    // MARK: Methods

    init(_ action: A) {
        self.action = action
    }

    public func perform(with viewController: UIViewController, on existingController: A.ViewController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
        guard animated else {
            action.perform(with: viewController, on: existingController, animated: false, completion: completion)
            return
        }
        CATransaction.begin()
        var actionResult: RoutingResult = .failure(RoutingError.compositionFailed(.init("Wrapped \(action) did not complete correctly.")))
        action.perform(with: viewController, on: existingController, animated: true, completion: { result in
            actionResult = result
        })
        CATransaction.setCompletionBlock {
            completion(actionResult)
        }
        CATransaction.commit()
    }

}

/// `CATransaction` wrapper for `ContainerAction`
public struct CATransactionWrappedContainerAction<A: ContainerAction>: ContainerAction {

    // MARK: Associated types

    /// Type of the `UIViewController` that `Action` can start from.
    public typealias ViewController = A.ViewController

    // MARK: Properties

    let action: A

    // MARK: Methods

    init(_ action: A) {
        self.action = action
    }

    public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
        try action.perform(embedding: viewController, in: &childViewControllers)
    }

    public func perform(with viewController: UIViewController, on existingController: A.ViewController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
        guard animated else {
            action.perform(with: viewController, on: existingController, animated: false, completion: completion)
            return
        }
        CATransaction.begin()
        var actionResult: RoutingResult = .failure(RoutingError.compositionFailed(.init("Wrapped \(action) did not complete correctly.")))
        action.perform(with: viewController, on: existingController, animated: true, completion: { result in
            actionResult = result
        })
        CATransaction.setCompletionBlock {
            completion(actionResult)
        }
        CATransaction.commit()
    }

}
