//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public protocol SingleActionContainerFactory: Factory, Container {

    associatedtype SupportedAction

    var factories: [AnyFactory] { get set }

}

public extension SingleActionContainerFactory {

    public func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        var otherFactories: [AnyFactory] = []
        self.factories = factories.filter { factory in
            guard let _ = factory.action as? SupportedAction else {
                otherFactories.append(factory)
                return false
            }
            return true
        }

        return otherFactories
    }

}