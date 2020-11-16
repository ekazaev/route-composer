//
// RouteComposer
// ColorURLTranslator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import UIKit

class ColorURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> AnyDestination? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = urlComponents.queryItems,
            let colorItem = queryItems.first(where: { $0.name == "color" }),
            let colorValue = colorItem.value else {
                return nil
        }

        return Destination(to: ConfigurationHolder.configuration.colorScreen, with: colorValue).unwrapped()
    }

}
