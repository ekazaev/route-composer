//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

public protocol AnyFinder {

    func findViewController(with context: Any?) -> UIViewController?

}

class FinderBox<F: Finder>: AnyFinder {

    let finder: F

    init(_ finder: F) {
        self.finder = finder
    }

    func findViewController(with context: Any?) -> UIViewController? {
        guard let typedContext = context as? F.C? else {
            print("\(String(describing:finder)) does not accept \(String(describing: context)) as a context.")
            return nil
        }
        return finder.findViewController(with: typedContext)
    }

}