//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ExampleAnalyticsPostAction: PostRoutingTask {

    func execute(on viewController: UIViewController, with arguments: Any?, routingStack: [UIViewController]) {
        guard let arguments = arguments as? ExampleArguments,
              let lastViewController = routingStack.last,
              viewController == lastViewController,
              let source = arguments.analyticParameters?.source else {
            return
        }

        print("Source: \(source)")
        if let avc = viewController as? AnalyticsSupportViewController {
            print("Target: \(avc.analyticParameters.source)")
        }
        print("-----")
    }

}