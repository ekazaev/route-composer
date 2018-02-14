//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit


protocol AnyFinder {

    func findViewController(with arguments: Any?) -> UIViewController?

}

class FinderBox<F: Finder>: AnyFinder {

    let finder: F

    init(_ finder: F) {
        self.finder = finder
    }

    func findViewController(with arguments: Any?) -> UIViewController? {
        guard let typedArguments = arguments as? F.A? else {
            print("\(String(describing:finder)) does not accept \(String(describing: arguments)) as a parameter.")
            return nil
        }
        return finder.findViewController(with: typedArguments)
    }

}