//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

public class SmartStepAssembly {

    private class BlockResolver: SmartStepResolver {

        let resolverBlock: ((_: Any?) -> RoutingStep?)

        init(resolverBlock: @escaping ((_: Any?) -> RoutingStep?)) {
            self.resolverBlock = resolverBlock
        }

        func resolve(with arguments: Any?) -> RoutingStep? {
            return resolverBlock(arguments)
        }
    }

    private struct FinderStep: PerformableStep {

        let finder: AnyFinder

        init<F: Finder>(finder: F) {
            self.finder = FinderBox(finder)
        }

        func viewController(with arguments: Any?) -> UIViewController? {
            return finder.findViewController(with: arguments)
        }

        func perform(with arguments: Any?) -> StepResult {
            guard let viewController = viewController(with: arguments) else {
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

    public func assemble() -> RoutingStep {
        return SmartStep(resolvers: resolvers)
    }
}