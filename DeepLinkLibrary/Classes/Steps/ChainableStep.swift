//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit


/// Chainable step.
/// Identifies that the step can be a part of the chain,
/// e.g. when it comes to the presentation of multiple view controllers to reach destination.
public class ChainableStep: RoutingStep {

    private(set) public var previousStep: RoutingStep? = nil

    public let interceptor: RouterInterceptor?

    public let postTask: PostRoutingTask?

    let factory: AnyFactory

    public init<F:Factory>(factory: F, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil) {
        self.factory = FactoryBox(factory)
        self.interceptor = interceptor
        self.postTask = postTask
    }

    public init<F:ContainerFactory>(factory: F, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil) {
        self.factory = ContainerFactoryBox(factory)
        self.interceptor = interceptor
        self.postTask = postTask
    }

    public init<F:AnyFactory>(factory: F, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil) {
        self.factory = factory
        self.interceptor = interceptor
        self.postTask = postTask
    }

    public func perform(with arguments: Any?) -> StepResult {
        return .continueRouting(factory)
    }

    func from(_ step: RoutingStep) {
        previousStep = step
    }
}
