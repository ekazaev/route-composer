//
// RouteComposer
// AbstractAction.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// Represents any action that has to be applied to the `UIViewController` after it has
/// been built (eg: push to navigation stack, present modally, push to tab, etc)
public protocol AbstractAction {

    // MARK: Associated types

    /// Type of the `UIViewController` that `Action` can start from.
    associatedtype ViewController: UIViewController

    // MARK: Methods to implement

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
                 completion: @escaping (_: RoutingResult) -> Void)

}
