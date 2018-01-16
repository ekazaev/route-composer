//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

class NavigationControllerFactory: ContainerFactory {

    let action: Action

    var screenFactories: [Factory] = []

    init(action: Action = NilAction()) {
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

        let viewControllers = self.screenFactories.flatMap { factory -> UIViewController? in
            guard let viewController = factory.build() else {
                return nil
            }
            factory.action.applyMerged(viewController: viewController, in: navigationController)
            return viewController
        }

        guard viewControllers.count > 0 else {
            return nil
        }

        navigationController.viewControllers = viewControllers
        return navigationController
    }
}