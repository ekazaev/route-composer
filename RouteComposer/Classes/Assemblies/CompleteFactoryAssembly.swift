//
// Created by Eugene Kazaev on 16/03/2018.
//

import Foundation

/// Builds a `Container` fulfilled with the child `UIViewController` factories.
///
/// *Example: You want your `UITabBarController` instance to be built by this `Factory`
/// with all the `UIViewController`s populated into each tab*
public final class CompleteFactoryAssembly<FC: Container> {

    private var factory: FC

    private var childFactories: [ChildFactory<FC.Context>] = []

    /// Constructor
    ///
    /// - Parameters:
    ///   - factory: The `Container` instance.
    public init(factory: FC) {
        self.factory = factory
    }

    /// Adds a `Factory` that is going to be used as a child. Make sure that you use an `Action` that is compatible with
    /// the `Container` `Factory` you use.
    ///
    /// - Parameter childFactory: The instance of `Factory`.
    public func with<C: Factory>(_ childFactory: C, using action: Action) -> Self where C.Context == FC.Context {
        guard let factoryBox = FactoryBox.box(for: childFactory, action: action) else {
            return self
        }
        childFactories.append(ChildFactory<C.Context>(factoryBox))
        return self
    }

    /// Adds a `Container` that is going to be used as a child. Make sure that you use an `Action` that is compatible with
    /// the `Container` `Factory` you use.
    ///
    /// - Parameter childFactory: The instance of `Factory`.
    public func with<C: Container>(_ childFactory: C, using action: Action) -> Self where C.Context == FC.Context {
        guard let factoryBox = ContainerFactoryBox.box(for: childFactory, action: action) else {
            return self
        }
        childFactories.append(ChildFactory<C.Context>(factoryBox))
        return self
    }

    /// Assembles all the child factories provided and returns a `Container` instance.
    ///
    /// - Returns: The `CompleteFactory` with child factories provided.
    public func assemble() -> CompleteFactory<FC> {
        let completeFactory = CompleteFactory(factory: factory, childFactories: childFactories)
        return completeFactory
    }

}
