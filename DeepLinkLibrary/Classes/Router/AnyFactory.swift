//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

public protocol AnyFactory: class {

    var action: Action { get }

    func prepare(with context: Any?) -> FactoryPreparationResult

    func build(with context: Any?) -> FactoryBuildResult

}

class FactoryBox<F:Factory>:AnyFactory {

    let factory: F

    let action: Action

    init(_ factory: F) {
        self.factory = factory
        self.action = factory.action
    }

    func prepare(with context: Any?) -> FactoryPreparationResult {
        guard let typedContext = context as? F.Context? else {
            return .failure("\(String(describing:factory)) does not accept \(String(describing: context)) as a context.")
        }
        return factory.prepare(with: typedContext)
    }

    func build(with context: Any?) -> FactoryBuildResult {
        guard let typedContext = context as? F.Context? else {
            return .failure("\(String(describing:factory)) does not accept \(String(describing: context)) as a context.")
        }
        return factory.build(with: typedContext)
    }
}
