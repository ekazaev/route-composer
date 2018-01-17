//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public protocol Step {

    var factory: Factory? { get }

    var interceptor: RouterInterceptor? { get }

    var prevStep: Step? { get }

    func getPresentationViewController(with arguments: Any?) -> UIViewController?

}

public class ChainableStep: Step {

    private(set) public var prevStep: Step? = nil

    public let factory: Factory?

    public let interceptor: RouterInterceptor?

    internal init(factory: Factory? = nil, interceptor: RouterInterceptor? = nil) {
        self.factory = factory
        self.interceptor = interceptor
    }

    public func getPresentationViewController(with arguments: Any?) -> UIViewController? {
        return nil
    }

    func previous(continue step: Step) {
        prevStep = step
    }

}


public func chain(_ chains: [ChainableStep])  -> ChainableStep {
    guard let firstStep = chains.first else {
        fatalError()
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
