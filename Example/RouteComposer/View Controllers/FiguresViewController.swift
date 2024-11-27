//
// RouteComposer
// FiguresViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

class FiguresViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.empty

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Figures"
    }

    @IBAction func goToCircleTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func goToSquareTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
    }

    @IBAction func goToSelfTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.figuresScreen, with: nil)
    }

}
