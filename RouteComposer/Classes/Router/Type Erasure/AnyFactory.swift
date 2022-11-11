//
// RouteComposer
// AnyFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

protocol AnyFactory {

    var action: AnyAction { get }

    mutating func prepare(with context: Any?) throws

    func build(with context: Any?) throws -> UIViewController

    mutating func scrapeChildren(from factories: [(factory: AnyFactory, context: Any?)]) throws -> [(factory: AnyFactory, context: Any?)]

}
