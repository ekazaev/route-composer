//
// RouteComposer
// AnyFactory.swift
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

protocol AnyFactory {

    var action: AnyAction { get }

    mutating func prepare(with context: AnyContext) throws

    func build(with context: AnyContext) throws -> UIViewController

    mutating func scrapeChildren(from factories: [(factory: AnyFactory, context: AnyContext)]) throws -> [(factory: AnyFactory, context: AnyContext)]

}
