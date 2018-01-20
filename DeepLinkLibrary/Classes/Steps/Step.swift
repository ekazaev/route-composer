//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public enum StepResult {

    case found(UIViewController)

    case continueRouting

    case failure

    init(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            self = .continueRouting
            return
        }

        self = .found(viewController)
    }
}

public protocol Step {

    var factory: Factory? { get }

    var interceptor: RouterInterceptor? { get }

    var postTask: PostRoutingTask? { get }

    var prevStep: Step? { get }

    func getPresentationViewController(with arguments: Any?) -> StepResult

}

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
