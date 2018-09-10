//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for `Finder` protocol
protocol AnyFinder {

    func findViewController(with context: Any?) -> UIViewController?

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

    func findViewController(with context: Any?) -> UIViewController? {
        guard let typedContext = context as? F.Context else {
            return nil
        }
        return finder.findViewController(with: typedContext)
    }

    var description: String {
        return String(describing: finder)
    }

}
