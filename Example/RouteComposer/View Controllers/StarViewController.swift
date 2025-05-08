//
// RouteComposer
// StarViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

class StarViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.star

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Star"
        tabBarItem.image = UIImage(named: "star")
        view.accessibilityIdentifier = "starViewController"
    }

    @IBAction func goToProductTapped() {
        try? router.navigate(to: ProductConfiguration.productScreen, with: ProductContext(productId: "02"))
    }

    @IBAction func goToCircleTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func dismissStarTapped() {
        var viewControllers = tabBarController?.viewControllers
        if let index = viewControllers?.firstIndex(of: self) {
            viewControllers?.remove(at: index)
            tabBarController?.setViewControllers(viewControllers, animated: true)
        }
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

}
