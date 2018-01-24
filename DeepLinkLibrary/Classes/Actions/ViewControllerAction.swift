//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Represents action that has to be applied to a view controller after it has been built (eg: push to navigation stack,
/// present modally, push to tab, etc)
public protocol ViewControllerAction {
    
    /// If current view controller needs to be pushed/added/etc to the exciting collection of view controllers,
    /// this method should be called instead.
    ///
    /// paramaters:
    /// containerViewControllers: view controllers stack in the current context container
    /// viewController: view controller to be added to the stack of views that are in the container already
    /// logger: logger
    func applyMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?)

    /// Applies provided action to the view controller.
    /// parameters:
    /// viewController: operated view controller. the one which should appear on top of the stack after the action is applied.
    /// existingController: presenting view controller.
    /// animated: animated
    /// logger: logger
    /// completion: called once the action is applied. returns the view controller, which will appear on the top of the stack.
    /// In success scenario it will be viewController, existingController otherwise, if the action failed to add viewController to the stack.
    /// NB: completion MUST to be called in implementation.
    func apply(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (_: UIViewController) -> Void)

}
