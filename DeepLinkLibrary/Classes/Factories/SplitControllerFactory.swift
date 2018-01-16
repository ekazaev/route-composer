//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

// TODO: Undone
class SplitControllerFactory: ContainerFactory {

    let action: Action

    var detailFactories: [Factory] = []
    var masterFactories: [Factory] = []

    init(action: Action = NilAction()) {
        self.action = action
    }

    func merge(_ screenFactories: [Factory]) -> [Factory] {
        var rest: [Factory] = []
        screenFactories.forEach { factory in
            if let _ = factory.action as? PresentMasterAction {
                masterFactories.append(factory)
            }
            if let _ = factory.action as? PresentDetailsAction {
                detailFactories.append(factory)
            }
            rest.append(factory)
        }

        return rest
    }

    func build() -> UIViewController? {
        guard masterFactories.count > 0, detailFactories.count > 0 else {
            return nil
        }

        let splitController = UISplitViewController(nibName: nil, bundle: nil)

        let masterController = self.masterFactories.flatMap { factory -> UIViewController? in
            guard let viewController = factory.build() else {
                return nil
            }
            factory.action.applyMerged(viewController: viewController, in: splitController)
            return viewController
        }.first

        let detailsControllers = self.detailFactories.flatMap { factory -> UIViewController? in
            guard let viewController = factory.build() else {
                return nil
            }
            factory.action.applyMerged(viewController: viewController, in: splitController)
            return viewController
        }

        guard let master = masterController, detailsControllers.count > 0 else {
            return nil
        }

        var controllers = [master]
        controllers.append(contentsOf: detailsControllers)
        splitController.viewControllers = controllers
        return splitController
    }
}