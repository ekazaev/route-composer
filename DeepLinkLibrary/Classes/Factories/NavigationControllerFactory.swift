//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

class NavigationControllerFactory: ContainerFactory {

    let action: ViewControllerAction?

    var screenFactories: [Factory] = []

    init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    func merge(_ screenFactories: [Factory]) -> [Factory] {
        var rest: [Factory] = []
        self.screenFactories = screenFactories.filter { factory in
            guard let _ = factory.action as? PushAction else {
                rest.append(factory)
                return false
            }
            return true
        }

        return rest
    }

    func build() -> UIViewController? {
        guard screenFactories.count > 0 else {
            return nil
        }

        let navigationController = UINavigationController()

        var viewControllers: [UIViewController] = []
        self.screenFactories.forEach { factory in
            guard let viewController = factory.build() else {
                return
            }
            factory.action?.applyMerged(viewController: viewController, containerViewControllers: &viewControllers)
        }

        guard viewControllers.count > 0 else {
            return nil
        }

        navigationController.viewControllers = viewControllers
        return navigationController
    }
}