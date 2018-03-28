//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Presents `UIViewController` using present(viewControllerToPresent, animated, completion) method of existing view
/// controller
public extension GeneralAction {

    /// Presents view controller modally
    public class PresentModally: Action {

        let presentationStyle: UIModalPresentationStyle

        let transitionStyle: UIModalTransitionStyle

        let transitioningDelegate: UIViewControllerTransitioningDelegate?

        /// Constructor
        ///
        /// - Parameters:
        ///   - presentationStyle: UIModalPresentationStyle setting, default value: .fullScreen
        ///   - transitionStyle: UIModalTransitionStyle setting, default value: .coverVertical
        ///   - transitioningDelegate: UIViewControllerTransitioningDelegate instance to be used during transition
        public init(presentationStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical, transitioningDelegate: UIViewControllerTransitioningDelegate? = nil) {
            self.presentationStyle = presentationStyle
            self.transitionStyle = transitionStyle
            self.transitioningDelegate = transitioningDelegate
        }

        public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) {
            guard existingController.presentedViewController == nil else {
                completion(.failure("\(existingController) has already presented view controller."))
                return
            }
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalTransitionStyle = transitionStyle
            viewController.transitioningDelegate = transitioningDelegate
            existingController.present(viewController, animated: animated, completion: {
                completion(.continueRouting)
            })
        }

    }

}