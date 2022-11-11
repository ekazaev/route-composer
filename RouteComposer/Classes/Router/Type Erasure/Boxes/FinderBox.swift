//
// RouteComposer
// FinderBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

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
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: F.Context.self,
                                            .init("\(String(describing: F.self)) does not accept \(String(describing: context.self)) as a context."))
        }
        return try finder.findViewController(with: typedContext)
    }

    var description: String {
        String(describing: finder)
    }

}
