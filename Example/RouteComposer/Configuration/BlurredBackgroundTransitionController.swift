//
// RouteComposer
// BlurredBackgroundTransitionController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

enum BlurredBackgroundTransitionType {
    case present
    case dismiss
}

class BlurredBackgroundTransitionController: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        BlurredBackgroundTransitionAnimator(transitionType: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        BlurredBackgroundTransitionAnimator(transitionType: .dismiss)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        BlurredBackgroundPresentationController(presentedViewController: presented, presenting: presenting)
    }

}
