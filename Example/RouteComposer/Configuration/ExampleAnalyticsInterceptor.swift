//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

//class ExampleAnalyticsInterceptor: RoutingInterceptor {
//
//    typealias Context = ExampleDestination
//
//    // We have to set source in interceptor and not in post action because by the time routing happened, source
//    // `UIViewController` may not exist any more. We do not want to keep any strong reference to it and prevent it's
//    // normal life cycle, so we will use it's parameters in analytics before any routing happen.
//    func execute(for destination: Context, completion: @escaping (InterceptorResult) -> Void) {
//        guard destination.analyticParameters == nil,
//              let viewController =
//              UIWindow.key?.rootViewController?.topmostNonContainerViewController as? ExampleAnalyticsSupport else {
//            completion(.success)
//            return
//        }
//
//        destination.analyticParameters = viewController.analyticParameters
//        completion(.success)
//    }
//
//}
