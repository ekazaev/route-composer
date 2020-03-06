//
// RouteComposer
// UIViewController+PrivateExtension.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
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
        var currentViewController: UIViewController? = parent
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
