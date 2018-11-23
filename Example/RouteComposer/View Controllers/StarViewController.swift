//
// Created by Eugene Kazaev on 07/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class StarViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.star

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Star"
        self.tabBarItem.image = UIImage(named: "star")
        self.view.accessibilityIdentifier = "starViewController"
    }

    @IBAction func goToProductTapped() {
        try? router.navigate(to: ProductConfiguration.productScreen, with: ProductContext(productId: "02"))
    }

    @IBAction func goToCircleTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func dismissStarTapped() {
        var viewControllers = self.tabBarController?.viewControllers
        if let index = viewControllers?.index(where: { $0 === self }) {
            viewControllers?.remove(at: index)
            self.tabBarController?.setViewControllers(viewControllers, animated: true)
        }
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

}
