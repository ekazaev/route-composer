//
//  InlineTasks.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 16/07/2018.
//

import Foundation
import UIKit

/// `InlineInterceptor` is the inline interceptor.
///
/// **NB:** We would recommend it for the purpose of configuration testing, but then replace it with a strongly typed
/// `RoutingInterceptor` instance.
public struct InlineInterceptor<C>: RoutingInterceptor {

    public typealias Context = C

    private let prepareBlock: ((_: C) throws -> Void)?

    private let asyncCompletion: ((_: C, _: @escaping (InterceptorResult) -> Void) -> Void)?

    private let syncCompletion: ((_: C) -> Void)?

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineInterceptor` will take a control over the routing.
    ///
    ///     **NB** For `Router` to be able to continue routing, completion block method **MUST** to be called.
    public init(prepare: ((_: C) throws -> Void)? = nil, _ completion: @escaping (_: C, _: @escaping (InterceptorResult) -> Void) -> Void) {
        self.prepareBlock = prepare
        self.asyncCompletion = completion
        self.syncCompletion = nil
    }

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineInterceptor` will take a control over the routing.
    ///
    ///     **NB** completion method will be called automatically so do not use this constructor if your interceptor
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
            completion(.success)
        } else if let asyncCompletion = asyncCompletion {
            asyncCompletion(context, completion)
        } else {
            completion(.failure("No completion block provided."))
        }
    }

}

/// `InlineContextTask` is the inline context task.
///
/// **NB:** We would recommend it for the purpose of configuration testing, but then replace it with a strongly typed
/// `ContextTask` instance.
public struct InlineContextTask<VC: UIViewController, C>: ContextTask {

    public typealias ViewController = VC

    public typealias Context = C

    private let completion: (_: VC, _: C) throws -> Void

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineContextTask` will be applied to the `UIViewController`
    ///    instance.
    public init(_ completion: @escaping (_: VC, _: C) throws -> Void) {
        self.completion = completion
    }

    public func apply(on viewController: ViewController, with context: Context) throws {
        try completion(viewController, context)
    }

}

/// `InlinePostTask` is the inline context task.
///
/// **NB:** We would recommend it for the purpose of configuration testing, but then replace it with a strongly typed
/// `PostRoutingTask` instance.
public struct InlinePostTask<VC: UIViewController, C>: PostRoutingTask {

    public typealias ViewController = VC

    public typealias Context = C

    private let completion: (_: VC, _: C, _: [UIViewController]) -> Void

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlinePostTask` will be called at the end of the routing
    ///    process.
    public init(_ completion: @escaping (_: VC, _: C, _: [UIViewController]) -> Void) {
        self.completion = completion
    }

    public func execute(on viewController: ViewController, with context: Context, routingStack: [UIViewController]) {
        completion(viewController, context, routingStack)
    }

}
