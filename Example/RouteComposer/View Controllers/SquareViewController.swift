//
// RouteComposer
// SquareViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import RouteComposer
import UIKit

class SquareViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.square

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Square"
    }

    @IBAction func goToCircleTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func goToHomeTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.figuresScreen, with: nil)
    }

    @IBAction func goToSplitTapped() {
        try? router.navigate(to: CitiesConfiguration.citiesList())
    }

    @IBAction func goToLoginTapped() {
        try? router.navigate(to: LoginConfiguration.login())
    }

    @IBAction func goToStarTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.starScreen, with: "Test Context")
    }

    @IBAction func goToFakeContainerTapped() {
        try? router.navigate(to: WishListConfiguration.collections())
    }

    @IBAction func goEmptyAndProductTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.figuresAndProductScreen, with: ProductContext(productId: "03"))
    }

    @IBAction func switchValueChanged(sender: UISwitch) {
        if sender.isOn {
            ConfigurationHolder.configuration = AlternativeExampleConfiguration()
        } else {
            ConfigurationHolder.configuration = ExampleConfiguration()
        }
    }

}
