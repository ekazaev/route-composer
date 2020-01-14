//
// Created by Eugene Kazaev on 15/01/2018.
//

import Foundation
import RouteComposer
import UIKit

class PromptViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.welcome

    @IBAction func goToHomeTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.homeScreen, with: nil)
    }

}
