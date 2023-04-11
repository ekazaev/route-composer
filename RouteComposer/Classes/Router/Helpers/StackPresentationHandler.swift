//
// RouteComposer
// StackPresentationHandler.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// Helper instance used to update the stack of `UIViewController`s
public protocol StackPresentationHandler {

    // MARK: Methods to implement

    /// Dismisses all the `UIViewController`s presented on top of the provided `UIViewController`.
    /// - Parameters:
    ///   - viewController: `UIViewController` to dismiss presented `UIViewController`s from.
    ///   - animated: Update stack with animation where possible.
    ///   - completion: Completion block
    func dismissPresented(from viewController: UIViewController,
                          animated: Bool,
                          completion: @escaping ((_: RoutingResult) -> Void))

    /// Makes the provided `UIViewController` visible in all the enclosing containers.
    /// - Parameters:
    ///   - viewController: `UIViewController` to make visible.
    ///   - animated: Update stack with animation where possible.
    ///   - completion: Completion block
    func makeVisibleInParentContainers(_ viewController: UIViewController,
                                       animated: Bool,
                                       completion: @escaping (RoutingResult) -> Void)

}
