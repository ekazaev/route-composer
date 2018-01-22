//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Assembly helps to abstract from a step's strategy for one particular UIViewController and wrap up all together
/// that is necessary to build it in the exact implementation of an assembly. Router actually only cares about the
/// step is should do so the rest is hidden in a default implementation.
public protocol DeepLinkableViewControllerAssembly {

    var step: Step { get }

}

/// Default implementation of an assebly. Accepts in constructor everything is needed to be done to transform it
/// in to actual router step.
public class ViewControllerAssembly: DeepLinkableViewControllerAssembly {

    let originalStep: Step

    public var step: Step {
        get {
            //  Here assembly transforms properties it has to a Step instance that can be executed by Router.
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

    /// ViewControllerAssembly constructor
    ///
    /// - Parameters:
    ///   - finder: Finder instance to be used by Router to find if this UIViewController is already exist in
    ///     view controller stack.
    ///   - factory: Factory instance to be user by Router to build this view controller if it does not exist.
    ///   - interceptor: Interceptor that Router has to run before even try to route to a UIViewController
    ///     represented by this assembly.
    ///   - postTask: A PostRoutingTask instance that has to be run by Router after routing to this assembly, or
    ///     any assemblies (UIViewControllers) that are dependent on this one.
    ///   - step: Step instance contains action that has to be executed by router after it creates assembly's
    ///     UIViewController to make it imtegrated in to view controller stack whis also represtents a starting point
    ///     of rounting or a dependency.
    public init(finder: DeepLinkFinder? = nil, factory: Factory? = nil, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil, step: Step) {
        self.originalStep = step
        self.postTask = postTask
        self.finder = finder
        self.factory = factory
        self.interceptor = interceptor
    }

}

/// Internal class that represents for Router assembly's actions that have to be done to build its UIViewController
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

/// Internal class that represents for router asseblie's action that has to be done if it knows how to find itself
/// in a view controller stack.
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

        func build(with logger: Logger?) -> UIViewController? {
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

