//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit


/// Chainable step.
/// Identifies that the step can be a part of the chain,
/// e.g. when it comes to the presentation of multiple view controllers to reach destination.

public class ChainableStep: Step {

    private(set) public var previousStep: Step? = nil

    public let factory: Factory?

    public let interceptor: RouterInterceptor?

    public let postTask: PostRoutingTask?

    internal init(factory: Factory? = nil, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil) {
        self.factory = factory
        self.interceptor = interceptor
        self.postTask = postTask
    }

    public func getPresentationViewController(with arguments: Any?) -> StepResult {
        return .continueRouting
    }

    func previous(continue step: Step) {
        previousStep = step
    }
}

/// Connects array of steps into a chain of steps.
///
/// - parameter chains: Array of chainable steps.
/// - returns: Last step to be made by a Router. The rest are linked to the last one.
public func chain(_ steps: [ChainableStep])  -> ChainableStep {
    guard let firstStep = steps.first else {
        fatalError("No steps provided to chain.")
    }

    var restSteps = steps
    var currentStep = firstStep
    restSteps.removeFirst()

    for presenter in restSteps {
        currentStep.previous(continue: presenter)
        currentStep = presenter
    }

    return firstStep
}
