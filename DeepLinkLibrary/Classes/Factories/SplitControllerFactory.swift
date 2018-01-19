//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

// TODO: Undone
public class SplitControllerFactory: ContainerFactory {

    public let action: ViewControllerAction?

    var detailFactories: [Factory] = []
    var masterFactories: [Factory] = []

    public init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    public func merge(_ screenFactories: [Factory]) -> [Factory] {
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

    public func build() -> UIViewController? {
        guard masterFactories.count > 0, detailFactories.count > 0 else {
            return nil
        }

        let splitController = UISplitViewController(nibName: nil, bundle: nil)

        var masterViewControllers = Array<UIViewController>()
        self.masterFactories.forEach { factory in
            guard let viewController = factory.build() else {
                return
            }
            factory.action?.applyMerged(viewController: viewController, containerViewControllers: &masterViewControllers)
        }

        guard masterViewControllers.count > 0 else {
            return nil
        }
        let masterViewController = masterViewControllers.removeFirst()


        var detailsViewControllers = Array<UIViewController>()
        detailsViewControllers.append(contentsOf: masterViewControllers)
        self.detailFactories.forEach { factory in
            guard let viewController = factory.build() else {
                return
            }
            factory.action?.applyMerged(viewController: viewController, containerViewControllers: &detailsViewControllers)
        }

        guard detailsViewControllers.count > 0 else {
            return nil
        }

        var controllers = [masterViewController]
        controllers.append(contentsOf: detailsViewControllers)
        splitController.viewControllers = controllers
        return splitController
    }
}