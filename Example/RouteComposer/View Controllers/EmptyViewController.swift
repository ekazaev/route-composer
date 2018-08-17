//
// Created by Eugene Kazaev on 10/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class EmptyViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .empty)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToSquareTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToSelfTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.empty)!)
    }

}
