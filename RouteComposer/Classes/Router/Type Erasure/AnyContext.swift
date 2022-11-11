//
// RouteComposer
// AnyContext.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation

protocol AnyContext {
    func value<Context>() throws -> Context
}
