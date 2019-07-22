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

    private let performBlock: ((_: C, _: @escaping (RoutingResult) -> Void) -> Void)

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

    public func perform(on viewController: VC, with context: C) throws {
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

    public func perform(on viewController: VC, with context: C, routingStack: [UIViewController]) {
        completion(viewController, context, routingStack)
    }

}
