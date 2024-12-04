//
// RouteComposer
// ViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import os.log
import RouteComposer
import UIKit

extension UIViewController {

    // This class is needed just for the test purposes
    @MainActor private final class TestInterceptor: RoutingInterceptor {
        let logger: RouteComposer.Logger?
        let message: String

        init(_ message: String) {
            self.logger = RouteComposerDefaults.shared.logger
            self.message = message
        }

        func perform(with context: Any?, completion: @escaping (RoutingResult) -> Void) {
            logger?.log(.info(message))
            completion(.success)
        }
    }

    @MainActor static let router: Router = {
        fatalError("Not implemented")
//        var defaultRouter = GlobalInterceptorRouter(router: FailingRouter(router: DefaultRouter()))
//        defaultRouter.addGlobal(TestInterceptor("Global interceptors start"))
//        defaultRouter.addGlobal(NavigationDelayingInterceptor(strategy: .wait))
//        defaultRouter.add(TestInterceptor("Router interceptors start"))
//        return AnalyticsRouterDecorator(router: defaultRouter)
    }()

    @MainActor var router: Router {
        UIViewController.router
    }

}
