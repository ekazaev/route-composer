//
// Created by Eugene Kazaev on 16/03/2018.
//

import Foundation

/// Assembly that allows you to build a Container Factory with a preset child Factories inside.
///
/// *Example: You want your UITabBarController to be build already with all the tabs populated*
public class CompleteFactoryAssembly<FC: Factory & Container> {

    private var factory: FC

    private var childFactories: [ChildFactory<FC.Context>] = []
    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public init(factory: FC) {
        self.factory = factory
    }

    /// Add factory that is going to be used as a child. Make sure that you use action that compatible with
    /// container factory you use.
    ///
    /// - Parameter childFactory: instance of `Factory`.
    public func with<C: Factory>(_ childFactory: C) -> Self where C.Context == FC.Context {
        guard let factoryBox = FactoryBox.box(for: childFactory) else {
            return self
        }
        childFactories.append(ChildFactory<C.Context>(factoryBox))
        return self
    }

    public func assemble() -> CompleteFactory<FC> {
        return CompleteFactory(factory: factory, childFactories: childFactories)
    }

}
