//
//  ContainerViewController.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// All the container view controllers should extend this protocol. The `Router` will ask them to make
/// one of the view controllers that they contain visible
@objc public protocol ContainerViewController: RoutingInterceptable {

    /// A `UIViewController` instances that `ContainerViewController` currently has in the stack
    var containedViewControllers: [UIViewController] { get }

    /// A `UIViewController` instances out of the `containedViewControllers` that are currently visible on the screen
    var visibleViewControllers: [UIViewController] { get }

    /// Each container view controller should implement this method for the `Router` to know how to make
    /// its particular child view controller visible.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` to make active (visible).
    ///   - animated: If `ContainerViewController` is able to do so - make container active animated or not.
    func makeVisible(_ viewController: UIViewController, animated: Bool)

    /// Each container view controller should this method for the `Router` to know how to replace all the
    /// view controllers in this particular container.
    ///
    /// - Parameters:
    ///   - containedViewControllers: A `UIViewController` instances to replace.
    ///   - animated: If `ContainerViewController` is able to do so - replace contained view controllers animated or not.
    func replace(containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void)

}
