//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non typesafe boxing wrapper for `Finder` protocol
protocol AnyFinder {

    func findViewController(with context: Any?) -> UIViewController?

}

class FinderBox<F: Finder>: AnyFinder, CustomStringConvertible {

    static func box(for finder: F?) -> AnyFinder? {
        if let _ = finder as? NilFinder<F.ViewController, F.Context> {
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
