//
// RouteComposer
// InlineInterceptor.swift
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

/// `InlineInterceptor`
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `RoutingInterceptor` instance.
public struct InlineInterceptor<C>: RoutingInterceptor {

    // MARK: Properties

    private let prepareBlock: ((_: C) throws -> Void)?

    private let performBlock: (_: C, _: @escaping (RoutingResult) -> Void) -> Void

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineInterceptor` will take a control over the navigation process.
    ///
    ///     **NB** For `Router` to be able to continue navigation process, completion block method **MUST** be called.
    public init(prepare prepareBlock: ((_: C) throws -> Void)? = nil, _ performBlock: @escaping (_: C, _: @escaping (RoutingResult) -> Void) -> Void) {
        self.prepareBlock = prepareBlock
        self.performBlock = performBlock
    }

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineInterceptor` will take a control over the navigation process.
    ///
    ///     **NB** completion method will be called automatically, do not use this constructor if your interceptor
    ///     task is asynchronous.
    public init(prepare prepareBlock: ((_: C) throws -> Void)? = nil, _ inlineBlock: @escaping (_: C) throws -> Void) {
        self.prepareBlock = prepareBlock
        self.performBlock = { context, completion in
            do {
                try inlineBlock(context)
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func prepare(with context: C) throws {
        try prepareBlock?(context)
    }

    public func perform(with context: C, completion: @escaping (RoutingResult) -> Void) {
        performBlock(context, completion)
    }

}
