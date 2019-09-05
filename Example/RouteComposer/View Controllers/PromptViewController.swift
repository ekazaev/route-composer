//
// Created by Eugene Kazaev on 15/01/2018.
//

import Foundation
import UIKit
import RouteComposer

class PromptViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.welcome

    @IBAction func goToHomeTapped() {
        try? router.navigate(to: CitiesConfiguration.citiesTab, with: nil)
    }

}
