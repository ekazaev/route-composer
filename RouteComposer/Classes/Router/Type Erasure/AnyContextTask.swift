//
// RouteComposer
// AnyContextTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

@MainActor
protocol AnyContextTask {

    mutating func prepare(with context: AnyContext) throws

    func perform(on viewController: UIViewController, with context: AnyContext) throws

}
