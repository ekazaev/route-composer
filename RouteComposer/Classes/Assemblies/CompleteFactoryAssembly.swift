//
// Created by Eugene Kazaev on 16/03/2018.
//

import Foundation

/// Assembly that allows you to build a `Container` `Factory` with a preset child `UIViewController` factories.
///
/// *Example: You want your `UITabBarController` instance to be built by this `Factory`
/// with all the `UIViewController`s populated into each tab*
public class CompleteFactoryAssembly<FC: Factory & Container> {

    private var factory: FC

    private var childFactories: [ChildFactory<FC.Context>] = []

    /// Constructor
    ///
    /// - Parameters:
    ///   - factory: The `UIViewController` `Container` `Factory` instance.
    public init(factory: FC) {
        self.factory = factory
    }

    /// Adds `Factory` that is going to be used as a child. Make sure that you use an `Action` that is compatible with
    /// the `Container` `Factory` you use.
    ///
    /// - Parameter childFactory: The instance of `Factory`.
    public func with<C: Factory>(_ childFactory: C) -> Self where C.Context == FC.Context {
        guard let factoryBox = FactoryBox.box(for: childFactory) else {
            return self
        }
        childFactories.append(ChildFactory<C.Context>(factoryBox))
        return self
    }

    /// Assembles all the child factories provided and returns a `Container` `Factory` instance.
    ///
    /// - Returns: The `CompleteFactory` with child factories provided.
    public func assemble() -> CompleteFactory<FC> {
        var completeFactory = CompleteFactory(factory: factory, childFactories: childFactories)
        let _ = completeFactory.merge(Array<ChildFactory<FC.Context>>())
        return completeFactory
    }

}
