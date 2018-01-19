//
//  CircleViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

class CircleViewController: UIViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .circle)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToSquareTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.square)!)
    }

    @IBAction func goToRandomColorTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.color, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToDeepModalTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.ruleSupport, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "00FF00"]))!)
    }

    @IBAction func goToSuperModalTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.superModal, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToProductTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.product, arguments: ExampleDictionaryArguments(arguments: [Argument.productId: "01"]))!)
    }

    @IBAction func goToWelcomeTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.welcome)!)
    }
}

