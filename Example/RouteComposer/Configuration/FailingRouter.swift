//
// RouteComposer
// FailingRouter.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

struct FailingRouterIgnoreError: Error {

    let underlyingError: Error

    init(underlyingError: Error) {
        self.underlyingError = underlyingError
    }

}

// Simple wrapper to warn if something goes wrong
struct FailingRouter<R>: Router where R: Router {

    var router: R

    let failOnError: Bool

    init(router: R, failOnError: Bool = true) {
        self.router = router
        self.failOnError = failOnError
    }

    func navigate<Context>(to step: DestinationStep<some UIViewController, Context>,
                           with context: Context,
                           animated: Bool,
                           completion: ((RoutingResult) -> Void)?) throws {
        do {
            try router.navigate(to: step, with: context, animated: animated, completion: { result in
                if let error = try? result.getError() {
                    failIfNeeded(error: error)
                }
                completion?(result)
            })
        } catch {
            failIfNeeded(error: error)
            throw error
        }
    }

    @MainActor private func failIfNeeded(error: Error) {
        guard failOnError, !(error is FailingRouterIgnoreError) else {
            return
        }
        if let routingError = error as? RoutingError,
           case .cantBeDismissed = routingError {
            RouteComposerDefaults.shared.logger?.log(.info("Ignoring \(routingError.description)"))
        } else {
            assertionFailure("Navigation is unsuccessful: \(error)")
        }
    }

}

extension FailingRouter: InterceptableRouter where R: InterceptableRouter {

    mutating func add<RI: RoutingInterceptor>(_ interceptor: RI) where RI.Context == Any? {
        router.add(interceptor)
    }

    mutating func add<CT: ContextTask>(_ contextTask: CT) where CT.ViewController == UIViewController, CT.Context == Any? {
        router.add(contextTask)
    }

    mutating func add<PT: PostRoutingTask>(_ postTask: PT) where PT.Context == Any? {
        router.add(postTask)
    }

}
