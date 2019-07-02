//
// Created by Eugene Kazaev on 2019-04-22.
//

import Foundation

/// Default `ContainerAdapter` for `UITabBarController`
public struct TabBarControllerAdapter<VC: UITabBarController>: ConcreteContainerAdapter {

    weak var tabBarController: VC?

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
        guard let tabBarController = tabBarController else {
            return completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
        }
        guard tabBarController.selectedViewController != viewController else {
            completion(.success)
            return
        }
        guard let viewControllerToSelect = containedViewControllers.first(where: { $0 == viewController }) else {
            completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: tabBarController)) does not contain \(String(describing: viewController))"))))
            return
        }

        tabBarController.selectedViewController = viewControllerToSelect
        completion(.success)
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let tabBarController = tabBarController else {
            return completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
        }
        tabBarController.setViewControllers(containedViewControllers, animated: animated)
        completion(.success)
    }

}
