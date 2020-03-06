//
// RouteComposer
// EmptyContainer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
@testable import RouteComposer
import UIKit

struct EmptyContainer: SimpleContainerFactory {

    typealias ViewController = UINavigationController

    typealias Context = Any?

    init() {}

    func build(with context: Any?, integrating viewControllers: [UIViewController]) throws -> UINavigationController {
        let viewController = UINavigationController()
        viewController.viewControllers = viewControllers
        return viewController
    }

}

#endif
