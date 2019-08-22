//
// Created by Eugene Kazaev on 15/01/2018.
//

import UIKit
import RouteComposer
import os.log

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
