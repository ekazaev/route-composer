//
// RouteComposer
// EmptyFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
@testable import RouteComposer
import UIKit

struct EmptyFactory: Factory {

    init() {}

    func build(with context: Any?) throws -> UIViewController {
        UIViewController()
    }

}

#endif
