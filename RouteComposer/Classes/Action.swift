//
// RouteComposer
// Action.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// Represents an action that has to be applied to the `UIViewController` after it has
/// been built (eg: push to navigation stack, present modally, push to tab, etc)
public protocol Action: AbstractAction {}

/// Represents an action to be used by a `ContainerFactory` to build it's children view controller stack
public protocol ContainerAction: AbstractAction where ViewController: ContainerViewController {

    // MARK: Methods to implement

    /// If current `UIViewController` has to be pushed/added/etc to the existing stack of the view controllers,
    /// this method should be called instead.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` to be embedded.
    ///   - childViewControllers: The stack of the `UIViewController`s in the current container.
    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws

}

// MARK: Default implementation

public extension ContainerAction {

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        childViewControllers.append(viewController)
    }

}
