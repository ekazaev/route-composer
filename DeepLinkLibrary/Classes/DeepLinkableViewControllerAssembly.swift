//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Step wrapper for a final step of deep linking. Accepts in constructor everything is needed to be done to transform it
/// in to actual router step.
public class ViewControllerAssembly: Step {

    /// Assembly internal factory that uses finder result as a factory result. Used with things that do not have actual
    /// factories like UIViewControllers that were build as a result of storyboard loading.
    internal class FinderFactory: Factory, PreparableFactory {

        var action: ViewControllerAction? = nil

        let finder: DeepLinkFinder?

        var arguments: Any?

        init(finder: DeepLinkFinder?) {
            self.finder = finder
        }

        func prepare(with arguments: Any?) -> DeepLinkResult {
            self.arguments = arguments
            return .handled
        }

        func build(with logger: Logger?) -> UIViewController? {
            return finder?.findViewController(with: arguments)
        }
    }

    public let previousStep: Step?

    public let postTask: PostRoutingTask?

    public let finder: DeepLinkFinder?

    public let factory: Factory?

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
    ///     UIViewController to make it imtegrated in to view controller stack whis also represtents a starting point
    ///     of rounting or a dependency.
    public init(finder: DeepLinkFinder? = nil, factory: Factory? = nil, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil, step: Step) {
        self.previousStep = step
        self.postTask = postTask
        self.finder = finder
        self.factory = factory ?? FinderFactory(finder: finder)
        self.interceptor = interceptor
    }

    public func perform(with arguments: Any?) -> StepResult {
        guard let finder = finder else  {
            return .continueRouting
        }
        return StepResult(finder.findViewController(with: arguments))
    }

}
