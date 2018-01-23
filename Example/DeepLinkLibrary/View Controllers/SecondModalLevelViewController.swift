//
// Created by Eugene Kazaev on 22/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class SecondModalLevelViewController: UIViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .secondLevelModal)

    @IBAction func goToColorTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.color, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "FF0000"]))!)
    }

    @IBAction func goToHomeTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.home)!)
    }

    @IBAction func goToMinskTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.cityDetail(cityId: 18), animated: false)
    }
}
