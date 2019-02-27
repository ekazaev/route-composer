//
//  InlineTasks.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 16/07/2018.
//

import Foundation
import UIKit

/// `InlineInterceptor`
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `RoutingInterceptor` instance.
public struct InlineInterceptor<C>: RoutingInterceptor {

    private let prepareBlock: ((_: C) throws -> Void)?

    private let asyncCompletion: ((_: C, _: @escaping (InterceptorResult) -> Void) -> Void)?

    private let syncCompletion: ((_: C) -> Void)?

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineInterceptor` will take a control over the navigation process.
    ///
    ///     **NB** For `Router` to be able to continue navigation process, completion block method **MUST** be called.
    public init(prepare: ((_: C) throws -> Void)? = nil, _ completion: @escaping (_: C, _: @escaping (InterceptorResult) -> Void) -> Void) {
        self.prepareBlock = prepare
        self.asyncCompletion = completion
        self.syncCompletion = nil
    }

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineInterceptor` will take a control over the navigation process.
    ///
    ///     **NB** completion method will be called automatically, do not use this constructor if your interceptor
    ///     task is asynchronous.
    public init(prepare: ((_: C) throws -> Void)? = nil, _ completion: @escaping (_: C) -> Void) {
        self.prepareBlock = prepare
        self.syncCompletion = completion
        self.asyncCompletion = nil
    }

    public func prepare(with context: C) throws {
        try prepareBlock?(context)
    }

    public func execute(with context: C, completion: @escaping (InterceptorResult) -> Void) {
        if let syncCompletion = syncCompletion {
            syncCompletion(context)
            completion(.continueRouting)
        } else if let asyncCompletion = asyncCompletion {
            asyncCompletion(context, completion)
        } else {
            assertionFailure("The completion block was not set.")
            completion(.failure(RoutingError.generic(.init("The completion block was not set."))))
        }
    }

}

/// `InlineContextTask`
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `RoutingInterceptor` instance.
public struct InlineContextTask<VC: UIViewController, C>: ContextTask {

    private let completion: (_: VC, _: C) throws -> Void

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineContextTask` will be applied to the `UIViewController`
    ///    instance.
    public init(_ completion: @escaping (_: VC, _: C) throws -> Void) {
        self.completion = completion
    }

    public func apply(on viewController: VC, with context: C) throws {
        try completion(viewController, context)
    }

}

/// `InlinePostTask` is the inline context task.
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `PostRoutingTask` instance.
public struct InlinePostTask<VC: UIViewController, C>: PostRoutingTask {

    private let completion: (_: VC, _: C, _: [UIViewController]) -> Void

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlinePostTask` will be called at the end of the navigation process
    ///   process.
    public init(_ completion: @escaping (_: VC, _: C, _: [UIViewController]) -> Void) {
        self.completion = completion
    }

    public func execute(on viewController: VC, with context: C, routingStack: [UIViewController]) {
        completion(viewController, context, routingStack)
    }

}
