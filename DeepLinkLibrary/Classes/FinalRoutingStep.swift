//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit


class FinalRoutingStep: RoutingStep {

    public let previousStep: RoutingStep?

    public let postTask: PostRoutingTask?

    let finder: AbstractFinder?

    let factory: AbstractFactory?

    public let interceptor: RouterInterceptor?

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
    ///     UIViewController to make it integrated in to view controller stack which also represents a starting point
    ///     of routing or a dependency.
    init<F: Finder, FF: Factory>(finder: F?, factory: FF?, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil, step: RoutingStep) {
        self.previousStep = step
        self.postTask = postTask
        if let finder = finder {
            self.finder = FinderWrapper(finder)
        } else {
            self.finder = nil
        }
        if let factory = factory {
            self.factory = FactoryWrapper(factory)
        } else {
            self.factory = FactoryWrapper(FinderFactory(finder: finder))
        }
        self.interceptor = interceptor
    }

    public func perform(with arguments: Any?) -> StepResult {
        guard let viewController = finder?.findViewController(with: arguments) else  {
            return .continueRouting(factory)
        }
        return .success(viewController)
    }

}
