//
// RouteComposer
// BlurredBackgroundTransitionController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
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
