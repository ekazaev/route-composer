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

    static func box(for finder: F?) -> AnyFinder? {
        if finder is NilEntity {
            return nil
        } else if let finder = finder {
            return FinderBox(finder)
        }
        return nil
    }

    let finder: F

    fileprivate init(_ finder: F) {
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
