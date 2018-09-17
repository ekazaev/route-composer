//
// Created by Eugene Kazaev on 10/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class EmptyViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreen.empty

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        router.navigate(to: ExampleConfiguration.wireframe.goToCircle())
    }

    @IBAction func goToSquareTapped() {
        router.navigate(to: ExampleConfiguration.wireframe.goToSquare())
    }

    @IBAction func goToSelfTapped() {
        router.navigate(to: ExampleConfiguration.wireframe.goToEmptyScreen())
    }

}
