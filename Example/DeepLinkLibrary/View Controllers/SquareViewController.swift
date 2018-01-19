//
//  SquareViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

class SquareViewController: UIViewController , AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .square)


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.circle)!)
    }

    @IBAction func goToHomeTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.empty)!)
    }

    @IBAction func goToSplitTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.citiesList())
    }

    @IBAction func goToLoginTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.login)!)
    }

}

