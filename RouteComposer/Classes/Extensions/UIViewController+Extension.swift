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
    ///   - comparator: A block that should return `true` if the `UIViewController` instance provided is the
    ///     one that is being searched for.
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

// An `Action`s holder
extension UIViewController {

    /// The dummy `Action` instance is mostly for internal use. However, it can be useful outside of the library
    /// in combination with the factories that produce the view controllers that should not be integrated into the
    /// view controller's stack.
    struct NilAction: Action, NilEntity {

        public typealias ViewController = UIViewController

        /// Constructor
        init() {
        }

    }

    /// Presents a view controller modally
    public struct PresentModallyAction: Action {

        public typealias ViewController = UIViewController

        /// `UIModalPresentationStyle` setting
        public let presentationStyle: UIModalPresentationStyle?

        /// `UIModalTransitionStyle` setting
        public let transitionStyle: UIModalTransitionStyle?

        /// The preferredContentSize is used for any container laying out a child view controller.
        public let preferredContentSize: CGSize?

        /// Block to configure `UIPopoverPresentationController`
        public let popoverControllerConfigurationBlock: ((_: UIPopoverPresentationController) -> Void)?

        /// `UIViewControllerTransitioningDelegate` instance to be used during the transition
        private(set) weak var transitioningDelegate: UIViewControllerTransitioningDelegate?

        /// Constructor
        ///
        /// - Parameters:
        ///   - presentationStyle: `UIModalPresentationStyle` setting, default value: .fullScreen
        ///   - transitionStyle: `UIModalTransitionStyle` setting, default value: .coverVertical
        ///   - transitioningDelegate: `UIViewControllerTransitioningDelegate` instance to be used during the transition
        ///   - preferredContentSize: The preferredContentSize is used for any container laying out a child view controller.
        ///   - popoverControllerConfigurationBlock: Block to configure `UIPopoverPresentationController`.
        init(presentationStyle: UIModalPresentationStyle? = .fullScreen,
             transitionStyle: UIModalTransitionStyle? = .coverVertical,
             transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
             preferredContentSize: CGSize? = nil,
             popoverConfiguration: ((_: UIPopoverPresentationController) -> Void)? = nil) {
            self.presentationStyle = presentationStyle
            self.transitionStyle = transitionStyle
            self.transitioningDelegate = transitioningDelegate
            self.preferredContentSize = preferredContentSize
            self.popoverControllerConfigurationBlock = popoverConfiguration
        }

        public func perform(with viewController: UIViewController,
                            on existingController: UIViewController,
                            animated: Bool,
                            completion: @escaping (_: ActionResult) -> Void) {
            guard existingController.presentedViewController == nil else {
                completion(.failure("\(existingController) is already presenting a view controller."))
                return
            }
            if let presentationStyle = presentationStyle {
                viewController.modalPresentationStyle = presentationStyle
            }
            if let transitionStyle = transitionStyle {
                viewController.modalTransitionStyle = transitionStyle
            }
            if let transitioningDelegate = transitioningDelegate {
                viewController.transitioningDelegate = transitioningDelegate
            }
            if let preferredContentSize = preferredContentSize {
                viewController.preferredContentSize = preferredContentSize
            }
            if let popoverPresentationController = viewController.popoverPresentationController,
               let popoverControllerConfigurationBlock = popoverControllerConfigurationBlock {
                popoverControllerConfigurationBlock(popoverPresentationController)
            }

            existingController.present(viewController, animated: animated, completion: {
                completion(.continueRouting)
            })
        }

    }

    /// Replaces the root view controller in the key `UIWindow`
    public struct ReplaceRootAction: Action {

        public typealias ViewController = UIViewController

        /// Constructor
        init() {
        }

        public func perform(with viewController: UIViewController,
                            on existingController: UIViewController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            guard let window = UIWindow.key else {
                completion(.failure("Key window not found."))
                return
            }

            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return completion(.continueRouting)
        }

    }

}
