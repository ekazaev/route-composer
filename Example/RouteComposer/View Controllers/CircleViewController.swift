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
        router.navigate(to: ExampleConfiguration.wireframe.goToSquare())
    }

    @IBAction func goToRandomColorTapped() {
        router.navigate(to: ExampleConfiguration.wireframe.goToColor("0000FF"))
    }

    @IBAction func goToDeepModalTapped() {
        router.navigate(to: ExampleConfiguration.wireframe.goToRoutingSupport("00FF00"))
    }

    @IBAction func goToSuperModalTapped() {
        router.navigate(to: ExampleConfiguration.wireframe.goToSecondLevelModal("0000FF"))
    }

    @IBAction func goToProductTapped() {
        router.navigate(to: ProductConfiguration.productStep(), with: ProductContext(productId: "00"))
    }

    @IBAction func goToWelcomeTapped() {
        router.navigate(to: ExampleConfiguration.wireframe.goToWelcome())
    }

    @IBAction func goToImagesTapped() {
        router.navigate(to: ImagesConfigurationWithLibrary.images())
    }

    @IBAction func goToImagesNoLibraryTapped() {
        ImagesWithoutLibraryConfiguration.shared.showCustomController()
    }

}
