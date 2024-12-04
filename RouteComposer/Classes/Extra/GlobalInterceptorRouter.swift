//
// RouteComposer
// GlobalInterceptorRouter.swift
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

/// The `DefaultRouter` searches for the view controller as a starting point before it starts to run interceptors.
/// Sometimes if interceptor can change the entire stack of view controllers it is handy to run a global interceptor
/// any starting point is found. `GlobalInterceptorRouter` proxy allows to add such a global interceptor that will be
/// executed before any work that `DefaultRouter` will do.
public struct GlobalInterceptorRouter<R>: Router where R: Router {

    // MARK: Properties

    var router: R

    private var interceptors: [AnyRoutingInterceptor] = []

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - router: `Router` instance to proxy.
    public init(router: R) {
        self.router = router
    }

    public func navigate<Context>(to step: DestinationStep<some UIViewController, Context>,
                                  with context: Context,
                                  animated: Bool,
                                  completion: ((RoutingResult) -> Void)?) throws {
        do {
            let interceptorRunner = try DefaultRouter.InterceptorRunner(interceptors: interceptors, with: AnyContextBox(context))
            interceptorRunner.perform(completion: { result in
                do {
                    switch result {
                    case .success:
                        try router.navigate(to: step, with: context, animated: animated, completion: { result in
                            completion?(result)
                        })
                    case let .failure(error):
                        throw error
                    }
                } catch {
                    completion?(.failure(error))
                }
            })
        } catch {
            throw error
        }
    }

    /// Adds `RoutingInterceptor` instance to the `GlobalInterceptorRouter`
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing to this step.
    public mutating func addGlobal<RI: RoutingInterceptor>(_ interceptor: RI) where RI.Context == Any? {
        interceptors.append(RoutingInterceptorBox(interceptor))
    }

}

extension GlobalInterceptorRouter: InterceptableRouter where R: InterceptableRouter {

    public mutating func add<RI: RoutingInterceptor>(_ interceptor: RI) where RI.Context == Any? {
        router.add(interceptor)
    }

    public mutating func add<CT: ContextTask>(_ contextTask: CT) where CT.ViewController == UIViewController, CT.Context == Any? {
        router.add(contextTask)
    }

    public mutating func add<PT: PostRoutingTask>(_ postTask: PT) where PT.Context == Any? {
        router.add(postTask)
    }

}
