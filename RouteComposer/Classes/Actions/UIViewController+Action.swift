//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Just a wrapper for the general actions that can be applied to any `UIViewController`
public struct GeneralAction {

    /// The dummy `Action` instance mostly for the internal use, but can be useful outside of the library
    /// in combination with the factories that produces the view controllers that should not have to be integrated into the
    /// view controller's stack.
    public static func nilAction() -> UIViewController.NilAction<UIViewController> {
        return UIViewController.NilAction<UIViewController>()
    }

    public static func nilContainerAction<VC: ContainerViewController>() -> UIViewController.NilAction<VC> {
        return UIViewController.NilAction<VC>()
    }

    /// Replaces the root view controller in the key `UIWindow`
    public static func replaceRoot() -> UIViewController.ReplaceRootAction {
        return UIViewController.ReplaceRootAction()
    }

    /// Presents a view controller modally
    ///
    /// - Parameters:
    ///   - presentationStyle: UIModalPresentationStyle setting, default value: .fullScreen
    ///   - transitionStyle: UIModalTransitionStyle setting, default value: .coverVertical
    ///   - transitioningDelegate: UIViewControllerTransitioningDelegate instance to be used during the transition
    ///   - preferredContentSize: The preferredContentSize is used for any container laying out a child view controller.
    ///   - popoverControllerConfigurationBlock: Block to configure `UIPopoverPresentationController`.
    public static func presentModally(presentationStyle: UIModalPresentationStyle? = .fullScreen,
                               transitionStyle: UIModalTransitionStyle? = .coverVertical,
                               transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
                               preferredContentSize: CGSize? = nil,
                               popoverConfiguration: ((_: UIPopoverPresentationController) -> Void)? = nil) -> UIViewController.PresentModallyAction {
        return UIViewController.PresentModallyAction(presentationStyle: presentationStyle,
                transitionStyle: transitionStyle,
                transitioningDelegate: transitioningDelegate,
                preferredContentSize: preferredContentSize,
                popoverConfiguration: popoverConfiguration)
    }


}
