//
// RouteComposer
// ExampleNavigationController.swift
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

// Its only purpose is to demo that you can reuse built-in actions with your custom classes
class ExampleNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // It is better to use the appearance protocol for such modifications
        navigationBar.barTintColor = UIColor.lightGray
    }

}
