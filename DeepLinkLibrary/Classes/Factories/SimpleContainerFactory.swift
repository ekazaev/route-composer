//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

/// Helper protocol to factory that is also a Container. If it support only one type of actions to build its
/// children UIViewControllers - use this protocol. It contain default merge function implementation.
public protocol SimpleContainerFactory: Factory, Container {

    /// Type of supported Action instances
    associatedtype SupportedAction

    /// Factories that will build children view controllers when it will be needed.
    var factories: [ChildFactory<Context>] { get set }

}

public extension SimpleContainerFactory {

    public func merge<C>(_ factories: [ChildFactory<C>]) -> [ChildFactory<C>] {
        var otherFactories: [ChildFactory<C>] = []
        self.factories = factories.flatMap { factory -> ChildFactory<Context>? in
            guard let _ = factory.action as? SupportedAction else {
                otherFactories.append(factory)
                return nil
            }
            return factory as? ChildFactory<Context>
        }

        return otherFactories
    }

    public func buildChildrenViewControllers(with context: Context) throws -> [UIViewController] {
        return try buildChildrenViewControllers(from: factories, with: context)
    }

}