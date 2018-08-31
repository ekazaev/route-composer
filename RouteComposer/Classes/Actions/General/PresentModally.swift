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

        let presentationStyle: UIModalPresentationStyle?

        let transitionStyle: UIModalTransitionStyle?

        weak var transitioningDelegate: UIViewControllerTransitioningDelegate?

        /// Constructor
        ///
        /// - Parameters:
        ///   - presentationStyle: UIModalPresentationStyle setting, default value: .fullScreen
        ///   - transitionStyle: UIModalTransitionStyle setting, default value: .coverVertical
        ///   - transitioningDelegate: UIViewControllerTransitioningDelegate instance to be used during the transition
        public init(presentationStyle: UIModalPresentationStyle? = .fullScreen,
                    transitionStyle: UIModalTransitionStyle? = .coverVertical,
                    transitioningDelegate: UIViewControllerTransitioningDelegate? = nil) {
            self.presentationStyle = presentationStyle
            self.transitionStyle = transitionStyle
            self.transitioningDelegate = transitioningDelegate
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

            existingController.present(viewController, animated: animated, completion: {
                completion(.continueRouting)
            })
        }

    }

}
