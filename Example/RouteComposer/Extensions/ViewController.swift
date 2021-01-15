//
// RouteComposer
// ViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import os.log
import RouteComposer
import UIKit

extension UIViewController {

    static let router: Router = {
        var defaultRouter = DefaultRouter()
        defaultRouter.add(NavigationDelayingInterceptor(strategy: .wait))
        return AnalyticsRouterDecorator(router: defaultRouter)
    }()

    var router: Router {
        UIViewController.router
    }

}
