//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation

public protocol MergingContainerFactory: ContainerFactory {

    associatedtype ActionType

    var factories: [AnyFactory] { get set }

}

public extension MergingContainerFactory {

    public func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        var otherFactories: [AnyFactory] = []
        self.factories = factories.filter { factory in
            guard let _ = factory.action as? ActionType else {
                otherFactories.append(factory)
                return false
            }
            return true
        }

        return otherFactories
    }

}