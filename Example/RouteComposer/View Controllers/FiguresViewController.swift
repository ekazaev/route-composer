//
// Created by Eugene Kazaev on 10/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class FiguresViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.empty

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Figures"
    }

    @IBAction func goToCircleTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func goToSquareTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
    }

    @IBAction func goToSelfTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.figuresScreen, with: nil)
    }

}
