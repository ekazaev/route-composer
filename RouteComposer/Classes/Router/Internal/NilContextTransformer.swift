//
// RouteComposer
// NilContextTransformer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

struct NilContextTransformer<Context>: ContextTransformer {
    func transform(_ context: Context) throws -> Context {
        return context
    }
}
