//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non typesafe boxing wrapper for Factory protocol
public protocol AnyFactory: class {

    var action: Action { get }

    func prepare(with context: Any?) throws

    func build(with context: Any?) throws -> UIViewController

    func scrapeChildren(from factories: [AnyFactory]) -> [AnyFactory]
}

class FactoryBox<F:Factory>:AnyFactory, CustomStringConvertible {

    let factory: F

    let action: Action

    init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func prepare(with context: Any?) throws {
        guard let typedContext = context as? F.Context? else {
            throw RoutingError.message("\(String(describing:factory)) does not accept \(String(describing: context)) as a context.")
        }
        return try factory.prepare(with: typedContext)
    }

    func build(with context: Any?) throws -> UIViewController {
        guard let typedContext = context as? F.Context? else {
            throw RoutingError.message("\(String(describing:factory)) does not accept \(String(describing: context)) as a context.")
        }
        return try factory.build(with: typedContext)
    }

    func scrapeChildren(from factories: [AnyFactory]) -> [AnyFactory] {
        return factories
    }

    var description: String {
        return String(describing: factory)
    }

}

class ContainerFactoryBox<F: Factory>: FactoryBox<F>, AnyContainer {

    func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        guard let container = factory as? Container else {
            return factories
        }
        return container.merge(factories)
    }

    override func scrapeChildren(from factories: [AnyFactory]) -> [AnyFactory] {
        guard let container = factory as? Container else {
            return factories
        }
        return container.merge(factories)
    }

}
