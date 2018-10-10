//
// Created by Eugene Kazaev on 10/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class EmptyViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.empty

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func goToSquareTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
    }

    @IBAction func goToSelfTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.emptyScreen, with: nil)
    }

}
