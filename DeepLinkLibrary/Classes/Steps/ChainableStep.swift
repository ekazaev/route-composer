//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

public class ChainableStep: Step {

    private(set) public var prevStep: Step? = nil

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
        prevStep = step
    }

}


/// Chains array of step in to chain of steps.
///
/// - Parameter chains: Array of chainable ChainableStep
/// - Returns: Last step to be made by a Router. The resta re chained to that one.
public func chain(_ chains: [ChainableStep])  -> ChainableStep {
    guard let firstStep = chains.first else {
        fatalError("No steps provided to chain.")
    }

    var restSteps = chains
    var currentStep = firstStep
    restSteps.remove(at: 0)

    for presenter in restSteps {
        currentStep.previous(continue: presenter)
        currentStep = presenter
    }

    return firstStep
}