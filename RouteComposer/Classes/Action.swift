//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Represents an action that has to be applied to the `UIViewController` after it has
/// been built (eg: push to navigation stack, present modally, push to tab, etc)
public protocol Action {

    /// Type of the `UIViewController` that `Action` can start from.
    associatedtype ViewController: UIViewController

    /// Performs provided action to the view controller.
    ///
    /// - Parameters:
    ///   - viewController: `UIViewController` instance that should appear on top of the stack
    ///     after the `Action` is applied.
    ///   - existingController: `UIViewController` instance to start from.
    ///   - animated: animated
    ///   - completion: called once the action is applied. Returns the view controller, which
    ///     will appear on the top of the stack.
    ///
    /// NB: completion MUST be called in the implementation.
    func perform(with viewController: UIViewController,
                 on existingController: ViewController,
                 animated: Bool,
                 completion: @escaping (_: ActionResult) -> Void)

}

/// Represents an action to be used by a `Container` to build it's children view controller stack
public protocol ContainerAction: Action {

     /// Type of the `Container` supported by the `ContainerAction`
    associatedtype SupportedContainer: Container where SupportedContainer.ViewController == ViewController

    /// If current `UIViewController` has to be pushed/added/etc to the existing stack of the view controllers,
    /// this method should be called instead.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` to be embedded.
    ///   - childViewControllers: The stack of the `UIViewController`s in the current container.
    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController])

}

public extension ContainerAction {

    public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        childViewControllers.append(viewController)
    }

}

public extension Action where Self: NilEntity {

    /// Does nothing
    public func perform(with viewController: UIViewController,
                        on existingController: UIViewController,
                        animated: Bool,
                        completion: @escaping (ActionResult) -> Void) {
        completion(.continueRouting)
    }

}
