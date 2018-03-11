//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

class FinalRoutingStep: BaseStep, InterceptableStep {

    let interceptor: AnyRoutingInterceptor?

    let postTask: AnyPostRoutingTask?

    let contextTask: AnyContextTask?

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
    init<F: Finder, FC: Factory>(finder: F, factory: FC, interceptor: AnyRoutingInterceptor? = nil, contextTask: AnyContextTask? = nil, postTask: AnyPostRoutingTask? = nil, previousStep: RoutingStep) where F.ViewController == FC.ViewController, F.Context == FC.Context {
        self.postTask = postTask
        self.contextTask = contextTask
        self.interceptor = interceptor
        super.init(finder: finder, factory: factory, previousStep: previousStep)
    }

}
