//
// Created by Eugene Kazaev on 15/01/2019.
//

import Foundation
import UIKit

/// Lock object to be shared between `SingleNavigationRouter` instances.
public final class SingleNavigationLock {

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

    public func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                                    with context: Context,
                                                                    animated: Bool,
                                                                    completion: ((RoutingResult) -> Void)?) throws {
        guard !lock.isNavigationInProgress else {
            throw RoutingError.compositionFailed(.init("Navigation is in progress"))
        }
        lock.startNavigation()
        do {
            try router.navigate(to: step, with: context, animated: animated, completion: { success in
                self.lock.stopNavigation()
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
