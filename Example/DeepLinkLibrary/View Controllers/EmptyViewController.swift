//
// Created by Eugene Kazaev on 10/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class EmptyViewController: UIViewController, AnalyticsSupportViewController {

    let analyticParameters = ExampleAnalyticsParameters(source: .empty)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.circle)!)
    }

    @IBAction func goToSquareTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.square)!)
    }

    @IBAction func goToSelfTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.empty)!)
    }

}
