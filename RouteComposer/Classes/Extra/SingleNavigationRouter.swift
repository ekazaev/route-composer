//
// RouteComposer
// SingleNavigationRouter.swift
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

/// Lock object to be shared between `SingleNavigationRouter` instances.
public final class SingleNavigationLock {

    private final var isNavigationInProgressFlag = false

    /// `SingleNavigationLock` state
    public final var isNavigationInProgress: Bool {
        isNavigationInProgressFlag
    }

    /// Constructor
    public init() {}

    final func startNavigation() {
        isNavigationInProgressFlag = true
    }

    final func stopNavigation() {
        isNavigationInProgressFlag = false
    }

}

/// The `Router` proxy guarantees that not more than one navigation will happen simultaneously.
///
/// It is useful to avoid situations when the application can not control the amount of navigations
/// (for example, a navigation triggered by the push notifications)
public struct SingleNavigationRouter<R>: Router where R: Router {

    // MARK: Properties

    var router: R

    /// Shared `SingleNavigationLock` instance
    public let lock: SingleNavigationLock

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - router: `Router` instance to proxy.
    ///   - lock: Shared `SingleNavigationLock` instance.
    public init(router: R, lock: SingleNavigationLock) {
        self.router = router
        self.lock = lock
    }

    public func navigate<Context>(to step: DestinationStep<some UIViewController, Context>,
                                  with context: Context,
                                  animated: Bool,
                                  completion: ((RoutingResult) -> Void)?) throws {
        guard !lock.isNavigationInProgress else {
            throw RoutingError.compositionFailed(.init("Navigation is in progress"))
        }
        lock.startNavigation()
        do {
            try router.navigate(to: step, with: context, animated: animated, completion: { success in
                lock.stopNavigation()
                completion?(success)
            })
        } catch {
            lock.stopNavigation()
            throw error
        }
    }

}

extension SingleNavigationRouter: InterceptableRouter where R: InterceptableRouter {

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
