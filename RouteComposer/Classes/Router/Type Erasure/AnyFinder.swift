//
// RouteComposer
// AnyFinder.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

protocol AnyFinder {

    func findViewController(with context: AnyContext) throws -> UIViewController?

}
