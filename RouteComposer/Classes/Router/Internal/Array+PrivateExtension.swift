//
// Created by Eugene Kazaev on 2019-08-07.
//

#if os(iOS)

import Foundation
import UIKit

extension Array where Element: UIViewController {

    var nonDismissibleViewController: UIViewController? {
        return compactMap {
            $0 as? RoutingInterceptable & UIViewController
        }.first {
            !$0.canBeDismissed
        }
    }

    func uniqueElements() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }

    func isEqual(to array: [UIViewController]) -> Bool {
        guard count == array.count else {
            return false
        }
        return enumerated().first(where: { index, vc in
            return array[index] !== vc
        }) == nil
    }

}

#endif
