//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for Factory protocol
protocol AnyFactory {

    var action: Action { get }

    func prepare(with context: Any?) throws

    func build(with context: Any?) throws -> UIViewController

    /// Receives an array of factories whose view controllers should be merged into current container
    /// factory before it actually builds a container view controller with child view controllers inside.
    ///
    /// - Parameter factories: Array of factories to be handled by container factory.
    /// - Returns: Array of factories that are not supported by this container type. `Router` should decide how to deal with them.
    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory]

}

class FactoryBox<F: Factory>: AnyFactory, CustomStringConvertible {

    static func box(for factory: F?) -> AnyFactory? {
        if let _ = factory as? NilFactory<F.ViewController, F.Context> {
            return nil
        } else if let factory = factory {
            if let _ = factory as? Container {
                return ContainerFactoryBox(factory)
            } else {
                return FactoryBox(factory)
            }
        }
        return nil
    }

    var factory: F

    let action: Action

    fileprivate init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func prepare(with context: Any?) throws {
        guard let typedContext = context as? F.Context else {
            throw RoutingError.message("\(String(describing: factory)) does not accept \(String(describing: context)) as a context.")
        }
        return try factory.prepare(with: typedContext)
    }

    func build(with context: Any?) throws -> UIViewController {
        guard let typedContext = context as? F.Context else {
            throw RoutingError.message("\(String(describing: factory)) does not accept \(String(describing: context)) as a context.")
        }
        return try factory.build(with: typedContext)
    }

    func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
        return factories
    }

    var description: String {
        return String(describing: factory)
    }

}

class ContainerFactoryBox<F: Factory>: FactoryBox<F> {

    override func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
        guard var container = factory as? Container else {
            throw RoutingError.message("Container factory was not implemented properly")
        }
        let children = factories.map({ f -> ChildFactory<F.Context> in ChildFactory<F.Context>(f) })
        let restChildren = container.merge(children)

        guard let factory = container as? F else {
            throw RoutingError.message("Container factory was not implemented properly")
        }
        self.factory = factory
        let restFactories = restChildren.map({ c -> AnyFactory in c.factory })

        return restFactories
    }

}
