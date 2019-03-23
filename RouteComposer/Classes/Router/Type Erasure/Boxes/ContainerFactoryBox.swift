//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

struct ContainerFactoryBox<F: ContainerFactory>: PreparableAnyFactory, AnyFactoryBox, MainThreadChecking, CustomStringConvertible {

    typealias FactoryType = F

    var factory: FactoryType

    let action: AnyAction

    var children: [DelayedIntegrationFactory<FactoryType.Context>] = []

    var isPrepared = false

    init?(_ factory: FactoryType, action: AnyAction) {
        guard !(factory is NilEntity) else {
            return nil
        }
        self.factory = factory
        self.action = action
    }

    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
        var otherFactories: [AnyFactory] = []
        var isNonEmbeddableFound = false
        self.children = factories.compactMap({ child -> DelayedIntegrationFactory<FactoryType.Context>? in
            guard !isNonEmbeddableFound, child.action.isEmbeddable(to: FactoryType.ViewController.self) else {
                otherFactories.append(child)
                isNonEmbeddableFound = true
                return nil
            }
            return DelayedIntegrationFactory(child)
        })
        return otherFactories
    }

    func build(with context: Any?) throws -> UIViewController {
        guard let typedContext = Any?.some(context as Any) as? FactoryType.Context else {
            throw RoutingError.typeMismatch(FactoryType.Context.self, .init("\(String(describing: factory.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        assertIfNotPrepared()
        return try factory.build(with: typedContext, integrating: ChildCoordinator(childFactories: children))
    }

}
