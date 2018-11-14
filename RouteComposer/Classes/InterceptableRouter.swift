//
// Created by Eugene Kazaev on 18/06/2018.
//

import Foundation
import UIKit

/// The router implementing this protocol should support global tasks.
public protocol InterceptableRouter where Self: Router {

    /// Adds `RoutingInterceptor` instance
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing to this step.
    mutating func add<R: RoutingInterceptor>(_ interceptor: R) where R.Context == Any?

    /// Adds ContextTask instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be applied by a `Router` immediately after it will find
    ///   or create `UIViewController`.
    mutating func add<CT: ContextTask>(_ contextTask: CT) where CT.ViewController == UIViewController, CT.Context == Any?

    /// Adds PostRoutingTask instance
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    mutating func add<P: PostRoutingTask>(_ postTask: P) where P.Context == Any?

}
