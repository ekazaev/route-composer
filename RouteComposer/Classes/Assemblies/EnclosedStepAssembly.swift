//
// Created by Eugene Kazaev on 2018-10-13.
//

import Foundation
import UIKit

/// Builds a `DestinationStep` instance for the view controller that is built into container view controller in the
/// chained step.
/// ```swift
/// let productScreen = EnclosedStepAssembly(finder: ClassFinderFinder<LoginViewController, Any?>())
///         .from(SingleStep(finder: NilFinder<UINavigationController, Any?>(), factory: StoryboardFactory("Login")))
///         .assemble()
/// ```
/// **In the example above LoginViewController is bundled into UINavigationViewController loaded from the storyboard file.**
public final class EnclosedStepAssembly<F: Finder>: GenericStepAssembly<F.ViewController, F.Context>/*, ActionConnecting*/ {

    let finder: F

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    public init(finder: F) {
        self.finder = finder
    }

    /// Connects provided `StepWithActionAssembly` and uses it as a factory for the current step.
    /// Example: current `UIViewController` instance will be loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func from<AF: Finder, AFC: AbstractFactory>(_ step: StepWithActionAssembly<AF, AFC>) -> ActionConnectingAssembly<AF, AFC, ViewController, Context>
            where AF.ViewController == AFC.ViewController, AF.Context == AFC.Context, AF.ViewController: ContainerViewController {
        let currentStep = BaseStep<FactoryBox<FinderFactory>>(
                finder: FinderInContainer<AF.ViewController, F>(using: self.finder),
                factory: FinderFactory<F>(finder: self.finder),
                action: ActionBox(ViewControllerActions.NilAction()),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask())

        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: [currentStep])
    }

    /// Connects provided `DestinationStep` and uses it as a factory for the current step.
    /// Example: current `UIViewController` instance will be loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `DestinationStep` instance to be used.
    public func from<VC: ContainerViewController>(_ step: DestinationStep<VC, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        let currentStep = BaseStep<FactoryBox<FinderFactory>>(
                finder: FinderInContainer<VC, F>(using: self.finder),
                factory: FinderFactory<F>(finder: self.finder),
                action: ActionBox(ViewControllerActions.NilAction()),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask())

        return LastStepInChainAssembly(previousSteps: [currentStep, step])
    }

    /// Assembles with provided `DestinationStep` and uses it as a factory for the current step.
    /// Example: current `UIViewController` instance will be loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func assemble<VC: ContainerViewController>(from step: DestinationStep<VC, F.Context>) -> DestinationStep<F.ViewController, F.Context> {
        return from(step).assemble()
    }

}
