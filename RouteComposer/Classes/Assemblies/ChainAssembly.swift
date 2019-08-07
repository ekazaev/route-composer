//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// Builds a chain of steps.
public struct ChainAssembly {

    /// Transforms step into a chain of steps.
    /// ### Usage
    /// ```swift
    /// let intermediateStep = ChainAssembly.from(NavigationControllerStep<UINavigationController, Any?>())
    ///         .from(using: GeneralAction.presentModally())
    ///         .from(GeneralStep.current())
    ///         .assemble()
    /// ```
    /// - Parameter step: The instance of `ActionConnectingAssembly`
    public static func from<VC: UIViewController, C>(_ step: ActionToStepIntegrator<VC, C>) -> ActionConnectingAssembly<VC, VC, C> {
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: [])
    }

}
