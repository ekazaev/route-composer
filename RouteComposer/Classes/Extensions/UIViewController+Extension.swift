//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

//import Foundation

import UIKit

/// A set of options for the `findViewController` method
public struct SearchOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Compare with a view controller provided
    public static let current = SearchOptions(rawValue: 1 << 0)

    /// If the view controller is a container, search in its visible view controllers
    public static let visible = SearchOptions(rawValue: 1 << 1)

    /// If the view controller is a container, search in all the view controllers it contains
    public static let containing = SearchOptions(rawValue: 1 << 2)

    /// Start the search from the view controller provided and search in all view controllers it presented
    public static let presented = SearchOptions(rawValue: 1 << 3)

    /// Start the search from the view controller provided and search in all view controllers that presenting it
    public static let presenting = SearchOptions(rawValue: 1 << 4)

    /// If the view controller is a container, search in all the view controllers it contains
    public static let currentAllStack: SearchOptions = [.current, .containing]

    /// If the view controller is a container, search in all visible view controllers it contains
    public static let currentVisibleOnly: SearchOptions = [.current, .visible]

    /// Iterate through the all visible view controllers in the stack.
    public static let allVisible: SearchOptions = [.currentVisibleOnly, .presented, .presenting]

    /// Iterate through the all view controllers in the stack.
    public static let fullStack: SearchOptions = [.current, .containing, .presented, .presenting]

    /// Iterate through the all view controllers on the current level and all the view controllers
    /// presented from the current level.
    public static let currentAndUp: SearchOptions = [.currentAllStack, .presented]

    /// Iterate through the all view controllers on the current level and all the view controllers
    /// that are presenting the current level.
    public static let currentAndDown: SearchOptions = [.currentAllStack, .presenting]
}

public extension UIViewController {

    /// Iterates through the view controller stack to finds a `UIViewController` instance.
    ///
    /// - Parameters:
    ///   - vc: A `UIViewController` instance to start from.
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
            for selected in Array(viewControllers.joined()).uniqElements() {
                if let found = findViewController(in: selected,
                        options: options.contains(.visible) ? .currentVisibleOnly : [.current, .containing],
                        using: comparator) {
                    return found
                }
            }
        }

        if options.contains(.presented),
           let presentedViewController = viewController.presentedViewController {
            let presentedOptions = options.subtracting(.presenting)
            if let found = findViewController(in: presentedViewController, options: presentedOptions, using: comparator) {
                return found
            }
        }
        if options.contains(.presenting),
           let presentingViewController = viewController.presentingViewController {
            let presentingOptions = options.subtracting(.presented)
            if let found = findViewController(in: presentingViewController, options: presentingOptions, using: comparator) {
                return found
            }
        }

        return nil
    }

    internal var allPresentedViewControllers: [UIViewController] {
        return UIViewController.findAllPresentedViewControllers(starting: self)
    }

    private static func findParentViewController(from viewController: UIViewController, using comparator: (UIViewController) -> Bool) -> UIViewController? {
        if comparator(viewController) {
            return viewController
        }

        if let parentVC = viewController.parent {
            return findParentViewController(from: parentVC, using: comparator)
        }

        return nil
    }

    internal func dismissAllPresentedControllers(animated: Bool, completion: (() -> Void)?) {
        if self.presentedViewController != nil {
            self.dismiss(animated: animated) {
                completion?()
            }
        } else {
            completion?()
        }
    }

    private static func findAllPresentedViewControllers(starting viewController: UIViewController, found: [UIViewController] = []) -> [UIViewController] {
        var found = found
        if let presentedViewController = viewController.presentedViewController {
            found.append(presentedViewController)
            return findAllPresentedViewControllers(starting: presentedViewController, found: found)
        } else {
            return found
        }
    }
}
