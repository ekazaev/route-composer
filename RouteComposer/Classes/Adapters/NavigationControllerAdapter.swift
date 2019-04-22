//
// Created by Eugene Kazaev on 2019-04-22.
//

import Foundation
import UIKit

public struct NavigationControllerAdapter<VC: UINavigationController>: ConcreteContainerAdapter {

    let navigationController: VC

    public init(with navigationController: VC) {
        self.navigationController = navigationController
    }

    public var containedViewControllers: [UIViewController] {
        return navigationController.viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        guard let topViewController = navigationController.topViewController else {
            return []
        }
        return [topViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) throws {
        guard navigationController.topViewController != viewController else {
            return
        }
        guard let viewControllerToMakeVisible = containedViewControllers.first(where: { $0 == viewController }) else {
            throw RoutingError.compositionFailed(.init("\(navigationController) does not contain \(viewController)"))
        }
        navigationController.popToViewController(viewControllerToMakeVisible, animated: animated)
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) {
        navigationController.setViewControllers(containedViewControllers, animated: animated)
        completion()
    }

}
