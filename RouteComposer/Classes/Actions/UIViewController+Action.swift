//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// A wrapper for general actions that can be applied to any `UIViewController`
public struct GeneralAction {

    // MARK: Actions

    /// Replaces the root view controller in the key `UIWindow`
    ///
    /// - Parameters:
    ///   - windowProvider: `WindowProvider` instance
    ///   - animationOptions: Set of `UIView.AnimationOptions`. Transition will happen without animation if not provided.
    ///   - duration: Transition duration.
    public static func replaceRoot(windowProvider: WindowProvider = KeyWindowProvider(),
                                   animationOptions: UIView.AnimationOptions? = nil,
                                   duration: TimeInterval = 0.3) -> ViewControllerActions.ReplaceRootAction {
        return ViewControllerActions.ReplaceRootAction(windowProvider: windowProvider, animationOptions: animationOptions, duration: duration)
    }

    /// Presents a view controller modally
    ///
    /// - Parameters:
    ///   - presentationStyle: `UIModalPresentationStyle` setting, default value: .fullScreen
    ///   - transitionStyle: `UIModalTransitionStyle` setting, default value: .coverVertical
    ///   - transitioningDelegate: `UIViewControllerTransitioningDelegate` instance to be used during the transition
    ///   - isModalInPresentation: A Boolean value indicating whether the view controller enforces a modal behavior.
    ///   - preferredContentSize: The preferredContentSize is used for any container laying out a child view controller.
    ///   - popoverControllerConfigurationBlock: Block to configure `UIPopoverPresentationController`.
    public static func presentModally(presentationStyle: UIModalPresentationStyle? = .fullScreen,
                                      transitionStyle: UIModalTransitionStyle? = .coverVertical,
                                      transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
                                      preferredContentSize: CGSize? = nil,
                                      isModalInPresentation: Bool? = nil,
                                      popoverConfiguration: ((_: UIPopoverPresentationController) -> Void)? = nil) -> ViewControllerActions.PresentModallyAction {
        return ViewControllerActions.PresentModallyAction(presentationStyle: presentationStyle,
                transitionStyle: transitionStyle,
                transitioningDelegate: transitioningDelegate,
                preferredContentSize: preferredContentSize,
                isModalInPresentation: isModalInPresentation,
                popoverConfiguration: popoverConfiguration)
    }

    /// `Action` does nothing, but can be helpful for testing or writing the sequences of steps with the `NilFactory`
    public static func nilAction() -> ViewControllerActions.NilAction {
        return ViewControllerActions.NilAction()
    }

}

/// A wrapper for general actions that can be applied to any `UIViewController`
public struct ViewControllerActions {

    // MARK: Internal entities

    /// Presents a view controller modally
    public struct PresentModallyAction: Action {

        // MARK: Properties

        /// `UIModalPresentationStyle` setting
        public let presentationStyle: UIModalPresentationStyle?

        /// A Boolean value indicating whether the view controller enforces a modal behavior.
        public let isModalInPresentation: Bool?

        /// `UIModalTransitionStyle` setting
        public let transitionStyle: UIModalTransitionStyle?

        /// The preferredContentSize is used for any container laying out a child view controller.
        public let preferredContentSize: CGSize?

        /// Block to configure `UIPopoverPresentationController`
        public let popoverControllerConfigurationBlock: ((_: UIPopoverPresentationController) -> Void)?

        /// `UIViewControllerTransitioningDelegate` instance to be used during the transition
        private(set) public weak var transitioningDelegate: UIViewControllerTransitioningDelegate?

        // MARK: Methods

        /// Constructor
        ///
        /// - Parameters:
        ///   - presentationStyle: `UIModalPresentationStyle` setting, default value: .fullScreen
        ///   - transitionStyle: `UIModalTransitionStyle` setting, default value: .coverVertical
        ///   - transitioningDelegate: `UIViewControllerTransitioningDelegate` instance to be used during the transition
        ///   - preferredContentSize: The preferredContentSize is used for any container laying out a child view controller.
        ///   - isModalInPresentation: A Boolean value indicating whether the view controller enforces a modal behavior.
        ///   - popoverControllerConfigurationBlock: Block to configure `UIPopoverPresentationController`.
        init(presentationStyle: UIModalPresentationStyle? = .fullScreen,
             transitionStyle: UIModalTransitionStyle? = .coverVertical,
             transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
             preferredContentSize: CGSize? = nil,
             isModalInPresentation: Bool? = nil,
             popoverConfiguration: ((_: UIPopoverPresentationController) -> Void)? = nil) {
            self.presentationStyle = presentationStyle
            self.transitionStyle = transitionStyle
            self.transitioningDelegate = transitioningDelegate
            self.preferredContentSize = preferredContentSize
            self.popoverControllerConfigurationBlock = popoverConfiguration
            self.isModalInPresentation = isModalInPresentation
        }

        public func perform(with viewController: UIViewController,
                            on existingController: UIViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            guard existingController.presentedViewController == nil else {
                completion(.failure(RoutingError.compositionFailed(.init("\(existingController) is " +
                        "already presenting a view controller."))))
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
            if #available(iOS 13, *), let isModalInPresentation = isModalInPresentation {
                viewController.isModalInPresentation = isModalInPresentation
            }
            existingController.present(viewController, animated: animated, completion: {
                completion(.success)
            })
        }

    }

    /// Replaces the root view controller in the key `UIWindow`
    public struct ReplaceRootAction: Action {

        // MARK: Properties

        /// `WindowProvider` instance
        public let windowProvider: WindowProvider

        /// Set of `UIView.AnimationOptions`
        public let animationOptions: UIView.AnimationOptions?

        /// Transition duration.
        public let duration: TimeInterval

        // MARK: Methods

        /// Constructor
        ///
        /// - Parameters:
        ///   - windowProvider: `WindowProvider` instance
        ///   - animationOptions: Set of `UIView.AnimationOptions`. Transition will happen without animation if not provided.
        ///   - duration: Transition duration.
        init(windowProvider: WindowProvider = KeyWindowProvider(), animationOptions: UIView.AnimationOptions? = nil, duration: TimeInterval = 0.3) {
            self.windowProvider = windowProvider
            self.animationOptions = animationOptions
            self.duration = duration
        }

        public func perform(with viewController: UIViewController,
                            on existingController: UIViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            guard let window = windowProvider.window else {
                completion(.failure(RoutingError.compositionFailed(.init("Window was not found."))))
                return
            }
            guard window.rootViewController == existingController else {
                completion(.failure(RoutingError.compositionFailed(.init("Action should be applied to the root view " +
                        "controller, got \(String(describing: existingController)) instead."))))
                return
            }

            guard animated, let animationOptions = animationOptions, duration > 0 else {
                window.rootViewController = viewController
                window.makeKeyAndVisible()
                return completion(.success)
            }

            UIView.transition(with: window, duration: duration, options: animationOptions, animations: {
                let oldAnimationState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = viewController
                window.rootViewController?.view.setNeedsLayout()
                window.makeKeyAndVisible()
                UIView.setAnimationsEnabled(oldAnimationState)
            })
            completion(.success)
        }

    }

    /// Helper `Action` that does nothing
    public struct NilAction: Action {

        // MARK: Methods

        /// Constructor
        init() {
        }

        /// Does nothing and always succeeds
        public func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
            completion(.success)
        }

    }

}
