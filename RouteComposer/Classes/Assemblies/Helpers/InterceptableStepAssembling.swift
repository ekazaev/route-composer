//
// Created by Eugene Kazaev on 10/09/2018.
//

import Foundation
import UIKit

/// Assembly protocol allowing to build an interceptable step.
protocol InterceptableStepAssembling {

    /// Supported `UIViewController` type
    associatedtype ViewController: UIViewController

    /// Supported `Context` type
    associatedtype Context

    /// Adds `RoutingInterceptor` instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before the navigation process
    ///   to this step.
    func adding<R: RoutingInterceptor>(_ interceptor: R) -> Self where R.Context == Context

    /// Adds `ContextTask` instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be applied by a `Router` immediately after it
    ///   will find or create `UIViewController`.
    func adding<CT: ContextTask>(_ contextTask: CT) -> Self where CT.ViewController == ViewController, CT.Context == Context

    /// Adds `PostRoutingTask` instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after the navigation process.
    func adding<P: PostRoutingTask>(_ postTask: P) -> Self where P.Context == Context

}
