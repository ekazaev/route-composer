//
// Created by Eugene Kazaev on 2019-04-22.
//

import Foundation
import UIKit

/// Default `ContainerAdapter` for `UINavigationController`
public struct NavigationControllerAdapter<VC: UINavigationController>: ConcreteContainerAdapter {

    weak var navigationController: VC?

    public init(with navigationController: VC) {
        self.navigationController = navigationController
    }

    public var containedViewControllers: [UIViewController] {
        return navigationController?.viewControllers ?? []
    }

    public var visibleViewControllers: [UIViewController] {
        guard let topViewController = navigationController?.topViewController else {
            return []
        }
        return [topViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let navigationController = navigationController else {
            return completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
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
        completion(.success)
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let navigationController = navigationController else {
            return completion(.failure(RoutingError.compositionFailed(.init("\(String(describing: VC.self)) has been deallocated"))))
        }
        navigationController.setViewControllers(containedViewControllers, animated: animated)
        completion(.success)
    }

}
