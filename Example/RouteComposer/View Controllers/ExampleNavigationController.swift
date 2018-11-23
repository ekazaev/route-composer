//
// Created by Eugene Kazaev on 2018-10-12.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

// Its only purpose is to demo that you can reuse built-in actions with your custom classes
class ExampleNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // It is better to use the appearance protocol for such modifications
        navigationBar.barTintColor = UIColor.lightGray
    }

}

struct ExampleNavigationFactory<C>: SimpleContainerFactory {

    func build(with context: C, integrating viewControllers: [UIViewController]) throws -> ExampleNavigationController {
        guard !viewControllers.isEmpty else {
            throw RoutingError.compositionFailed(RoutingError.Context("Unable to build UINavigationController due to 0 amount " +
                    "of the children view controllers"))
        }
        let navigationController = ExampleNavigationController()
        navigationController.viewControllers = viewControllers
        return navigationController
    }

}
