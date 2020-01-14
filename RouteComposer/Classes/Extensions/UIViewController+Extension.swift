//
// Created by Eugene Kazaev on 19/12/2017.
//

#if os(iOS)

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
                                   containerAdapterLocator: ContainerAdapterLocator = DefaultContainerAdapterLocator(),
                                   using predicate: (UIViewController) -> Bool) throws -> UIViewController? {
        guard !viewController.isBeingDismissed else {
            return nil
        }

        if options.contains(.current), predicate(viewController) {
            return viewController
        }

        if options.contains(.parent),
            let parentViewController = viewController.parent,
            let foundViewController = try findViewController(in: parentViewController,
                                                             options: [.current, .parent],
                                                             containerAdapterLocator: containerAdapterLocator,
                                                             using: predicate) {
            return foundViewController
        }

        if let container = viewController as? ContainerViewController, options.contains(.visible) || options.contains(.contained) {
            var viewControllers: [[UIViewController]] = []
            let containerAdapter = try containerAdapterLocator.getAdapter(for: container)
            viewControllers.append(containerAdapter.visibleViewControllers)
            if options.contains(.contained) {
                viewControllers.append(containerAdapter.containedViewControllers)
            }
            for currentViewController in Array(viewControllers.joined()).uniqueElements() {
                if let foundViewController = try findViewController(in: currentViewController,
                                                                    options: options.contains(.visible) ? .currentVisibleOnly : [.current, .contained],
                                                                    containerAdapterLocator: containerAdapterLocator,
                                                                    using: predicate) {
                    return foundViewController
                }
            }
        }

        if options.contains(.presented),
            let presentedViewController = viewController.presentedViewController {
            let presentedOptions = options.subtracting(.presenting)
            if let foundViewController = try findViewController(in: presentedViewController,
                                                                options: presentedOptions,
                                                                containerAdapterLocator: containerAdapterLocator,
                                                                using: predicate) {
                return foundViewController
            }
        }

        if options.contains(.presenting),
            let presentingViewController = viewController.presentingViewController {
            let presentingOptions = options.subtracting(.presented)
            if let foundViewController = try findViewController(in: presentingViewController,
                                                                options: presentingOptions,
                                                                containerAdapterLocator: containerAdapterLocator,
                                                                using: predicate) {
                return foundViewController
            }
        }

        return nil
    }

}

#endif
