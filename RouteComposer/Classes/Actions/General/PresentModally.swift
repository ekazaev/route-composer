//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Presents `UIViewController` using present(viewControllerToPresent, animated, completion) method of the existing view
/// controller
public extension GeneralAction {

    /// Presents a view controller modally
    public struct PresentModally: Action {

        public typealias ViewController = UIViewController

        /// UIModalPresentationStyle setting
        public let presentationStyle: UIModalPresentationStyle?

        /// UIModalTransitionStyle setting
        public let transitionStyle: UIModalTransitionStyle?

        /// The preferredContentSize is used for any container laying out a child view controller.
        public let preferredContentSize: CGSize?

        /// Block to configure `UIPopoverPresentationController`
        public let popoverControllerConfigurationBlock: ((_: UIPopoverPresentationController) -> Void)?

        /// UIViewControllerTransitioningDelegate instance to be used during the transition
        private(set) weak var transitioningDelegate: UIViewControllerTransitioningDelegate?

        /// Constructor
        ///
        /// - Parameters:
        ///   - presentationStyle: UIModalPresentationStyle setting, default value: .fullScreen
        ///   - transitionStyle: UIModalTransitionStyle setting, default value: .coverVertical
        ///   - transitioningDelegate: UIViewControllerTransitioningDelegate instance to be used during the transition
        ///   - preferredContentSize: The preferredContentSize is used for any container laying out a child view controller.
        ///   - popoverControllerConfigurationBlock: Block to configure `UIPopoverPresentationController`.
        public init(presentationStyle: UIModalPresentationStyle? = .fullScreen,
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

}
