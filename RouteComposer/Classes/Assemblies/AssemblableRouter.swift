//
// Created by Eugene Kazaev on 18/06/2018.
//

import Foundation

/// Router implementing this protocol should support global tasks.
public protocol AssemblableRouter where Self: Router {

    /// Adds routing interceptor instance
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing to this step.
    @discardableResult
    mutating func add<R: RoutingInterceptor>(_ interceptor: R) -> Self

    /// Adds context task instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be executed by a `Router` immediately after it will find or create UIViewController.
    @discardableResult
    mutating func add<CT: ContextTask>(_ contextTask: CT) -> Self

    /// Adds PostRoutingTask instance
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    @discardableResult
    mutating func add<P: PostRoutingTask>(_ postTask: P) -> Self

}
