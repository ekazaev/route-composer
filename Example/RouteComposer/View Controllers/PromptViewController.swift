//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class PromptViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.welcome

    @IBAction func goToHomeTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.homeScreen, with: nil)
    }

}
