//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Represents an action that has to be applied to the `UIViewController` after it has been built (eg: push to navigation stack,
/// present modally, push to tab, etc)
public protocol Action {

    /// If current `UIViewController` has to be pushed/added/etc to the exciting stack of the view controllers,
    /// this method should be called instead.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` to be embedded.
    ///   - containerViewControllers: The stack of the `UIViewController`s in the current container.
    func perform(embedding viewController: UIViewController, in containerViewControllers: inout [UIViewController])

    /// Performs provided action to the view controller.
    ///
    /// - Parameters:
    ///   - viewController: `UIViewController` instance that should appear on top of the stack after the `Action` is applied.
    ///   - existingController: `UIViewController` instance to start from.
    ///   - animated: animated
    ///   - completion: called once the action is applied. Returns the view controller, which will appear on the top of the stack.
    ///
    /// NB: completion MUST be called in the implementation.
    func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void)

}

public extension Action {

    public func perform(embedding viewController: UIViewController, in containerViewControllers: inout [UIViewController]) {
        containerViewControllers.append(viewController)
    }

}
