//
// RouteComposer
// ExampleUniversalLinksManager.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

// Simplest universal link manager. You can use any library or your own implementation using the similar strategy
// transforming data that is contained in the `URL` into `AnyDestination` instance.
struct ExampleUniversalLinksManager {

    private static var translators: [ExampleURLTranslator] = []

    static func register(translator: ExampleURLTranslator) {
        translators.append(translator)
    }

    static func destination(for url: URL) -> AnyDestination? {
        guard let translator = translators.first(where: { $0.destination(from: url) != nil }) else {
            return nil
        }

        return translator.destination(from: url)
    }

}

extension ExampleUniversalLinksManager {

    static func configure() {
        ExampleUniversalLinksManager.register(translator: ColorURLTranslator())
        ExampleUniversalLinksManager.register(translator: ProductURLTranslator())
        ExampleUniversalLinksManager.register(translator: CityURLTranslator())
    }

}
