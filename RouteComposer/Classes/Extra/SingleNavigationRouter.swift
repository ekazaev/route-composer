//
// Created by Eugene Kazaev on 15/01/2019.
// Copyright © 2019 HBC Digital. All rights reserved.
//

import Foundation

/// Lock object to be shared between `SingleNavigationRouter` instances.
public class SingleNavigationLock {

    private var isNavigationInProgressFlag = false

    /// `SingleNavigationLock` state
    public var isNavigationInProgress: Bool {
        return isNavigationInProgressFlag
    }

    /// Constructor
    public init() {
    }

    func startNavigation() {
        isNavigationInProgressFlag = true
    }

    func stopNavigation() {
        isNavigationInProgressFlag = false
    }

}

/// The `Router` proxy guarantees that not more than one navigation will happen simultaneously.
///
/// It is useful to avoid situations when the application can not control the amount of navigations
/// (for example, navigations triggered by push notifications)
public struct SingleNavigationRouter<ROUTER>: Router where ROUTER: Router {

    var router: ROUTER

    let lock: SingleNavigationLock

    /// Constructor
    ///
    /// - Parameters:
    ///   - router: `Router` instance to proxy.
    ///   - lock: Shared `SingleNavigationLock` instance.
    public init(router: ROUTER, lock: SingleNavigationLock) {
        self.router = router
        self.lock = lock
    }

    public func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                                    with context: Context,
                                                                    animated: Bool,
                                                                    completion: ((RoutingResult) -> Void)?) throws {
        guard !lock.isNavigationInProgress else {
            throw RoutingError.generic(RoutingError.Context("Navigation is in progress"))
        }
        lock.startNavigation()
        do {
            try router.navigate(to: step, with: context, animated: animated, completion: { success in
                self.lock.stopNavigation()
                completion?(success)
            })
        } catch let error {
            lock.stopNavigation()
            throw error
        }
    }

}

extension SingleNavigationRouter: InterceptableRouter where ROUTER: InterceptableRouter {

    public mutating func add<R: RoutingInterceptor>(_ interceptor: R) where R.Context == Any? {
        router.add(interceptor)
    }

    public mutating func add<CT: ContextTask>(_ contextTask: CT) where CT.ViewController == UIViewController, CT.Context == Any? {
        router.add(contextTask)
    }

    public mutating func add<P: PostRoutingTask>(_ postTask: P) where P.Context == Any? {
        router.add(postTask)
    }

}
