//
// Created by Eugene Kazaev on 07/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class StarViewController: UIViewController, AnalyticsSupportViewController {

    let analyticParameters = ExampleAnalyticsParameters(source: .star)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Star"
        self.tabBarItem.image = UIImage(named: "star")
        self.view.accessibilityIdentifier = "starViewController"
    }

    @IBAction func goToProductTapped() {
        router.deepLinkTo(destination: ProductConfiguration.productDestination(productId: "02"))
    }

    @IBAction func goToCircleTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func dismissStarTapped() {
        var viewControllers = self.tabBarController?.viewControllers
        if let index = viewControllers?.index(where: { $0 === self }) {
            viewControllers?.remove(at: index)
            self.tabBarController?.setViewControllers(viewControllers, animated: true)
        }
    }
}
