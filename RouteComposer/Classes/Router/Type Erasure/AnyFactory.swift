//
// RouteComposer
// AnyFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

protocol AnyFactory {

    var action: AnyAction { get }

    mutating func prepare<Context>(with context: Context) throws

    func build<Context>(with context: Context) throws -> UIViewController

    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory]

}

#endif
