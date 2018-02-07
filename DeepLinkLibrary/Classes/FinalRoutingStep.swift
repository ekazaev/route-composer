//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

class FinalRoutingStep: RoutingStep {

    internal class NilAction: ViewControllerAction {
        func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (UIViewController) -> Void) {
            completion(viewController)
        }
    }
    /// Assembly internal factory that uses finder result as a factory result. Used with things that do not have actual
    /// factories like UIViewControllers that were build as a result of storyboard loading.
    internal class FinderFactory: Factory, PreparableFactory {

        var action: ViewControllerAction = NilAction()

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

    public let previousStep: RoutingStep?

    public let postTask: PostRoutingTask?

    let finder: DeepLinkFinder?

    let factory: Factory

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
    ///     UIViewController to make it integrated in to view controller stack which also represtents a starting point
    ///     of rounting or a dependency.
    init(finder: DeepLinkFinder? = nil, factory: Factory? = nil, interceptor: RouterInterceptor? = nil, postTask: PostRoutingTask? = nil, step: RoutingStep) {
        self.previousStep = step
        self.postTask = postTask
        self.finder = finder
        self.factory = factory ?? FinderFactory(finder: finder)
        self.interceptor = interceptor
    }

    public func perform(with arguments: Any?) -> StepResult {
        guard let viewController = finder?.findViewController(with: arguments) else  {
            return .continueRouting(factory)
        }
        return .success(viewController)
    }

}
