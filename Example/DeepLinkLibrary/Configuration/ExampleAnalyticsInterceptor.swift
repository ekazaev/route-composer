//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ExampleAnalyticsInterceptor: RouterInterceptor {

    typealias C = ExampleContext

    // We have to set source in interceptor and not in post action because by the time routing happened, source
    // UIViewController may not exist any more. We do not want to keep any strong reference to it and prevent it's
    // normal life cycle, so we will use it's parameters in analytics before any routing happen.
    func execute(with context: C?, logger: Logger?, completion: @escaping (InterceptorResult) -> Void) {
        guard context?.analyticParameters == nil,
              let viewController = UIWindow.key?.rootViewController?.topmostNonContainerViewController as? AnalyticsSupportViewController else {
            completion(.success)
            return
        }

        context?.analyticParameters = viewController.analyticParameters
        completion(.success)
    }

}
