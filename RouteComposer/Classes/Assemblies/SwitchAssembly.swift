//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Builds tree of `RoutingStep` which will be taken by a `Router` and adds a condition to the each step when it should
/// be taken.
public final class SwitchAssembly<ViewController: UIViewController, Context> {

    private struct BlockResolver<C>: StepCaseResolver {

        let resolverBlock: ((_: C) -> DestinationStep<ViewController, Context>?)

        init(resolverBlock: @escaping ((_: C) -> DestinationStep<ViewController, Context>?)) {
            self.resolverBlock = resolverBlock
        }

        func resolve(with context: Any?) -> RoutingStep? {
            guard let typedDestination = context as? C else {
                return nil
            }
            return resolverBlock(typedDestination)
        }
    }

    private struct FinderStep: RoutingStep, PerformableStep {

        let finder: AnyFinder?

        init<F: Finder>(finder: F) {
            self.finder = FinderBox.box(for: finder)
        }

        func perform(with context: Any?) throws -> StepResult {
            guard let viewController = finder?.findViewController(with: context) else {
                throw RoutingError.message("A view controller is not found.")
            }
            return .success(viewController)
        }
    }

    private struct FinderResolver<ViewController: UIViewController, Context>: StepCaseResolver {

        private let finder: AnyFinder?

        private let step: DestinationStep<ViewController, Context>

        init<F: Finder>(finder: F, step: DestinationStep<ViewController, Context>?) {
            self.step = step ?? DestinationStep(FinderStep(finder: finder))
            self.finder = FinderBox.box(for: finder)
        }

        func resolve<C>(with context: C) -> RoutingStep? {
            return finder?.findViewController(with: context) != nil ? step : nil
        }
    }

    private var resolvers: [StepCaseResolver] = []

    /// Constructor
    public init() {

    }

    /// Adds a block that allows to write a decision case for the `Router` in the block.
    /// Returning nil from the block will mean that it not succeed.
    ///
    /// - Parameter resolverBlock: case resolver block
    public func addCase<C>(_ resolverBlock: @escaping ((_: C) -> DestinationStep<ViewController, Context>?)) -> Self {
        resolvers.append(BlockResolver(resolverBlock: resolverBlock))
        return self
    }

    /// Adds a case when a view controller exist in the stack to make some particular `RoutingStep` then.
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance to find a `UIViewController` in the stack
    ///   - step: The `RoutingStep` to make if the `Finder` been able to find a view controller in the stack. If not provided,
    ///   a `UIViewController` found by the `Finder` will be considered as a view controller to start routing process from
    public func addCase<F: Finder>(when finder: F, do step: DestinationStep<ViewController, Context>) -> Self {
        resolvers.append(FinderResolver(finder: finder, step: step))
        return self
    }

    /// Adds a case when a view controller exist - navigation will start from the resulting view controller.
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance to find a `UIViewController` in the stack
    ///   a `UIViewController` found by the `Finder` will be considered as a view controller to start routing process from
    public func addCase<F: Finder>(when finder: F) -> Self {
        resolvers.append(FinderResolver<ViewController, Context>(finder: finder, step: nil))
        return self
    }

    /// Assembles all the cases in to a `RoutingStep` implementation
    ///
    /// - Returns: instance of a `RoutingStep`
    public func assemble() -> DestinationStep<ViewController, Context> {
        return DestinationStep(SwitcherStep<Context>(resolvers: resolvers))
    }

    /// Assembles all the cases in a `RoutingStep` instance and adds the default implementation what to do
    /// if non of the cases succeed
    ///
    /// - Parameter resolverBlock: default resolver block
    /// - Returns: an instance of RoutingStep
    public func assemble(default resolverBlock: @escaping (() -> DestinationStep<ViewController, Context>)) -> DestinationStep<ViewController, Context> {
        resolvers.append(BlockResolver<Context>(resolverBlock: { _ in
            return resolverBlock()
        }))
        return DestinationStep(SwitcherStep<Context>(resolvers: resolvers))
    }

}
