//
// Created by Eugene Kazaev on 2018-09-17.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import RouteComposer

// Example that `Router` can be wrapped and you can add your functionality into navigation process
struct AnalyticsRouterDecorator: Router {

    let router: DefaultRouter

    init(router: DefaultRouter) {
        self.router = router
    }

    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                             with context: Context,
                                                             animated: Bool = true,
                                                             completion: ((RoutingResult) -> Void)? = nil) throws {
        var sourceScreen: ExampleScreenTypes?

        if let topmostViewController = UIApplication.shared.keyWindow?.topmostViewController,
           let viewController = UIViewController.findViewController(in: topmostViewController,
                   options: [.current, .visible],
                   using: { $0 is ExampleAnalyticsSupport }) as? ExampleAnalyticsSupport {
            sourceScreen = viewController.screenType
        }

         try router.navigate(to: step, with: context, animated: animated) { result in
            if let sourceScreen = sourceScreen {
                print("Source: \(sourceScreen)")
                if let topmostViewController = UIApplication.shared.keyWindow?.topmostViewController,
                   let analyticsViewController = UIViewController.findViewController(in: topmostViewController,
                           options: [.current, .visible],
                           using: { $0 is ExampleAnalyticsSupport }) as? ExampleAnalyticsSupport {
                    print("Target: \(analyticsViewController.screenType)")
                }
            }

            completion?(result)

        }
    }

}
