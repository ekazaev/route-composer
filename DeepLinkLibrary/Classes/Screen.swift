//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public protocol DeepLinkableScreen {

    var step: Step { get }

}

public class Screen: DeepLinkableScreen {

    let originalStep: Step

    public var step: Step {
        get {
            if let finder = finder {
                return FinderStep(finder: finder, prevStep: originalStep, factory: factory, interceptor: interceptor, postTask: postTask)
            } else if let factory = factory {
                return FactoryStep(prevStep: originalStep, factory: factory, interceptor: interceptor, postTask: postTask)
            }
            return originalStep
        }
    }

    public let postTask: PostRoutingTask?

    public let finder: DeepLinkFinder?

    public let factory: Factory?

    let interceptor: RouterInterceptor?

    public init(finder: DeepLinkFinder? = nil, factory: Factory? = nil, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil, step: Step) {
        self.originalStep = step
        self.postTask = postTask
        self.finder = finder
        self.factory = factory
        self.interceptor = interceptor
    }

}

class FactoryStep: Step {

    let factory: Factory?

    let prevStep: Step?

    let interceptor: RouterInterceptor?

    let postTask: PostRoutingTask?

    init(prevStep: Step?, factory: Factory, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil) {
        self.prevStep = prevStep
        self.factory = factory
        self.postTask = postTask
        self.interceptor = interceptor
    }

    func getPresentationViewController(with arguments: Any?) -> StepResult {
        return .continueRouting
    }
}

class FinderStep: Step {

    class FinderFactory: Factory, PreparableFactory {

        var action: ViewControllerAction? = nil

        let finder: DeepLinkFinder

        var arguments: Any?

        init(finder: DeepLinkFinder) {
            self.finder = finder
        }

        func prepare(with arguments: Any?) -> DeepLinkResult {
            self.arguments = arguments
            return .handled
        }

        func build() -> UIViewController? {
            return finder.findViewController(with: arguments)
        }
    }

    let interceptor: RouterInterceptor?

    let factory: Factory?

    let prevStep: Step?

    let finder: DeepLinkFinder

    let postTask: PostRoutingTask?

    init(finder: DeepLinkFinder, prevStep: Step?, factory: Factory?, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil) {
        self.finder = finder
        self.postTask = postTask
        self.prevStep = prevStep
        self.factory = factory ?? FinderFactory(finder: finder)
        self.interceptor = interceptor
    }

    func getPresentationViewController(with arguments: Any?) -> StepResult {
        return StepResult(finder.findViewController(with: arguments))
    }
}

