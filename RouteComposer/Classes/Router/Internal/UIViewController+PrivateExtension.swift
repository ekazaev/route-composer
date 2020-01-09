//
// Created by Eugene Kazaev on 2019-08-07.
//

#if os(iOS)

import Foundation
import UIKit

extension UIViewController {

    var allPresentedViewControllers: [UIViewController] {
        var allPresentedViewControllers: [UIViewController] = []
        var presentingViewController = self

        while let presentedViewController = presentingViewController.presentedViewController, !presentedViewController.isBeingDismissed {
            allPresentedViewControllers.append(presentedViewController)
            presentingViewController = presentedViewController
        }

        return allPresentedViewControllers
    }

    var allParents: [UIViewController] {
        var allParents: [UIViewController] = []
        var currentViewController: UIViewController? = self.parent
        while let currentParent = currentViewController {
            allParents.append(currentParent)
            currentViewController = currentParent.parent
        }
        return allParents
    }

    static func findContainer<Container: ContainerViewController>(of viewController: UIViewController) -> Container? {
        return [[viewController], viewController.allParents].joined().first(where: { $0 is Container }) as? Container
    }

}

#endif
