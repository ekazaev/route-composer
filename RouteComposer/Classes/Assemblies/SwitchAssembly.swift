//
// RouteComposer
// SwitchAssembly.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// Builds a `DestinationStep` which can contain the conditions to select the steps to be taken by a `Router`.
/// ### Usage
/// ```swift
///        let containerStep = SwitchAssembly<UINavigationController, ProductContext>()
///                .addCase { (context: ProductContext) in
///                    // If this configuration is requested by a Universal Link (productURL != nil), skip this case otherwise.
///                    guard context.productURL != nil else {
///                        return nil
///                    }
///
///                    return ChainAssembly.from(NavigationControllerStep<UINavigationController, ProductContext>())
///                            .using(GeneralAction.presentModally())
///                            .from(GeneralStep.current())
///                            .assemble()
///
///                }
///
///                // If UINavigationController is visible on the screen - use it
///                .addCase(from: ClassFinder<UINavigationController, ProductContext>(options: .currentVisibleOnly))
///
///                // Otherwise - create a UINavigationController and present modally
///                .assemble(default: ChainAssembly.from(NavigationControllerStep<UINavigationController, ProductContext>())
///                    .using(GeneralAction.presentModally())
///                    .from(GeneralStep.current())
///                    .assemble())
/// ```
public final class SwitchAssembly<ViewController: UIViewController, Context> {

    // MARK: Internal entities

    private struct BlockResolver: StepCaseResolver {

        let resolverBlock: (_: Context) -> DestinationStep<ViewController, Context>?

        init(resolverBlock: @escaping (_: Context) -> DestinationStep<ViewController, Context>?) {
            self.resolverBlock = resolverBlock
        }

        func resolve(with context: AnyContext) -> RoutingStep? {
            guard let typedContext = try? context.value() as Context else {
                return nil
            }
            return resolverBlock(typedContext)
        }
    }

    private struct FinderResolver<ViewController: UIViewController, Context>: StepCaseResolver {

        private let finder: AnyFinder?

        private let step: DestinationStep<ViewController, Context>

        init(finder: some Finder, step: DestinationStep<ViewController, Context>?) {
            self.step = step ?? DestinationStep(GeneralStep.FinderStep(finder: finder))
            self.finder = FinderBox(finder)
        }

        func resolve(with context: AnyContext) -> RoutingStep? {
            guard (try? finder?.findViewController(with: context)) != nil else {
                return nil
            }
            return step
        }
    }

    // MARK: Properties

    private var resolvers: [StepCaseResolver] = []

    // MARK: Methods

    /// Constructor
    public init() {}

    /// Adds a block that allows a written decision case for the `Router` in the block.
    /// Returning nil from the block will mean that it has not succeeded.
    ///
    /// - Parameter resolverBlock: case resolver block
    public final func addCase(_ resolverBlock: @escaping (_: Context) -> DestinationStep<ViewController, Context>?) -> Self {
        resolvers.append(BlockResolver(resolverBlock: resolverBlock))
        return self
    }

    /// Adds a case when a view controller exists in the stack in order to make a particular `DestinationStep`.
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance searches for a `UIViewController` in the stack
    ///   - step: The `DestinationStep` is to perform if the `Finder` has been able to find a view controller in the stack. If not provided,
    ///   a `UIViewController` found by the `Finder` will be considered as a view controller to start the navigation process from
    public final func addCase<F: Finder>(when finder: F, from step: DestinationStep<ViewController, Context>) -> Self where F.Context == Context {
        resolvers.append(FinderResolver(finder: finder, step: step))
        return self
    }

    /// Adds a case when a certain condition is valid to use a particular `DestinationStep`.
    ///
    /// - Parameters:
    ///   - condition: A condition to use the provided step.
    ///   - step: The `DestinationStep` is to perform.
    public final func addCase(when condition: @autoclosure @escaping () -> Bool, from step: DestinationStep<ViewController, Context>) -> Self {
        resolvers.append(BlockResolver(resolverBlock: { _ in
            guard condition() else {
                return nil
            }
            return step
        }))
        return self
    }

    /// Adds a case when a certain condition is valid to use a particular `DestinationStep`.
    ///
    /// - Parameters:
    ///   - conditionBlock: A condition to use the provided step.
    ///   - step: The `DestinationStep` is to perform.
    public final func addCase(when conditionBlock: @escaping (Context) -> Bool, from step: DestinationStep<ViewController, Context>) -> Self {
        resolvers.append(BlockResolver(resolverBlock: { context in
            guard conditionBlock(context) else {
                return nil
            }
            return step
        }))
        return self
    }

    /// Adds a case when a view controller exists - navigation will start from the resulting view controller.
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance is to find a `UIViewController` in the stack
    ///   a `UIViewController` found by the `Finder` will be considered as a view controller to start the navigation process from
    public final func addCase<F: Finder>(from finder: F) -> Self where F.ViewController == ViewController, F.Context == Context {
        resolvers.append(FinderResolver<ViewController, Context>(finder: finder, step: nil))
        return self
    }

    /// Assembles all the cases into a `DestinationStep` implementation
    ///
    /// - Returns: instance of a `DestinationStep`
    public final func assemble() -> DestinationStep<ViewController, Context> {
        DestinationStep(SwitcherStep(resolvers: resolvers))
    }

    /// Assembles all the cases in a `DestinationStep` instance and adds the default implementation, providing the step it is to perform
    ///
    /// - Parameter resolverBlock: default resolver block
    /// - Returns: an instance of `DestinationStep`
    public final func assemble(default resolverBlock: @escaping () -> DestinationStep<ViewController, Context>) -> DestinationStep<ViewController, Context> {
        resolvers.append(BlockResolver(resolverBlock: { _ in
            resolverBlock()
        }))
        return DestinationStep(SwitcherStep(resolvers: resolvers))
    }

    /// Assembles all the cases in a `DestinationStep` instance and adds the default implementation, providing the step it is to perform
    ///
    /// - Parameter step: an instance of `DestinationStep`
    /// - Returns: a final instance of `DestinationStep`
    public final func assemble(default step: DestinationStep<ViewController, Context>) -> DestinationStep<ViewController, Context> {
        resolvers.append(BlockResolver(resolverBlock: { _ in
            step
        }))
        return DestinationStep(SwitcherStep(resolvers: resolvers))
    }

}

// MARK: Methods for ContainerViewController

public extension SwitchAssembly where ViewController: ContainerViewController {

    /// Adds a case when a view controller exists - navigation will start from the resulting view controller.
    /// This method allows to avoid view controller type check.
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance is to find a `UIViewController` in the stack
    ///   a `UIViewController` found by the `Finder` will be considered as a view controller to start the navigation process from
    final func addCase<F: Finder>(expecting finder: F) -> Self where F.Context == Context {
        resolvers.append(FinderResolver<ViewController, Context>(finder: finder, step: nil))
        return self
    }

}
