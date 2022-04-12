//
// RouteComposer
// CompleteFactoryAssembly.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

/// Builds a `ContainerFactory` fulfilled with the children `UIViewController` factories.
///
/// ```swift
/// let rootFactory = CompleteFactoryAssembly(factory: TabBarFactory())
///         .with(XibFactory<HomeViewController, Any?>, using: UITabBarController.add())
///         .with(XibFactory<AccountViewController, Any?>, using: UITabBarController.add())
///         .assemble()
/// ```
/// *NB: Order matters here*
public final class CompleteFactoryAssembly<FC: ContainerFactory> {

    // MARK: Internal entities

    struct SimpleAddAction<FC: ContainerFactory>: ContainerAction {

        func perform(with viewController: UIViewController, on existingController: FC.ViewController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
            assertionFailure("Should never be called")
            completion(.success)
        }

        func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
            childViewControllers.append(viewController)
        }

    }

    // MARK: Properties

    private final var factory: FC

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - factory: The `ContainerFactory` instance.
    public init(factory: FC) {
        self.factory = factory
    }

    /// Adds a `Factory` that is going to be used as a child
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `Factory`.
    ///   - action: The instance of `Factory` to be used to integrate the view controller produced by the factory.
    public final func with<ChildFC: Factory, A: ContainerAction>(_ childFactory: ChildFC, using action: A) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController>
        where
        ChildFC.Context == FC.Context, A.ViewController == FC.ViewController {
        guard let factoryBox = FactoryBox(childFactory, action: ContainerActionBox(action)) else {
            return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory, childFactories: [], previousChildFactory: nil)
        }
        return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory,
                                                                        childFactories: [],
                                                                        previousChildFactory: PostponedIntegrationFactory<ChildFC.Context>(for: factoryBox))
    }

    /// Adds a `ContainerFactory` that is going to be used as a child
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `ContainerFactory`.
    ///   - action: The instance of `ContainerFactory` to be used to integrate the view controller produced by the factory.
    public final func with<ChildFC: ContainerFactory, A: ContainerAction>(_ childContainer: ChildFC, using action: A) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController>
        where
        ChildFC.Context == FC.Context, A.ViewController == FC.ViewController {
        guard let factoryBox = ContainerFactoryBox(childContainer, action: ContainerActionBox(action)) else {
            return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory, childFactories: [], previousChildFactory: nil)
        }

        return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory,
                                                                        childFactories: [],
                                                                        previousChildFactory: PostponedIntegrationFactory<ChildFC.Context>(for: factoryBox))
    }

    /// Adds a `Factory` as the last view controller in the stack.
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `Factory`.
    public final func with<ChildFC: Factory>(_ childFactory: ChildFC) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController> where ChildFC.Context == FC.Context {
        return with(childFactory, using: SimpleAddAction<FC>())
    }

    /// Adds a `ContainerFactory` as the last view controller in the stack.
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `ContainerFactory`.
    public final func with<ChildFC: ContainerFactory>(_ childContainer: ChildFC) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController> where ChildFC.Context == FC.Context {
        return with(childContainer, using: SimpleAddAction<FC>())
    }

    /// Assembles all the children factories provided and returns a `ContainerFactory` instance.
    ///
    /// - Returns: The `CompleteFactory` with child factories provided.
    public final func assemble() -> CompleteFactory<FC> {
        CompleteFactory<FC>(factory: factory, childFactories: [])
    }

}
