//
// RouteComposer
// Array+PrivateExtension.swift
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

extension Array where Element: UIViewController {

    var nonDismissibleViewController: UIViewController? {
        compactMap {
            $0 as? RoutingInterceptable & UIViewController
        }.first {
            !$0.canBeDismissed
        }
    }

    func uniqueElements() -> [Element] {
        reduce(into: [Element]()) {
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
            array[index] !== vc
        }) == nil
    }

}
