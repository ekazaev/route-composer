//
// RouteComposer
// BlurredBackgroundTransitionAnimator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

class BlurredBackgroundTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let transitionType: BlurredBackgroundTransitionType

    init(transitionType: BlurredBackgroundTransitionType) {
        self.transitionType = transitionType
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    private func blurEffectView(_ style: UIBlurEffect.Style = .light, frame: CGRect? = nil, backgroundColor: UIColor?) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        if let frame = frame {
            blurEffectView.frame = frame
        }
        blurEffectView.backgroundColor = backgroundColor
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return blurEffectView
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let viewToAnimate = transitionType == .present ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let initialAlpha: CGFloat = transitionType == .present ? 0 : 1
        let finalAlpha: CGFloat = transitionType == .present ? 1 : 0

        if viewToAnimate.superview == nil {
            transitionContext.containerView.addSubview(viewToAnimate)
        }

        viewToAnimate.alpha = initialAlpha

        let backgroundColor = UIColor.white
        let blurEffect = blurEffectView(backgroundColor: backgroundColor)
        transitionContext.containerView.insertSubview(blurEffect, belowSubview: viewToAnimate)
        blurEffect.frame = transitionContext.containerView.bounds
        let effect: UIBlurEffect? = transitionType == .present ? UIBlurEffect(style: .extraLight) : nil
        blurEffect.alpha = initialAlpha

        if transitionType == .dismiss,
           let viewBelow = transitionContext.view(forKey: .to),
           viewBelow.superview == nil {
            transitionContext.containerView.insertSubview(viewBelow, belowSubview: blurEffect)
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext) / 2.0,
                       delay: transitionDuration(using: transitionContext) / 2.0,
                       options: .curveEaseIn,
                       animations: {
                           blurEffect.effect = effect
                           blurEffect.alpha = finalAlpha
                       }, completion: nil)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            viewToAnimate.alpha = finalAlpha
        }, completion: { _ in
            blurEffect.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }

}
