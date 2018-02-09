//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

public protocol SmartStepResolver {

    func resolve(with arguments: Any?) -> RoutingStep?

}

public class SmartStep: RoutingStep {

    private(set) public var previousStep: RoutingStep? = nil

    public let interceptor: RouterInterceptor? = nil

    public let postTask: PostRoutingTask? = nil

    private var resolvers: [SmartStepResolver]

    public func perform(with arguments: Any?) -> StepResult {
        previousStep = nil
        resolvers.forEach({ resolver in
            guard previousStep == nil, let step = resolver.resolve(with: arguments) else {
                return
            }
            previousStep = step
        })

        return .continueRouting(nil)
    }

    public init(resolvers: [SmartStepResolver]) {
        self.resolvers = resolvers
    }
}

public class SmartStepAssembly {

    private class BlockResolver: SmartStepResolver {

        private let resolverBlock: ((_: Any?) -> RoutingStep?)

        init(resolverBlock: @escaping ((_: Any?) -> RoutingStep?)) {
            self.resolverBlock = resolverBlock
        }

        func resolve(with arguments: Any?) -> RoutingStep? {
            return resolverBlock(arguments)
        }
    }

    private struct FinderStep: RoutingStep {
        var interceptor: RouterInterceptor? = nil
        var postTask: PostRoutingTask? = nil
        var previousStep: RoutingStep? = nil
        var finder: AnyFinder

        init<F: Finder>(finder: F) {
            self.finder = FinderBox(finder)
        }

        func perform(with arguments: Any?) -> StepResult {
            guard let viewController = finder.findViewController(with: arguments) else {
                return .failure
            }
            return .success(viewController)
        }
    }

    private class FinderResolver: SmartStepResolver {

        private let finder: AnyFinder

        private let step: RoutingStep

        init<F: Finder>(finder: F, step: RoutingStep?) {
            self.step = step ?? FinderStep(finder: finder)
            self.finder = FinderBox(finder)
        }

        func resolve(with arguments: Any?) -> RoutingStep? {
            return finder.findViewController(with: arguments) != nil ? step : nil
        }
    }

    private var resolvers: [SmartStepResolver] = []

    public init() {

    }

    public func addCase(_ resolver: SmartStepResolver) -> Self {
        resolvers.append(resolver)
        return self
    }

    public func addCase(_ resolverBlock: @escaping ((_: Any?) -> RoutingStep?)) -> Self {
        resolvers.append(BlockResolver(resolverBlock: resolverBlock))
        return self
    }

    public func addCase<F: Finder>(when finder: F, do step: RoutingStep? = nil) -> Self {
        resolvers.append(FinderResolver(finder: finder, step: step))
        return self
    }

    public func assemble() -> SmartStep {
        return SmartStep(resolvers: resolvers)
    }
}