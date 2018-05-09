//
// Created by Eugene Kazaev on 10/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
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
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToSquareTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToSelfTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.empty)!)
    }

}
