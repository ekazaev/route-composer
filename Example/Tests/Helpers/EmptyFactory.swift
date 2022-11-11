//
// RouteComposer
// EmptyFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
@testable import RouteComposer
import UIKit

struct EmptyFactory: Factory {

    init() {}

    func build(with context: Any?) throws -> UIViewController {
        UIViewController()
    }

}
