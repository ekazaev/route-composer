//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Helps to build a tree of step which will be taken by a router and add a condition to each step when it should
/// be taken.
public class SwitcherStepAssembly {

    private class BlockResolver: StepCaseResolver {

        let resolverBlock: ((_: Any?) -> RoutingStep?)

        init(resolverBlock: @escaping ((_: Any?) -> RoutingStep?)) {
            self.resolverBlock = resolverBlock
        }

        func resolve(with context: Any?) -> RoutingStep? {
            return resolverBlock(context)
        }
    }

    private struct FinderStep: PerformableStep {

        let finder: AnyFinder

        init<F: Finder>(finder: F) {
            self.finder = FinderBox(finder)
        }

        func viewController(with context: Any?) -> UIViewController? {
            return finder.findViewController(with: context)
        }

        func perform(with context: Any?) -> StepResult {
            guard let viewController = viewController(with: context) else {
                return .failure
            }
            return .success(viewController)
        }
    }

    private class FinderResolver: StepCaseResolver {

        private let finder: AnyFinder

        private let step: RoutingStep

        init<F: Finder>(finder: F, step: RoutingStep?) {
            self.step = step ?? FinderStep(finder: finder)
            self.finder = FinderBox(finder)
        }

        func resolve(with context: Any?) -> RoutingStep? {
            return finder.findViewController(with: context) != nil ? step : nil
        }
    }

    private var resolvers: [StepCaseResolver] = []

    /// Constructor
    public init() {

    }

    /// Add instance of StepCaseResolver
    ///
    /// - Parameter resolver: StepCaseResolver
    public func addCase(_ resolver: StepCaseResolver) -> Self {
        resolvers.append(resolver)
        return self
    }

    /// Add block which will allow to write a decision case for the Router in the block
    ///
    /// - Parameter resolverBlock: case resolver block
    public func addCase(_ resolverBlock: @escaping ((_: Any?) -> RoutingStep?)) -> Self {
        resolvers.append(BlockResolver(resolverBlock: resolverBlock))
        return self
    }

    /// Add case when some view controller exist in the stack to make some particular step then.
    ///
    /// - Parameters:
    ///   - finder: Finder instance to find a UIViewController in the stack
    ///   - step: Step to make if finder been able to find view controller in the stack. If not provided
    ///   UIViewController found by finder will be considered as a view controller to start routing process from
    public func addCase<F: Finder>(when finder: F, do step: RoutingStep? = nil) -> Self {
        resolvers.append(FinderResolver(finder: finder, step: step))
        return self
    }

    /// Assemble all the cases in to RoutingStep implementation
    ///
    /// - Returns: instance of RoutingStep
    public func assemble() -> RoutingStep {
        return SwitcherStep(resolvers: resolvers)
    }

    /// Assemble all the cases in to RoutingStep implementation and adds default implementation what to do
    /// if non of the cases succeed
    ///
    /// - Parameter resolverBlock: default resolver block
    /// - Returns: instance of RoutingStep
    public func assemble(default resolverBlock: @escaping (() -> RoutingStep)) -> RoutingStep {
        resolvers.append(BlockResolver(resolverBlock: { _ in
            return resolverBlock()
        }))
        return SwitcherStep(resolvers: resolvers)
    }

}
