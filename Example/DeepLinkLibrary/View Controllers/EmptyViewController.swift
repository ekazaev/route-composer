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
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.circle)!)
    }

    @IBAction func goToSquareTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.square)!)
    }

    @IBAction func goToSelfTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.empty)!)
    }

}
