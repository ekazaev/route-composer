//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class PresentModallyAction: Action {

    let presentationStyle: UIModalPresentationStyle

    let transitionStyle: UIModalTransitionStyle

    let transitioningDelegate: UIViewControllerTransitioningDelegate?

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
