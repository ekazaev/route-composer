//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

class FinalRoutingStep: InterceptableStep, PerformableStep, ChainableStep {

    let interceptor: AnyRouterInterceptor?

    let previousStep: RoutingStep?

    let postTask: AnyPostRoutingTask?

    let finder: AnyFinder?

    let factory: AnyFactory?

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
    init<F: Finder, FC: Factory>(finder: F?, factory: FC?, interceptor: AnyRouterInterceptor? = nil, postTask: AnyPostRoutingTask? = nil, previousStep: RoutingStep) where F.ViewController == FC.ViewController, F.Context == FC.Context {
        self.previousStep = previousStep
        self.postTask = postTask
        if let finder = finder {
            self.finder = FinderBox(finder)
        } else {
            self.finder = nil
        }
        if let factory = factory {
            if let _ = factory as? Container {
                self.factory = ContainerFactoryBox(factory)
            } else {
                self.factory = FactoryBox(factory)
            }
        } else if let finder = finder {
            self.factory = FactoryBox(FinderFactory(finder: finder))
        } else {
            self.factory = nil
        }
        self.interceptor = interceptor
    }

    func perform(with context: Any?) -> StepResult {
        guard let viewController = finder?.findViewController(with: context) else  {
            return .continueRouting(factory)
        }
        return .success(viewController)
    }

}
