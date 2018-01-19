//
// Created by Eugene Kazaev on 13/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class RoutingRuleSupportViewController: UIViewController, RouterRulesViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .ruleSupport)

    private(set) var canBeDismissed: Bool = true

    @IBOutlet private var switchControl: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchControl.isOn = self.canBeDismissed
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }


    @IBAction func switchValueChanged(sender: UISwitch) {
        self.canBeDismissed = switchControl.isOn
    }

    @objc func doneTapped() {
        self.dismiss(animated: true)
    }

    @IBAction func goToColorTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.color, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "FFFF00"], ExampleAnalyticsParameters(source: .ruleSupport)))!)
    }

    @IBAction func goToSquareTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.square)!)
    }

    @IBAction func goToMoscowTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.cityDetail(cityId: 2))
    }
}
