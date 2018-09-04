//
// Created by Eugene Kazaev on 17/08/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
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
        return 0.3
    }

    private func blurEffectView(_ style: UIBlurEffectStyle = .light, frame: CGRect? = nil, backgroundColor: UIColor?) -> UIVisualEffectView {
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
            // View but not the view controller's view should be used. See the doc for view(forKey:) or
            // http://stackoverflow.com/a/25193675/421797
            // NB: transitionContext.view(forKey: .from) is nil if you are not allowed to change it - (presentation is starting from this view)
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

        // On dismissal view to is not in transition view if UIPresentationController's shouldRemovePresentersView
        // is true (Full screen presentation happened over that view)
        // We are responsible to add it if we need it for the animation.
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
