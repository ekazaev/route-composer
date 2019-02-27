//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

import UIKit

public extension UIViewController {

    /// Iterates through the view controller stack to finds a `UIViewController` instance.
    ///
    /// - Parameters:
    ///   - viewController: A `UIViewController` instance to start from.
    ///   - options: A combination of `SearchOptions`.
    ///   - predicate: A block that should return `true` if the `UIViewController` instance provided is the
    ///     one that is being searched for.
    /// - Returns: A `UIViewController` instance if found, `nil` otherwise.
    static func findViewController(in viewController: UIViewController,
                                   options: SearchOptions = .currentAndUp,
                                   using predicate: (UIViewController) -> Bool) -> UIViewController? {
        guard !viewController.isBeingDismissed else {
            return nil
        }

        if options.contains(.current), predicate(viewController) {
            return viewController
        }

        if options.contains(.parent),
           let parentViewController = viewController.parent,
           let foundViewController = findViewController(in: parentViewController,
                   options: [.current, .parent],
                   using: predicate) {
            return foundViewController
        }

        if let container = viewController as? ContainerViewController, options.contains(.visible) || options.contains(.contained) {
            var viewControllers: [[UIViewController]] = []
            viewControllers.append(container.visibleViewControllers)
            if options.contains(.contained) {
                viewControllers.append(container.containedViewControllers)
            }
            for currentViewController in Array(viewControllers.joined()).uniqueElements() {
                if let foundViewController = findViewController(in: currentViewController,
                        options: options.contains(.visible) ? .currentVisibleOnly : [.current, .contained],
                        using: predicate) {
                    return foundViewController
                }
            }
        }

        if options.contains(.presented),
           let presentedViewController = viewController.presentedViewController {
            let presentedOptions = options.subtracting(.presenting)
            if let foundViewController = findViewController(in: presentedViewController, options: presentedOptions, using: predicate) {
                return foundViewController
            }
        }

        if options.contains(.presenting),
           let presentingViewController = viewController.presentingViewController {
            let presentingOptions = options.subtracting(.presented)
            if let foundViewController = findViewController(in: presentingViewController, options: presentingOptions, using: predicate) {
                return foundViewController
            }
        }

        return nil
    }

}

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
