//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Builds a `DestinationStep` which can contain the conditions to select the steps to be taken by a `Router`.
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
                throw RoutingError.generic(RoutingError.Context(debugDescription: "A view controller was not found."))
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

    /// Adds a block that allows a written decision case for the `Router` in the block.
    /// Returning nil from the block will mean that it has not succeeded.
    ///
    /// - Parameter resolverBlock: case resolver block
    public func addCase<C>(_ resolverBlock: @escaping ((_: C) -> DestinationStep<ViewController, Context>?)) -> Self {
        resolvers.append(BlockResolver(resolverBlock: resolverBlock))
        return self
    }

    /// Adds a case when a view controller exists in the stack in order to make a particular `DestinationStep`.
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance searches for a `UIViewController` in the stack
    ///   - step: The `DestinationStep` is to perform if the `Finder` has been able to find a view controller in the stack. If not provided,
    ///   a `UIViewController` found by the `Finder` will be considered as a view controller to start the navigation process from
    public func addCase<F: Finder>(when finder: F, do step: DestinationStep<ViewController, Context>) -> Self {
        resolvers.append(FinderResolver(finder: finder, step: step))
        return self
    }

    /// Adds a case when a view controller exists - navigation will start from the resulting view controller.
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance is to find a `UIViewController` in the stack
    ///   a `UIViewController` found by the `Finder` will be considered as a view controller to start the navigation process from
    public func addCase<F: Finder>(when finder: F) -> Self {
        resolvers.append(FinderResolver<ViewController, Context>(finder: finder, step: nil))
        return self
    }

    /// Assembles all the cases into a `DestinationStep` implementation
    ///
    /// - Returns: instance of a `DestinationStep`
    public func assemble() -> DestinationStep<ViewController, Context> {
        return DestinationStep(SwitcherStep<Context>(resolvers: resolvers))
    }

    /// Assembles all the cases in a `DestinationStep` instance and adds the default implementation, providing the step it is to perform
    ///
    /// - Parameter resolverBlock: default resolver block
    /// - Returns: an instance of `DestinationStep`
    public func assemble(default resolverBlock: @escaping (() -> DestinationStep<ViewController, Context>)) -> DestinationStep<ViewController, Context> {
        resolvers.append(BlockResolver<Context>(resolverBlock: { _ in
            return resolverBlock()
        }))
        return DestinationStep(SwitcherStep<Context>(resolvers: resolvers))
    }

}
