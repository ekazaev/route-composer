//
// RouteComposer
// Router.swift
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

/// Base router protocol.
@MainActor
public protocol Router {

    // MARK: Methods to implement

    /// Navigates the application to the view controller configured in `DestinationStep` with the `Context` provided.
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - context: `Context` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                             with context: Context,
                                                             animated: Bool,
                                                             completion: ((_: RoutingResult) -> Void)?) throws

}

// MARK: Helper methods

@MainActor
public extension Router {

    @available(iOS 13.0.0, *)
    func navigate<Context>(to step: DestinationStep<some UIViewController, Context>,
                           with context: Context,
                           animated: Bool) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try navigate(to: step, with: context, animated: animated) { result in
                    switch result {
                    case .success:
                        continuation.resume()
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Navigates the application to the view controller configured in `DestinationStep` with the `Context` set to `Any?`.
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func navigate(to step: DestinationStep<some UIViewController, Any?>,
                  animated: Bool,
                  completion: ((_: RoutingResult) -> Void)?) throws {
        try navigate(to: step, with: nil, animated: animated, completion: completion)
    }

    @available(iOS 13.0.0, *)
    func navigate(to step: DestinationStep<some UIViewController, Any?>,
                  animated: Bool) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try navigate(to: step, with: nil, animated: animated) { result in
                    switch result {
                    case .success:
                        continuation.resume()
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Navigates the application to the view controller configured in `DestinationStep` with the `Context` set to `Void`.
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func navigate(to step: DestinationStep<some UIViewController, Void>,
                  animated: Bool,
                  completion: ((_: RoutingResult) -> Void)?) throws {
        try navigate(to: step, with: (), animated: animated, completion: completion)
    }

    @available(iOS 13.0.0, *)
    func navigate(to step: DestinationStep<some UIViewController, Void>,
                  animated: Bool) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try navigate(to: step, with: (), animated: animated) { result in
                    switch result {
                    case .success:
                        continuation.resume()
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

}

// MARK: Navigation without the exception throwing

@MainActor
public extension Router {

    /// Navigates the application to the view controller configured in `DestinationStep` with the `Context` provided.
    /// Method does not throw errors, but propagates them to the completion block
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - context: `Context` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func commitNavigation<Context>(to step: DestinationStep<some UIViewController, Context>,
                                   with context: Context,
                                   animated: Bool,
                                   completion: ((RoutingResult) -> Void)?) {
        do {
            try navigate(to: step, with: context, animated: animated, completion: completion)
        } catch {
            completion?(.failure(error))
        }
    }

    /// Navigates the application to the view controller configured in `DestinationStep` with the `Context` set to `Any?`.
    /// Method does not throw errors, but propagates them to the completion block
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func commitNavigation(to step: DestinationStep<some UIViewController, Any?>,
                          animated: Bool,
                          completion: ((RoutingResult) -> Void)?) {
        commitNavigation(to: step, with: nil, animated: animated, completion: completion)
    }

    /// Navigates the application to the view controller configured in `DestinationStep` with the `Context` set to `Void`.
    /// Method does not throw errors, but propagates them to the completion block
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func commitNavigation(to step: DestinationStep<some UIViewController, Void>,
                          animated: Bool,
                          completion: ((RoutingResult) -> Void)?) {
        commitNavigation(to: step, with: (), animated: animated, completion: completion)
    }

}
