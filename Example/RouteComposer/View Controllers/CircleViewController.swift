//
//  CircleViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 HBC Tech. All rights reserved.
//

import UIKit
import RouteComposer

class CircleViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .circle)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToSquareTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToRandomColorTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.color, context: ExampleDictionaryContext(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToDeepModalTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.ruleSupport, context: ExampleDictionaryContext(arguments: [Argument.color: "00FF00"]))!)
    }

    @IBAction func goToSuperModalTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.secondLevelModal, context: ExampleDictionaryContext(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToProductTapped() {
        router.deepLinkTo(destination: ProductConfiguration.productDestination(productId: "00"))
    }

    @IBAction func goToWelcomeTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.welcome)!)
    }

    @IBAction func goToImagesTapped() {
        router.deepLinkTo(destination: ImagesConfigurationWithLibrary.images())
    }

    @IBAction func goToImagesNoLibraryTapped() {
        ImagesWithoutLibraryConfiguration.shared.showCustomController()
    }

}

