//
// Created by Eugene Kazaev on 16/03/2018.
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

    struct AddAction<FC: ContainerFactory>: ContainerAction {

        func perform(with viewController: UIViewController, on existingController: FC.ViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
            assertionFailure("Should never be called")
        }

        func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
            childViewControllers.append(viewController)
        }

    }

    private var factory: FC

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
    public func with<ChildFC: Factory, A: ContainerAction>(_ childFactory: ChildFC, using action: A) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController>
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
    public func with<ChildFC: ContainerFactory, A: ContainerAction>(_ childContainer: ChildFC, using action: A) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController>
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
    public func with<ChildFC: Factory>(_ childFactory: ChildFC) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController> where ChildFC.Context == FC.Context {
        guard let factoryBox = FactoryBox(childFactory, action: ContainerActionBox(AddAction<FC>())) else {
            return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory, childFactories: [], previousChildFactory: nil)
        }
        return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory,
                childFactories: [],
                previousChildFactory: PostponedIntegrationFactory<ChildFC.Context>(for: factoryBox))
    }

    /// Adds a `ContainerFactory` as the last view controller in the stack.
    ///
    /// - Parameters:
    ///   - childFactory: The instance of `ContainerFactory`.
    public func with<ChildFC: ContainerFactory>(_ childContainer: ChildFC) -> CompleteFactoryChainAssembly<FC, ChildFC.ViewController> where ChildFC.Context == FC.Context {
        guard let factoryBox = ContainerFactoryBox(childContainer, action: ContainerActionBox(AddAction<FC>())) else {
            return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory, childFactories: [], previousChildFactory: nil)
        }

        return CompleteFactoryChainAssembly<FC, ChildFC.ViewController>(factory: factory,
                childFactories: [],
                previousChildFactory: PostponedIntegrationFactory<ChildFC.Context>(for: factoryBox))
    }

    /// Assembles all the children factories provided and returns a `ContainerFactory` instance.
    ///
    /// - Returns: The `CompleteFactory` with child factories provided.
    public func assemble() -> CompleteFactory<FC> {
        return CompleteFactory<FC>(factory: factory, childFactories: [])
    }

}
