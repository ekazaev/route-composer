//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public protocol SplitViewControllerMasterAction: ViewControllerAction {

}

public protocol SplitViewControllerDetailAction: ViewControllerAction {

}

// TODO: Undone
public class SplitControllerFactory: ContainerFactory {

    public let action: ViewControllerAction?

    var detailFactories: [Factory] = []
    var masterFactories: [Factory] = []

    public init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    public func merge(_ factories: [Factory]) -> [Factory] {
        var rest: [Factory] = []
        factories.forEach { factory in
            if let _ = factory.action as? SplitViewControllerMasterAction {
                masterFactories.append(factory)
            }
            if let _ = factory.action as? SplitViewControllerDetailAction {
                detailFactories.append(factory)
            }
            rest.append(factory)
        }

        return rest
    }

    public func build(with logger: Logger?) -> UIViewController? {
        guard masterFactories.count > 0, detailFactories.count > 0 else {
            return nil
        }

        let splitController = UISplitViewController(nibName: nil, bundle: nil)

        var masterViewControllers = Array<UIViewController>()
        self.masterFactories.forEach { factory in
            guard let viewController = factory.build(with: logger) else {
                return
            }
            factory.action?.applyMerged(viewController: viewController, containerViewControllers: &masterViewControllers, logger: logger)
        }

        guard masterViewControllers.count > 0 else {
            logger?.log(.error("Master View Controller is mandatory to build UISplitViewController"))
            return nil
        }
        let masterViewController = masterViewControllers.removeFirst()


        var detailsViewControllers = Array<UIViewController>()
        detailsViewControllers.append(contentsOf: masterViewControllers)
        self.detailFactories.forEach { factory in
            guard let viewController = factory.build(with: logger) else {
                return
            }
            factory.action?.applyMerged(viewController: viewController, containerViewControllers: &detailsViewControllers, logger: logger)
        }

        guard detailsViewControllers.count > 0 else {
            logger?.log(.error("At least 1 Details View Controller is mandatory to build UISplitViewController"))
            return nil
        }

        var controllers = [masterViewController]
        controllers.append(contentsOf: detailsViewControllers)
        splitController.viewControllers = controllers
        return splitController
    }
}
