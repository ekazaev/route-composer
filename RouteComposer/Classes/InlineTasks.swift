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
public struct InlineInterceptor<D: RoutingDestination>: RoutingInterceptor {
    
    public typealias Destination = D
    
    private let prepareBlock: ((_: D) throws -> Void)?
    
    private let asyncCompletion: ((_: D, _: @escaping (InterceptorResult) -> Void) -> Void)?
    
    private let syncCompletion: ((_: D) -> Void)?
    
    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineInterceptor` will take a control over the routing.
    ///
    ///     **NB** For `Router` to be able to continue routing, completion block method **MUST** to be called.
    public init(prepare: ((_: D) throws  -> Void)? = nil,_ completion: @escaping (_: D, _: @escaping (InterceptorResult) -> Void) -> Void) {
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
    public init(prepare: ((_: D) throws -> Void)? = nil, _ completion: @escaping (_: D) -> Void) {
        self.prepareBlock = prepare
        self.syncCompletion = completion
        self.asyncCompletion = nil
    }
    
    public func prepare(with destination: D) throws {
        try prepareBlock?(destination)
    }
    
    public func execute(for destination: D, completion: @escaping (InterceptorResult) -> Void) {
        if let syncCompletion = syncCompletion {
            syncCompletion(destination)
            completion(.success)
        } else if let asyncCompletion = asyncCompletion {
            asyncCompletion(destination, completion)
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
    
    private let completion: (_: VC, _: C) -> Void
    
    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineContextTask` will be applied to the `UIViewController`
    ///    instance.
    public init(_ completion: @escaping (_: VC, _: C) -> Void) {
        self.completion = completion
    }
    
    public func apply(on viewController: ViewController, with context: Context) {
        completion(viewController, context)
    }
    
}

/// `InlinePostTask` is the inline context task.
///
/// **NB:** We would recommend it for the purpose of configuration testing, but then replace it with a strongly typed
/// `PostRoutingTask` instance.
public struct InlinePostTask<VC: UIViewController, D: RoutingDestination>: PostRoutingTask {
    
    public typealias ViewController = VC
    
    public typealias Destination = D
    
    private let completion: (_: VC, _: D, _: [UIViewController]) -> Void
    
    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlinePostTask` will be called at the end of the routing
    ///    process.
    public init(_ completion: @escaping (_: VC, _: D, _: [UIViewController]) -> Void) {
        self.completion = completion
    }
    
    public func execute(on viewController: ViewController, for destination: Destination, routingStack: [UIViewController]) {
        completion(viewController, destination, routingStack)
    }
    
}
