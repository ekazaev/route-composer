//
//  SquareViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 HBC Tech. All rights reserved.
//

import UIKit
import RouteComposer

class SquareViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .square)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToHomeTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.empty)!)
    }

    @IBAction func goToSplitTapped() {
        router.navigate(to: CitiesConfiguration.citiesList())
    }

    @IBAction func goToLoginTapped() {
        router.navigate(to: LoginConfiguration.login())
    }

    @IBAction func goToStarTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.star)!)
    }

    @IBAction func goToFakeContainerTapped() {
        router.navigate(to: WishListConfiguration.collections())
    }

}

