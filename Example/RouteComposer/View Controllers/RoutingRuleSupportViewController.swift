//
// Created by Eugene Kazaev on 13/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class RoutingRuleSupportViewController: UIViewController, RoutingInterceptable, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .ruleSupport)

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
        let context = ExampleDictionaryContext(arguments: [Argument.color: "FFFF00"])
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.color, context: context)!)
    }

    @IBAction func goToSquareTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToMoscowTapped() {
        router.navigate(to: CitiesConfiguration.cityDetail(cityId: 2))
    }
}
