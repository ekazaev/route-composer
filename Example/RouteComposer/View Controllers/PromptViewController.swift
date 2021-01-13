//
// RouteComposer
// PromptViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
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
