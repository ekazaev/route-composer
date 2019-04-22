//
// Created by Eugene Kazaev on 2019-04-22.
//

import Foundation

/// Provides universal properties and methods of the `ContainerViewController` instance.
///
/// `ContainerViewController`s are different from the simple ones in that they can contain child view controllers which
/// are also containers or simple ones. These view controllers are available out of the box: `UINavigationController`,
/// `UITabBarController` and so on, but there can be custom ones created as well.
///
/// All of them has the following properties:
///  1. They have a list of all controllers that they contain.
///  2. One or more controllers are currently visible.
///  3. They can make one of these controllers visible.
///  4. They can replace all of their contained view controllers.
public protocol ContainerAdapter {

    /// A `UIViewController` instances that `ContainerViewController` currently has in the stack
    var containedViewControllers: [UIViewController] { get }

    /// A `UIViewController` instances out of the `containedViewControllers` that are currently visible on the screen
    /// The `visibleViewControllers` are the subset of the `containedViewControllers`.
    var visibleViewControllers: [UIViewController] { get }

    /// Each container view controller should implement this method for the `Router` to know how to make
    /// its particular child view controller visible.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` to make active (visible).
    ///   - animated: If `ContainerViewController` is able to do so - make container active animated or not.
    /// - Throws: The `RoutingError` if the view controller can not be made visible.
    func makeVisible(_ viewController: UIViewController, animated: Bool) throws

    /// Each container view controller should this method for the `Router` to know how to replace all the
    /// view controllers in this particular container.
    ///
    /// - Parameters:
    ///   - containedViewControllers: A `UIViewController` instances to replace.
    ///   - animated: If `ContainerViewController` is able to do so - replace contained view controllers animated or not.
    /// - Throws: The `RoutingError` if the view controller can not be set with the `containedViewControllers` provided.
    func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) throws

}
