//
// RouteComposer
// NavigationControllerAdapter.swift
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

/// Default `ContainerAdapter` for `UINavigationController`
public struct NavigationControllerAdapter<VC: UINavigationController>: ConcreteContainerAdapter {

    // MARK: Properties

    weak var navigationController: VC?

    // MARK: Methods

    public init(with navigationController: VC) {
        self.navigationController = navigationController
    }

    public var containedViewControllers: [UIViewController] {
        navigationController?.viewControllers ?? []
    }

    public var visibleViewControllers: [UIViewController] {
        guard let topViewController = navigationController?.topViewController else {
            return []
        }
        return [topViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let navigationController else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
            return
        }
        guard navigationController.topViewController != viewController else {
            completion(.success)
            return
        }
        guard contains(viewController) else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: navigationController)) does not contain \(String(describing: viewController))"))))
            return
        }
        navigationController.popToViewController(viewController, animated: animated)
        if let transitionCoordinator = navigationController.transitionCoordinator, animated {
            transitionCoordinator.animate(alongsideTransition: nil) { _ in
                if navigationController.isViewLoaded {
                    navigationController.view.layoutIfNeeded()
                }
                completion(.success)
            }
        } else {
            if navigationController.isViewLoaded {
                navigationController.view.layoutIfNeeded()
            }
            completion(.success)
        }
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let navigationController else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
            return
        }
        navigationController.setViewControllers(containedViewControllers, animated: animated)
        if let transitionCoordinator = navigationController.transitionCoordinator, animated {
            transitionCoordinator.animate(alongsideTransition: nil) { _ in
                completion(.success)
            }
        } else {
            completion(.success)
        }
    }

}
