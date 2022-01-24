//
// RouteComposer
// RoutingRuleSupportViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

//

import Foundation
import RouteComposer
import UIKit

class RoutingRuleSupportViewController: UIViewController, RoutingInterceptable, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.ruleSupport

    private(set) var canBeDismissed: Bool = true

    @IBOutlet private var switchControl: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        switchControl.isOn = canBeDismissed
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }

    @IBAction func switchValueChanged(sender: UISwitch) {
        canBeDismissed = switchControl.isOn
    }

    @objc func doneTapped() {
        dismiss(animated: true)
    }

    @IBAction func goToColorTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.colorScreen, with: "FFFF00")
    }

    @IBAction func goToSquareTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
    }

    @IBAction func goToMoscowTapped() {
        try? router.navigate(to: CitiesConfiguration.cityDetail(cityId: 2))
    }

    @IBAction func goToNewYorkUnexpectedTapped() {
        // This is for the example purposes only. You should avoid a code like this.
        try? router.navigate(to: ConfigurationHolder.configuration.secondModalScreen, with: "0000FF")
        try? router.navigate(to: CitiesConfiguration.cityDetail(cityId: 3))
    }

}
