//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// A wrapper for general actions that can be applied to any `UIViewController`
public struct GeneralAction {

    /// Replaces the root view controller in the key `UIWindow`
    public static func replaceRoot() -> ViewControllerActions.ReplaceRootAction {
        return ViewControllerActions.ReplaceRootAction()
    }

    /// Presents a view controller modally
    ///
    /// - Parameters:
    ///   - presentationStyle: `UIModalPresentationStyle` setting, default value: .fullScreen
    ///   - transitionStyle: `UIModalTransitionStyle` setting, default value: .coverVertical
    ///   - transitioningDelegate: `UIViewControllerTransitioningDelegate` instance to be used during the transition
    ///   - preferredContentSize: The preferredContentSize is used for any container laying out a child view controller.
    ///   - popoverControllerConfigurationBlock: Block to configure `UIPopoverPresentationController`.
    public static func presentModally(presentationStyle: UIModalPresentationStyle? = .fullScreen,
                                      transitionStyle: UIModalTransitionStyle? = .coverVertical,
                                      transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
                                      preferredContentSize: CGSize? = nil,
                                      popoverConfiguration: ((_: UIPopoverPresentationController) -> Void)? = nil) -> ViewControllerActions.PresentModallyAction {
        return ViewControllerActions.PresentModallyAction(presentationStyle: presentationStyle,
                transitionStyle: transitionStyle,
                transitioningDelegate: transitioningDelegate,
                preferredContentSize: preferredContentSize,
                popoverConfiguration: popoverConfiguration)
    }

}

/// A wrapper for general actions that can be applied to any `UIViewController`
public struct ViewControllerActions {

    /// The dummy `Action` instance is mostly for internal use. However, it can be useful outside of the library
    /// in combination with the factories that produce the view controllers that should not be integrated into the
    /// view controller's stack.
    struct NilAction: Action, NilEntity {

        typealias ViewController = UIViewController

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
                completion(.failure(RoutingError.compositionFailed(RoutingError.Context(debugDescription: "\(existingController) is " +
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
                completion(.failure(RoutingError.compositionFailed(RoutingError.Context(debugDescription: "Key window was not found."))))
                return
            }

            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return completion(.continueRouting)
        }

    }

}
