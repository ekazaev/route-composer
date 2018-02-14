//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ExampleAnalyticsPostAction: PostRoutingTask {
    typealias V = UIViewController
    typealias A = ExampleArguments

    func execute(on viewController: V, with arguments: A?, routingStack: [UIViewController]) {
        guard let lastViewController = routingStack.last,
              viewController == lastViewController,
              let source = arguments?.analyticParameters?.source else {
            return
        }

        print("Source: \(source)")
        if let avc = viewController as? AnalyticsSupportViewController {
            print("Target: \(avc.analyticParameters.source)")
        }
        print("-----")
    }

}
