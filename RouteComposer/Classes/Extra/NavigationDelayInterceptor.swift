//
// Created by Eugene Kazaev on 2019-03-01.
// Copyright © 2019 HBC Digital. All rights reserved.
//

import Foundation

/// `NavigationDelayInterceptor` delays the router from starting the navigation, while any view controllers in the
/// stack are being presented or dismissed. In case your app has some other navigation instruments rather than
/// `RouteComposer` or you have a situation when a few routers work simultaneously, add it to your router to avoid
/// the router not being able to navigate to the destination because a view controller in the stack is
/// being presented or dismissed.
///
/// *NB: `UIKit` does not allow simultaneous changes in `UIViewController` stack. The `.wait` strategy does not
/// guarantee 100% protection from all possible situations. Code must be written in a way that avoids such
/// situations. The `.wait` strategy can be used only as a temporary solution.*
public struct NavigationDelayingInterceptor: RoutingInterceptor {

    /// The strategy to be used by `NavigationDelayInterceptor`
    ///
    /// - wait: Wait while some `UIViewController` is being presented or dismissed.
    /// - abort:  Abort tha navigation if some `UIViewController` is being presented or dismissed.
    public enum Strategy {

        /// Abort tha navigation if some `UIViewController` is being presented or dismissed.
        case abort

        /// Wait while some `UIViewController` is being presented or dismissed.
        case wait

    }

    let windowProvider: WindowProvider

    let logger: Logger?

    let strategy: Strategy

    /// Constructor
    ///
    /// - Parameters:
    ///   - windowProvider: `WindowProvider` instance.
    ///   - strategy: Type of `Strategy` to be used.
    ///   - logger: `Logger` instance.
    public init(windowProvider: WindowProvider = KeyWindowProvider(), strategy: Strategy = .abort, logger: Logger? = nil) {
        self.windowProvider = windowProvider
        self.logger = logger
        self.strategy = strategy
    }

    public func execute(with context: Any?, completion: @escaping (InterceptorResult) -> Void) {
        guard let topmostViewController = getTopmostViewController(),
              topmostViewController.isBeingDismissed || topmostViewController.isBeingPresented else {
            completion(.continueRouting)
            return
        }

        if strategy == .wait {
            logger?.log(.info("\(topmostViewController) is changing its state. Navigation has been postponed."))
            let deadline = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.execute(with: context, completion: completion)
            }
        } else {
            completion(.failure(RoutingError.compositionFailed(.init("\(topmostViewController) is changing its state. Navigation has been aborted."))))
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
