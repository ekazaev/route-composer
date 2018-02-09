//
// Created by Eugene Kazaev on 22/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class SecondModalLevelViewController: UIViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .secondLevelModal)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }

    @IBAction func goToColorTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.color, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "FF0000"]))!)
    }

    @IBAction func goToHomeTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.home)!)
    }

    @IBAction func goToMinskTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.cityDetail(cityId: 18), animated: false)
    }


    @objc func doneTapped() {
        self.dismiss(animated: true)
    }
}