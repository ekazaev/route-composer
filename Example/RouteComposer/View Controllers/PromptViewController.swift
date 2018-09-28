//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class PromptViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreen.welcome

    @IBAction func goToHomeTapped() {
        router.navigate(to: ConfigurationHolder.configuration.homeScreen, with: nil)
    }

}
