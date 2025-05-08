//
// RouteComposer
// AnalyticsRouterDecorator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer

// Example that `Router` can be wrapped and you can add your functionality into navigation process
@MainActor
struct AnalyticsRouterDecorator: Router {

    let router: Router

    init(router: Router) {
        self.router = router
    }

    func navigate<Context>(to step: DestinationStep<some UIViewController, Context>,
                           with context: Context,
                           animated: Bool = true,
                           completion: ((RoutingResult) -> Void)? = nil) throws {
        var sourceScreen: ExampleScreenTypes?

        if let topmostViewController = UIApplication.shared.windows.first?.topmostViewController,
           let viewController = try? UIViewController.findViewController(in: topmostViewController,
                                                                         options: [.current, .visible],
                                                                         using: { $0 is ExampleAnalyticsSupport }) as? ExampleAnalyticsSupport {
            sourceScreen = viewController.screenType
        }

        try router.navigate(to: step, with: context, animated: animated) { result in
            if let sourceScreen {
                print("Source: \(sourceScreen)")
                if let topmostViewController = UIApplication.shared.windows.first?.topmostViewController,
                   let analyticsViewController = try? UIViewController.findViewController(in: topmostViewController,
                                                                                          options: [.current, .visible],
                                                                                          using: { $0 is ExampleAnalyticsSupport }) as? ExampleAnalyticsSupport {
                    print("Target: \(analyticsViewController.screenType)")
                }
            }

            completion?(result)

        }
    }

}
