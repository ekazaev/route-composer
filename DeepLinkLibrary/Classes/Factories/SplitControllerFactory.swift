//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public protocol SplitViewControllerMasterAction: Action {

}

public protocol SplitViewControllerDetailAction: Action {

}

/// Container Factory that creates UISplitViewController
public class SplitControllerFactory: Factory, Container {

    public typealias ViewController = UISplitViewController

    public typealias Context = Any

    public let action: Action

    var detailFactories: [AnyFactory] = []

    var masterFactories: [AnyFactory] = []

    public init(action: Action) {
        self.action = action
    }

    public func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        var rest: [AnyFactory] = []
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

    public func build(with context: Context?) throws -> ViewController {
        guard masterFactories.count > 0, detailFactories.count > 0 else {
            throw RoutingError.message("No master or derails view controllers provided")
        }

        let masterViewControllers = try buildChildrenViewControllers(from: masterFactories, with: context)
        let detailsViewControllers = try buildChildrenViewControllers(from: detailFactories, with: context)
        guard masterViewControllers.count > 0 else {
            throw RoutingError.message("No master or derails view controllers provided")
        }
        guard detailsViewControllers.count > 0 else {
            throw RoutingError.message("At least 1 Details View Controller is mandatory to build UISplitViewController")
        }

        let splitController = UISplitViewController(nibName: nil, bundle: nil)
        var childrenViewControllers = masterViewControllers
        childrenViewControllers.append(contentsOf: detailsViewControllers)
        splitController.viewControllers = childrenViewControllers
        return splitController
    }
}
