//
// Created by Eugene Kazaev on 07/02/2018.
//

#if os(iOS)

import Foundation
import UIKit

/// Builds a chain of steps.
public struct ChainAssembly {

    // MARK: Methods

    /// Transforms step into a chain of steps.
    /// ### Usage
    /// ```swift
    /// let intermediateStep = ChainAssembly.from(NavigationControllerStep<UINavigationController, Any?>())
    ///         .using(GeneralAction.presentModally())
    ///         .from(GeneralStep.current())
    ///         .assemble()
    /// ```
    /// - Parameter step: The instance of `ActionConnectingAssembly`
    public static func from<VC: UIViewController, C>(_ step: ActionToStepIntegrator<VC, C>) -> ActionConnectingAssembly<VC, C> {
        return ActionConnectingAssembly<VC, C>(stepToFullFill: step, previousSteps: [])
    }

}

#endif
