//
// RouteComposer
// RoutingInterceptable.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// `UIViewController` that conforms to this protocol may overtake the control of the view controllers stack and
/// forbid the `Router` to dismiss or cover itself with another view controller.
/// Return false if the view controller can be dismissed.
public protocol RoutingInterceptable where Self: UIViewController {

    // MARK: Properties to implement

    /// true: if a view controller can be dismissed or covered by the `Router`, false otherwise.
    var canBeDismissed: Bool { get }

    /// Returns `UIViewController` that `Router` should consider as a parent `UIViewController`.
    /// It may be useful to override it when you are building complicated custom `ContainerViewController`s.
    var overriddenParentViewController: UIViewController? { get }

}

// MARK: Helper methods

public extension RoutingInterceptable {

    /// Default implementation returns regular `UIViewController.parent`
    var overriddenParentViewController: UIViewController? {
        return parent
    }

}
