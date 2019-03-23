//
// Created by Eugene Kazaev on 10/07/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

enum BlurredBackgroundTransitionType {
    case present
    case dismiss
}

class BlurredBackgroundTransitionController: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BlurredBackgroundTransitionAnimator(transitionType: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BlurredBackgroundTransitionAnimator(transitionType: .dismiss)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BlurredBackgroundPresentationController(presentedViewController: presented, presenting: presenting)
    }

}
