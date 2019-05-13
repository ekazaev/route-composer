//
// Created by Eugene Kazaev on 2019-04-23.
//

import Foundation
import UIKit

/// Shared storage of types of the `ContainerAdapter` for the `ContainerAdapterRegistry`
public struct DefaultContainerAdapterProvider: ContainerAdapterProvider {

    /// Constructor
    public init() {
    }

    /// Returns the `ContainerAdapter` suitable for the `ContainerViewController`.
    ///
    /// For the container view controllers that extend `CustomContainerViewController` it returns the an instance provided
    /// in `CustomContainerViewController.adapter` property.
    /// For the default `ContainerViewController`s like `UINavigationController`, `TabBarControllerAdapter`, `UISplitViewController`
    /// and their subclasses it returns suitable default implementation of the `ContainerAdapter`.
    ///
    /// - Parameter containerViewController: The `ContainerViewController` instance
    /// - Returns: Suitable `ContainerAdapter` instance
    /// - Throws: `RoutingError` if the suitable `ContainerAdapter` can not be provided
    public func getAdapter(for containerViewController: ContainerViewController) throws -> ContainerAdapter {
        guard let customContainerController = containerViewController as? CustomContainerViewController else {
            return try getDefaultAdapter(for: containerViewController)
        }
        return customContainerController.adapter
    }

    func getDefaultAdapter(for containerViewController: ContainerViewController) throws -> ContainerAdapter {
        switch containerViewController {
        case let navigationController as UINavigationController:
            return NavigationControllerAdapter(with: navigationController)
        case let tabBarController as UITabBarController:
            return TabBarControllerAdapter(with: tabBarController)
        case let splitController as UISplitViewController:
            return SplitControllerAdapter(with: splitController)
        default:
            let message = "Container adapter for \(String(describing: type(of: containerViewController))) not found"
            assertionFailure(message)
            throw RoutingError.compositionFailed(.init(message))
        }
    }

}
