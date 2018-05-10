//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class PromptViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .welcome)

    @IBAction func goToHomeTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.home)!)
    }

}
