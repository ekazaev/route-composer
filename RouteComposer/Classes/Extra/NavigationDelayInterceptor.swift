//
// RouteComposer
// NavigationDelayInterceptor.swift
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

/// `NavigationDelayingInterceptor` delays the router from starting the navigation, while any view controllers in the
/// stack are being presented or dismissed. In case your app has some other navigation instruments rather than
/// `RouteComposer` or you have a situation when a few routers work simultaneously, add it to your **router** to avoid
/// the router not being able to navigate to the destination because a view controller in the stack is
/// being presented or dismissed.
///
/// *NB: `UIKit` does not allow simultaneous changes in `UIViewController` stack. The `.wait` strategy does not
/// guarantee 100% protection from all possible situations. The code must be written in a way that avoids such
/// situations. The `.wait` strategy can be used only as a temporary solution.*
public struct NavigationDelayingInterceptor<Context>: RoutingInterceptor {

    // MARK: Internal entities

    /// The strategy to be used by `NavigationDelayingInterceptor`
    ///
    /// - wait: Wait while some `UIViewController` is being presented or dismissed.
    /// - abort:  Abort tha navigation if some `UIViewController` is being presented or dismissed.
    public enum Strategy {

        /// Abort tha navigation if some `UIViewController` is being presented or dismissed.
        case abort

        /// Wait while some `UIViewController` is being presented or dismissed.
        case wait

    }

    // MARK: Properties

    /// `WindowProvider` instance.
    public let windowProvider: WindowProvider

    /// `Logger` instance.
    public let logger: Logger?

    /// Type of `Strategy`.
    public let strategy: Strategy

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - windowProvider: `WindowProvider` instance.
    ///   - strategy: Type of `Strategy` to be used.
    ///   - logger: `Logger` instance.
    public init(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider,
                strategy: Strategy = .abort,
                logger: Logger? = RouteComposerDefaults.shared.logger) {
        self.windowProvider = windowProvider
        self.logger = logger
        self.strategy = strategy
    }

    public func perform(with context: Context, completion: @escaping (RoutingResult) -> Void) {
        guard let topmostViewController = getTopmostViewController(),
              topmostViewController.isBeingDismissed || topmostViewController.isBeingPresented else {
            completion(.success)
            return
        }
        guard strategy == .wait else {
            completion(.failure(RoutingError.compositionFailed(.init("\(topmostViewController) is changing its state. Navigation has been aborted."))))
            return
        }

        logger?.log(.info("\(topmostViewController) is changing its state. Navigation has been postponed."))
        let deadline = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            perform(with: context, completion: completion)
        }
    }

    private func getTopmostViewController() -> UIViewController? {
        var topmostViewController = windowProvider.window?.rootViewController

        while let presentedViewController = topmostViewController?.presentedViewController {
            topmostViewController = presentedViewController
        }

        return topmostViewController
    }

}
