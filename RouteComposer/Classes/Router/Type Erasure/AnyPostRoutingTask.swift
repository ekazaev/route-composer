//
// RouteComposer
// AnyPostRoutingTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

@MainActor
protocol AnyPostRoutingTask {

    func perform(on viewController: UIViewController,
                 with context: AnyContext,
                 routingStack: [UIViewController]) throws

}
