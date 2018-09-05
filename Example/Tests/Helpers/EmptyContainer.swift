//
// Created by Eugene Kazaev on 25/07/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
@testable import RouteComposer

struct EmptyContainer: SimpleContainer {

    typealias SupportedAction = NavigationControllerAction

    init() {
    }

    func build(with context: Any?, integrating viewControllers: [UIViewController]) throws -> UIViewController {
        let viewController = UIViewController()
        viewControllers.forEach({
            viewController.addChildViewController($0)
        })
        return viewController
    }
}
