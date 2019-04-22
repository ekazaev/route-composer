//
// Created by Eugene Kazaev on 2019-04-22.
//

import Foundation

public struct TabBarControllerAdapter<VC: UITabBarController>: ConcreteContainerAdapter {

    let tabBarController: VC

    public init(with navigationController: VC) {
        self.tabBarController = navigationController
    }

    public var containedViewControllers: [UIViewController] {
        guard let viewControllers = tabBarController.viewControllers else {
            return []
        }
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        guard let selectedViewController = tabBarController.selectedViewController else {
            return []
        }
        return [selectedViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) throws {
        guard tabBarController.selectedViewController != viewController else {
            return
        }
        guard let viewControllerToSelect = containedViewControllers.first(where: { $0 == viewController }) else {
            throw RoutingError.compositionFailed(.init("\(tabBarController) does not contain \(viewController)"))
        }

        tabBarController.selectedViewController = viewControllerToSelect
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) {
        tabBarController.setViewControllers(containedViewControllers, animated: animated)
        completion()
    }

}
