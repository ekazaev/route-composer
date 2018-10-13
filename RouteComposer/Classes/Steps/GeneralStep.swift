//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation
import UIKit

/// A wrapper for the general steps that can be applied to any `UIViewController`
public struct GeneralStep {

    struct CurrentViewControllerFinder<VC: UIViewController, C>: Finder {

        func findViewController(with context: C) -> VC? {
            return UIWindow.key?.topmostViewController as? VC
        }

    }

    struct RootViewControllerFinder<VC: UIViewController, C>: Finder {

        func findViewController(with context: C) -> VC? {
            return UIWindow.key?.rootViewController as? VC
        }

    }

    /// Returns the root view controller of the key window.
    public static func root<C>() -> DestinationStep<UIViewController, C> {
        return DestinationStep(BaseStep<FactoryBox<NilFactory>>(finder: RootViewControllerFinder<UIViewController, C>(),
                factory: nil,
                action: ActionBox(ViewControllerActions.NilAction()),
                interceptor: nil,
                contextTask: nil,
                postTask: nil))
    }

    /// Returns the topmost presented view controller.
    public static func current<C>() -> DestinationStep<UIViewController, C> {
        return DestinationStep(BaseStep<FactoryBox<NilFactory>>(finder: CurrentViewControllerFinder<UIViewController, C>(),
                factory: nil,
                action: ActionBox(ViewControllerActions.NilAction()),
                interceptor: nil,
                contextTask: nil,
                postTask: nil))
    }

}
