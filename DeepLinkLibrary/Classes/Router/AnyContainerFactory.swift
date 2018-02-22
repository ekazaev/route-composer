//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

public protocol AnyContainerFactory {

    func merge(_ factories: [AnyFactory]) -> [AnyFactory]

}

class ContainerFactoryBox<F: Factory&ContainerFactory>: AnyFactory, AnyContainerFactory {

    let factory: F
    let action: Action

    init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func merge(_ factories: [AnyFactory]) -> [AnyFactory] {
        return factory.merge(factories)
    }

    func prepare(with context: Any?) -> FactoryPreparationResult {
        guard let typedContext = context as? F.Context? else {
            return .failure("\(String(describing:factory)) does not accept \(String(describing: context)) as a context.")
        }
        return factory.prepare(with: typedContext)
    }

    func build() -> FactoryBuildResult {
        return factory.build()
    }
}


