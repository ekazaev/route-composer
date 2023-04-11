//
// RouteComposer
// UIViewController+PrivateExtension.swift
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
        var currentViewController: UIViewController? = parentViewController
        while let currentParent = currentViewController {
            allParents.append(currentParent)
            currentViewController = currentParent.parentViewController
        }
        return allParents
    }

    static func findContainer<Container: ContainerViewController>(of viewController: UIViewController) -> Container? {
        [[viewController], viewController.allParents].joined().first(where: { $0 is Container }) as? Container
    }

    var parentViewController: UIViewController? {
        guard let interceptableViewController = self as? RoutingInterceptable else {
            return parent
        }
        return interceptableViewController.overriddenParentViewController
    }

}
