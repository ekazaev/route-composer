//
// RouteComposer
// SecondModalLevelViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

class SecondModalLevelViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.secondLevelModal

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Second modal level"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }

    @IBAction func goToColorTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.colorScreen, with: "FF0000")
    }

    @IBAction func goToHomeTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.homeScreen, with: nil)
    }

    @IBAction func goToBerlinTapped() {
//        try? router.navigate(to: CitiesConfiguration.cityDetail(cityId: 15), animated: false)
    }

    @objc func doneTapped() {
        dismiss(animated: true)
    }

}
