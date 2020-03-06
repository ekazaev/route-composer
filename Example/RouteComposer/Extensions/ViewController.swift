//
// RouteComposer
// ViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import os.log
import RouteComposer
import UIKit

extension UIViewController {

    static let router: Router = {
        let appRouterLogger: DefaultLogger
        if #available(iOS 10, *) {
            appRouterLogger = DefaultLogger(.verbose, osLog: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Router"))
        } else {
            appRouterLogger = DefaultLogger(.verbose)
        }
        var defaultRouter = DefaultRouter(logger: appRouterLogger)
        defaultRouter.add(NavigationDelayingInterceptor(strategy: .wait, logger: appRouterLogger))
        return AnalyticsRouterDecorator(router: defaultRouter)
    }()

    var router: Router {
        return UIViewController.router
    }

}
