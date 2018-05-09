//
//  SquareViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

import UIKit
import RouteComposer

class SquareViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .square)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToHomeTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.empty)!)
    }

    @IBAction func goToSplitTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.citiesList())
    }

    @IBAction func goToLoginTapped() {
        router.deepLinkTo(destination: LoginConfiguration.login())
    }

    @IBAction func goToStarTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.star)!)
    }

    @IBAction func goToFakeContainerTapped() {
        router.deepLinkTo(destination: WishListConfiguration.collections())
    }

}

