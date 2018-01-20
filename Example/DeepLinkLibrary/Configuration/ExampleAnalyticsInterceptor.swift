//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ExampleAnalyticsInterceptor: RouterInterceptor {

    func apply(with arguments: Any?, logger: Logger?, completion: @escaping (InterceptorResult) -> Void) {
        guard let arguments = arguments as? ExampleArguments, arguments.analyticParameters == nil,
              let viewController = UIWindow.key?.rootViewController?.topmostNonContainerViewController as? AnalyticsSupportViewController else {
            completion(.success)
            return
        }

        arguments.analyticParameters = viewController.analyticParameters
        completion(.success)
    }

}
