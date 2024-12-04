//
// RouteComposer
// TabBarControllerAdapter.swift
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

/// Default `ContainerAdapter` for `UITabBarController`
public struct TabBarControllerAdapter<VC: UITabBarController>: ConcreteContainerAdapter {

    // MARK: Properties

    weak var tabBarController: VC?

    // MARK: Methods

    public init(with navigationController: VC) {
        self.tabBarController = navigationController
    }

    public var containedViewControllers: [UIViewController] {
        guard let viewControllers = tabBarController?.viewControllers else {
            return []
        }
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        guard let selectedViewController = tabBarController?.selectedViewController else {
            return []
        }
        return [selectedViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let tabBarController else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
            return
        }
        guard tabBarController.selectedViewController != viewController else {
            completion(.success)
            return
        }
        guard contains(viewController) else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: tabBarController)) does not contain \(String(describing: viewController))"))))
            return
        }

        tabBarController.selectedViewController = viewController
        completion(.success)
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let tabBarController else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
            return
        }
        tabBarController.setViewControllers(containedViewControllers, animated: animated)
        completion(.success)
    }

}
