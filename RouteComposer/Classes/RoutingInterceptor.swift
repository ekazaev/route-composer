//
// RouteComposer
// RoutingInterceptor.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

/// `RoutingInterceptor` is called before the actual navigation process happens.
/// e.g. user should be logged in.
///
/// ### NB
/// Interceptor is an asynchronous action. For the `Router` to continue the navigation process, the `completion` block of the interceptor's
/// execute method **MUST** be called.
/// Otherwise, the `Router` will stay in a limbo state waiting for the interceptor to finish its action.
public protocol RoutingInterceptor {

    // MARK: Associated types

    /// `Context` type associated with `RoutingInterceptor`
    associatedtype Context

    // MARK: Methods to implement

    /// The `Router` will call this method before the navigation process. If `RoutingInterceptor` is not able to allow
    /// the navigation process to start it can stop `Router` by throwing an exception.
    ///
    /// - Parameters:
    ///   - context: The `Context` instance that is provided to the `Router`.
    /// - Throws: The `RoutingError` if the `RoutingInterceptor` cannot prepare itself or if the navigation process cannot start
    ///   with the `Context` instance provided.
    mutating func prepare(with context: Context) throws

    /// Method that will be called by `Router` to start interceptor.
    ///
    /// - Parameters:
    ///   - context: `Context` instance provided to the `Router`
    ///   - completion: Completion block with a result.
    ///
    /// ###NB
    /// For the `Router` to continue the navigation process, the `completion` block of interceptor **MUST** be called
    /// by the implementation of this method.
    /// Otherwise `Router` will stay in limbo waiting for `RoutingInterceptor` to finish its action.
    func perform(with context: Context, completion: @escaping (_: RoutingResult) -> Void)

}

// MARK: Default implementation

public extension RoutingInterceptor {

    /// Default implementation does nothing.
    func prepare(with context: Context) throws {}

}

// MARK: Helper methods

public extension RoutingInterceptor {

    /// Prepares the `RoutingInterceptor` and executes it
    func execute(with context: Context, completion: @escaping (_: RoutingResult) -> Void) throws {
        var interceptor = self
        try interceptor.prepare(with: context)
        interceptor.perform(with: context, completion: completion)
    }

    /// Prepares the `RoutingInterceptor` and performs it. Does not throw an exception.
    func commit(with context: Context, completion: @escaping (_: RoutingResult) -> Void) {
        do {
            try execute(with: context, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

}

// MARK: Helper methods where the Context is Any?

public extension RoutingInterceptor where Context == Any? {

    /// The `Router` will call this method before the navigation process. If `RoutingInterceptor` is not able to allow
    /// the navigation process to start it can stop `Router` by throwing an exception.
    ///
    /// - Throws: The `RoutingError` if the `RoutingInterceptor` cannot prepare itself or if the navigation process cannot start
    ///   with the `Context` instance provided.
    mutating func prepare() throws {
        try prepare(with: nil)
    }

    /// Method that will be called by `Router` to start interceptor.
    ///
    /// - Parameters:
    ///   - completion: Completion block with a result.
    ///
    /// ###NB
    /// For the `Router` to continue the navigation process, the `completion` block of interceptor **MUST** be called
    /// by the implementation of this method.
    /// Otherwise `Router` will stay in limbo waiting for `RoutingInterceptor` to finish its action.
    func perform(completion: @escaping (_: RoutingResult) -> Void) {
        perform(with: nil, completion: completion)
    }

    /// Prepares the `RoutingInterceptor` and executes it
    func execute(completion: @escaping (_: RoutingResult) -> Void) throws {
        try execute(with: nil, completion: completion)
    }

    /// Prepares the `RoutingInterceptor` and performs it. Does not throw an exception.
    func commit(completion: @escaping (_: RoutingResult) -> Void) {
        commit(with: nil, completion: completion)
    }

}

// MARK: Helper methods where the Context is Void

public extension RoutingInterceptor where Context == Void {

    /// The `Router` will call this method before the navigation process. If `RoutingInterceptor` is not able to allow
    /// the navigation process to start it can stop `Router` by throwing an exception.
    ///
    /// - Throws: The `RoutingError` if the `RoutingInterceptor` cannot prepare itself or if the navigation process cannot start
    ///   with the `Context` instance provided.
    mutating func prepare() throws {
        try prepare(with: ())
    }

    /// Method that will be called by `Router` to start interceptor.
    ///
    /// - Parameters:
    ///   - completion: Completion block with a result.
    ///
    /// ###NB
    /// For the `Router` to continue the navigation process, the `completion` block of interceptor **MUST** be called
    /// by the implementation of this method.
    /// Otherwise `Router` will stay in limbo waiting for `RoutingInterceptor` to finish its action.
    func perform(completion: @escaping (_: RoutingResult) -> Void) {
        perform(with: (), completion: completion)
    }

    /// Prepares the `RoutingInterceptor` and executes it
    func execute(completion: @escaping (_: RoutingResult) -> Void) throws {
        try execute(with: (), completion: completion)
    }

    /// Prepares the `RoutingInterceptor` and performs it. Does not throw an exception.
    func commit(completion: @escaping (_: RoutingResult) -> Void) {
        commit(with: (), completion: completion)
    }

}
