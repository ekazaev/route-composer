//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for `Finder` protocol
protocol AnyFinder {

    func findViewController(with context: Any?) throws -> UIViewController?

}

struct FinderBox<F: Finder>: AnyFinder, CustomStringConvertible {

    let finder: F

    init?(_ finder: F) {
        guard !(finder is NilEntity) else {
            return nil
        }
        self.finder = finder
    }

    func findViewController(with context: Any?) throws -> UIViewController? {
        guard let typedContext = Any?.some(context as Any) as? F.Context else {
            throw RoutingError.typeMismatch(F.Context.self, RoutingError.Context(debugDescription: "\(String(describing: F.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }
        return finder.findViewController(with: typedContext)
    }

    var description: String {
        return String(describing: finder)
    }

}
