//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Represents action that has to be applied to a view controller after it has been built (eg: push to navigation stack,
/// present modally, push as tab e.t.c)
public protocol ViewControllerAction {

    // If view controller that action should apply to has been merged in Container View Controller,
    // it will call this action instead so ViewControllerAction can apply it behavior to an array of childern
    /// view controllers of a container without changing view controller stack.
    func applyMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?)

    // Applies implemented action to the view controller.
    // Calls completion with view controller to apply action if it was successfully build in view controller stack, wit exiction otherwise.
    // NB: completion block is mandatory to be called in implementation.
    func apply(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (_: UIViewController) -> Void)

}
