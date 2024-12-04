//
// RouteComposer
// FinderBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
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

    func findViewController(with context: AnyContext) throws -> UIViewController? {
        let typedContext: F.Context = try context.value()
        return try finder.findViewController(with: typedContext)
    }

    var description: String {
        String(describing: finder)
    }

}
