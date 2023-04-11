//
// RouteComposer
// CompleteFactoryChainAssembly.swift
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

/// Builds the chain of assemblies to fulfill the `ContainerFactory`.
public final class CompleteFactoryChainAssembly<FC: ContainerFactory, ChildVC: UIViewController, ChildContext> {

    // MARK: Properties

    private var factory: FC

    private let childFactories: [PostponedIntegrationFactory]

    private let previousChildFactory: PostponedIntegrationFactory?

    private var integratedChildFactories: [PostponedIntegrationFactory] {
        var childFactories = childFactories
        if let previousChildFactory {
            childFactories.append(previousChildFactory)
        }
        return childFactories
    }

    // MARK: Methods

    init(factory: FC, childFactories: [PostponedIntegrationFactory], previousChildFactory: PostponedIntegrationFactory?) {
        self.factory = factory
        self.childFactories = childFactories
        self.previousChildFactory = previousChildFactory
    }

    /// Adds a `Factory` that is going to be used as a child
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `Factory`.
    ///   - action: The instance of `Factory` to be used to integrate the view controller produced by the factory.
    public final func with<ChildFC: Factory, A: ContainerAction, T: ContextTransformer>(_ childFactory: ChildFC, using action: A, adapting transformer: T) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>
        where
        T.TargetContext == ChildFC.Context, T.SourceContext == FC.Context, A.ViewController == FC.ViewController {
        guard let factoryBox = FactoryBox(childFactory, action: ContainerActionBox(action)) else {
            return CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>(factory: factory, childFactories: integratedChildFactories, previousChildFactory: nil)
        }
        return CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>(factory: factory,
                                                                                         childFactories: integratedChildFactories,
                                                                                         previousChildFactory: PostponedIntegrationFactory(for: factoryBox, transformer: ContextTransformerBox(transformer)))
    }

    /// Adds a `ContainerFactory` that is going to be used as a child
    ///
    /// - Parameters:
    ///   - childContainer: The instance of `ContainerFactory`.
    ///   - action: The instance of `ContainerFactory` to be used to integrate the view controller produced by the factory.
    public final func with<ChildFC: ContainerFactory, A: ContainerAction, T: ContextTransformer>(_ childContainer: ChildFC, using action: A, adapting transformer: T) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>
        where
        T.TargetContext == ChildFC.Context, T.SourceContext == FC.Context, A.ViewController == FC.ViewController {
        guard let factoryBox = ContainerFactoryBox(childContainer, action: ContainerActionBox(action)) else {
            return CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>(factory: factory, childFactories: integratedChildFactories, previousChildFactory: nil)
        }

        return CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>(factory: factory,
                                                                                         childFactories: integratedChildFactories,
                                                                                         previousChildFactory: PostponedIntegrationFactory(for: factoryBox, transformer: ContextTransformerBox(transformer)))
    }

    /// Adds a `Factory` as the last view controller in the stack.
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `Factory`.
    ///   - transformer: The instance of `ContextTransformer` to use to adapt parent `ContainerFactory` `Context`.
    public final func with<ChildFC: Factory, T: ContextTransformer>(_ childFactory: ChildFC, adapting transformer: T) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context> where T.TargetContext == ChildFC.Context, T.SourceContext == FC.Context {
        return with(childFactory, using: CompleteFactoryAssembly<FC>.SimpleAddAction<FC>(), adapting: transformer)
    }

    /// Adds a `ContainerFactory` as the last view controller in the stack.
    ///
    /// - Parameters:
    ///   - childContainer: The instance of `ContainerFactory`.
    ///   - transformer: The instance of `ContextTransformer` to use to adapt parent `ContainerFactory` `Context`.
    public final func with<ChildFC: ContainerFactory, T: ContextTransformer>(_ childContainer: ChildFC, adapting transformer: T) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context> where T.TargetContext == ChildFC.Context, T.SourceContext == FC.Context {
        return with(childContainer, using: CompleteFactoryAssembly<FC>.SimpleAddAction<FC>(), adapting: transformer)
    }

    /// Adds a `Factory` that is going to be used as a child
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `Factory`.
    ///   - action: The instance of `Factory` to be used to integrate the view controller produced by the factory.
    public final func with<ChildFC: Factory, A: ContainerAction>(_ childFactory: ChildFC, using action: A) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>
        where
        ChildFC.Context == FC.Context, A.ViewController == FC.ViewController {
        return with(childFactory, using: action, adapting: NilContextTransformer())
    }

    /// Adds a `ContainerFactory` that is going to be used as a child
    ///
    /// - Parameters:
    ///   - childContainer: The instance of `ContainerFactory`.
    ///   - action: The instance of `ContainerFactory` to be used to integrate the view controller produced by the factory.
    public final func with<ChildFC: ContainerFactory, A: ContainerAction>(_ childContainer: ChildFC, using action: A) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context>
        where
        ChildFC.Context == FC.Context, A.ViewController == FC.ViewController {
        return with(childContainer, using: action, adapting: NilContextTransformer())
    }

    /// Adds a `Factory` as the last view controller in the stack.
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `Factory`.
    public final func with<ChildFC: Factory>(_ childFactory: ChildFC) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context> where ChildFC.Context == FC.Context {
        return with(childFactory, using: CompleteFactoryAssembly<FC>.SimpleAddAction<FC>())
    }

    /// Adds a `ContainerFactory` as the last view controller in the stack.
    ///
    /// - Parameters:
    ///   - childContainer: The instance of `ContainerFactory`.
    public final func with<ChildFC: ContainerFactory>(_ childContainer: ChildFC) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController, ChildFC.Context> where ChildFC.Context == FC.Context {
        return with(childContainer, using: CompleteFactoryAssembly<FC>.SimpleAddAction<FC>())
    }

    /// Applies a `ContextTask` to the child factory after its `UIViewController` been built.
    ///
    /// - Parameters:
    ///   - contextTask: The instance of `ContextTask`.
    public final func adding<CT: ContextTask>(_ contextTask: CT) -> CompleteFactoryChainAssembly<FC, ChildVC, ChildContext> where CT.ViewController == ChildVC, CT.Context == ChildContext {
        guard var previousChildFactory else {
            return CompleteFactoryChainAssembly<FC, ChildVC, ChildContext>(factory: factory, childFactories: childFactories, previousChildFactory: nil)
        }
        previousChildFactory.add(ContextTaskBox(contextTask))
        return CompleteFactoryChainAssembly<FC, ChildVC, ChildContext>(factory: factory,
                                                                       childFactories: childFactories,
                                                                       previousChildFactory: previousChildFactory)
    }

    /// Assembles all the children factories provided and returns a `ContainerFactory` instance.
    ///
    /// - Returns: The `CompleteFactory` with child factories provided.
    public final func assemble() -> CompleteFactory<FC> {
        CompleteFactory<FC>(factory: factory, childFactories: integratedChildFactories)
    }

}
