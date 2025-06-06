//
// RouteComposer
// Dismissible.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

@MainActor
let associatedObjectHandle = UnsafeRawPointer(UnsafeMutablePointer.allocate(capacity: 0))

/// `UIViewController` should conform to `Dismissible` protocol to be used with `DismissalMethodProvidingContextTask`.
@MainActor
public protocol Dismissible where Self: UIViewController {

    // MARK: Associated types

    /// Type of instance that `Dismissible` `UIViewController` will provide on dismissal.
    associatedtype DismissalTargetContext

    // MARK: Properties to implement

    /// Property to store the dismissal block provided by `DismissalMethodProvidingContextTask`
    var dismissalBlock: ((_: Self, _: DismissalTargetContext, _: Bool, _: ((_: RoutingResult) -> Void)?) -> Void)? { get set }

}

// MARK: Helper methods

@MainActor
public extension Dismissible {

    /// Dismisses current `UIViewController` using dismissal block provided by `DismissalMethodProvidingContextTask`
    ///
    /// - Parameters:
    ///   - context: `DismissalTargetContext` required to be dismissed.
    ///   - animated: Dismissal process should be animated if set to `true`
    ///   - completion: The completion block.
    func dismissViewController(with context: DismissalTargetContext, animated: Bool, completion: ((_: RoutingResult) -> Void)? = nil) {
        guard let dismissalBlock else {
            let message = "Dismissal block has not been set."
            assertionFailure(message)
            completion?(.failure(RoutingError.compositionFailed(.init(message))))
            return
        }
        dismissalBlock(self, context, animated, completion)
    }

}

// MARK: Helper methods where the DismissalTargetContext is Any?

@MainActor
public extension Dismissible where DismissalTargetContext == Any? {

    /// Dismisses current `UIViewController` using dismissal block provided by `DismissalMethodProvidingContextTask`
    ///
    /// - Parameters:
    ///   - animated: Dismissal process should be animated if set to `true`
    ///   - completion: The completion block.
    func dismissViewController(animated: Bool, completion: ((_: RoutingResult) -> Void)? = nil) {
        dismissViewController(with: nil, animated: animated, completion: completion)
    }

}

// MARK: Helper methods where the DismissalTargetContext is Void

@MainActor
public extension Dismissible where DismissalTargetContext == Void {

    /// Dismisses current `UIViewController` using dismissal block provided by `DismissalMethodProvidingContextTask`
    ///
    /// - Parameters:
    ///   - animated: Dismissal process should be animated if set to `true`
    ///   - completion: The completion block.
    func dismissViewController(animated: Bool, completion: ((_: RoutingResult) -> Void)? = nil) {
        dismissViewController(with: (), animated: animated, completion: completion)
    }

}

/// `DismissibleWithRuntimeStorage` simplifies `Dismissible` protocol conformance implementing required
/// `dismissalBlock` using Objective C runtime.

@MainActor
public protocol DismissibleWithRuntimeStorage: Dismissible {}

@MainActor
public extension DismissibleWithRuntimeStorage {

    var dismissalBlock: ((_: Self, _: DismissalTargetContext, _: Bool, _: ((_: RoutingResult) -> Void)?) -> Void)? {
        get {
            objc_getAssociatedObject(self, associatedObjectHandle) as? (_: Self, _: DismissalTargetContext, _: Bool, _: ((_: RoutingResult) -> Void)?) -> Void
        }
        set {
            objc_setAssociatedObject(self, associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}
