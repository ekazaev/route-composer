//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

private var navigationAnalyticsParameters: ExampleAnalyticsParameters? = nil

class ExampleAnalyticsInterceptor: RoutingInterceptor {

    typealias Context = Any?

    // We have to set source in interceptor and not in post action because by the time routing happened, source
    // `UIViewController` may not exist any more. We do not want to keep any strong reference to it and prevent it's
    // normal life cycle, so we will use it's parameters in analytics before any routing happen.
    func execute(for context: Context, completion: @escaping (InterceptorResult) -> Void) {
        guard navigationAnalyticsParameters == nil else {
            completion(.failure("Internal inconsistency. Another navigation has not been completed."))
            return
        }

        guard let topmostViewController = UIWindow.key?.topmostViewController,
              let viewController = UIViewController.findViewController(in: topmostViewController,
                      options: [.current, .visible],
                      using: { $0 is ExampleAnalyticsSupport }) as? ExampleAnalyticsSupport else {
            completion(.success)
            return
        }

        navigationAnalyticsParameters = viewController.analyticParameters
        completion(.success)
    }

}

class ExampleAnalyticsPostTask: PostRoutingTask {

    typealias ViewController = UIViewController

    typealias Destination = Any?

    func execute(on viewController: ViewController, for destination: Destination, routingStack: [UIViewController]) {
        defer {
            navigationAnalyticsParameters = nil
        }
        guard let source = navigationAnalyticsParameters?.source, let lastViewController = routingStack.last else {
            return
        }

        print("Source: \(source)")
        if let analyticsViewController = UIViewController.findViewController(in: lastViewController,
                options: [.current, .visible],
                using: { $0 is ExampleAnalyticsSupport }) as? ExampleAnalyticsSupport {
            print("Target: \(analyticsViewController.analyticParameters.source)")
        }
        print("-----")
    }

}
