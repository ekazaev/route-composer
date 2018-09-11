//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

//class ExampleAnalyticsPostAction: PostRoutingTask {
//
//    typealias ViewController = UIViewController
//
//    typealias Destination = ExampleDestination
//
//    func execute(on viewController: ViewController, for destination: Destination, routingStack: [UIViewController]) {
//        guard let lastViewController = routingStack.last,
//              viewController == lastViewController,
//              let source = destination.analyticParameters?.source else {
//            return
//        }
//
//        print("Source: \(source)")
//        if let analyticViewController = viewController as? ExampleAnalyticsSupport {
//            print("Target: \(analyticViewController.analyticParameters.source)")
//        }
//        print("-----")
//    }
//
//}
