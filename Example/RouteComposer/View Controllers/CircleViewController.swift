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
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToRandomColorTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.color, context: ExampleDictionaryContext(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToDeepModalTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.ruleSupport, context: ExampleDictionaryContext(arguments: [Argument.color: "00FF00"]))!)
    }

    @IBAction func goToSuperModalTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.secondLevelModal, context: ExampleDictionaryContext(arguments: [Argument.color: "0000FF"]))!)
    }

    @IBAction func goToProductTapped() {
        router.navigate(to: ProductConfiguration.productDestination(productId: "00"))
    }

    @IBAction func goToWelcomeTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.welcome)!)
    }

    @IBAction func goToImagesTapped() {
        router.navigate(to: ImagesConfigurationWithLibrary.images())
    }

    @IBAction func goToImagesNoLibraryTapped() {
        ImagesWithoutLibraryConfiguration.shared.showCustomController()
    }

}

