//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class PresentModallyAction: ViewControllerAction {

    let presentationStyle: UIModalPresentationStyle

    let transitionStyle: UIModalTransitionStyle

    let transitioningDelegate: UIViewControllerTransitioningDelegate?

    public init(presentationStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical, transitioningDelegate: UIViewControllerTransitioningDelegate? = nil) {
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
        self.transitioningDelegate = transitioningDelegate
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (_: UIViewController) -> Void) {
        guard existingController.presentedViewController == nil else {
            logger?.log(.error("Could not present modally \(viewController) from \(existingController) because it has already presented a view controller."))
            completion(existingController)
            return
        }
        viewController.modalPresentationStyle = presentationStyle
        viewController.modalTransitionStyle = transitionStyle
        viewController.transitioningDelegate = transitioningDelegate
        existingController.present(viewController, animated: animated, completion: {
            completion(viewController)
        })
    }

}
