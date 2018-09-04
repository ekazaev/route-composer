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
    ///   - comparator: Block that should return `true` if the `UIViewController` instance provided is the
    ///     one that user is looking for.
    /// - Returns: A `UIViewController` instance if found, `nil` otherwise.
    public static func findViewController(in viewController: UIViewController,
                                          options: SearchOptions = .currentAndUp,
                                          using comparator: (UIViewController) -> Bool) -> UIViewController? {
        guard !viewController.isBeingDismissed else {
            return nil
        }

        if options.contains(.current), comparator(viewController) {
            return viewController
        }

        if let container = viewController as? ContainerViewController {
            var viewControllers: [[UIViewController]] = []
            if options.contains(.visible) {
                viewControllers.append(container.visibleViewControllers)
            }
            if options.contains(.containing) {
                viewControllers.append(container.containingViewControllers)
            }
            for currentViewController in Array(viewControllers.joined()).uniqueElements() {
                if let foundViewController = findViewController(in: currentViewController,
                        options: options.contains(.visible) ? .currentVisibleOnly : [.current, .containing],
                        using: comparator) {
                    return foundViewController
                }
            }
        }

        if options.contains(.presented),
           let presentedViewController = viewController.presentedViewController {
            let presentedOptions = options.subtracting(.presenting)
            if let foundViewController = findViewController(in: presentedViewController, options: presentedOptions, using: comparator) {
                return foundViewController
            }
        }

        if options.contains(.presenting),
           let presentingViewController = viewController.presentingViewController {
            let presentingOptions = options.subtracting(.presented)
            if let foundViewController = findViewController(in: presentingViewController, options: presentingOptions, using: comparator) {
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

}
