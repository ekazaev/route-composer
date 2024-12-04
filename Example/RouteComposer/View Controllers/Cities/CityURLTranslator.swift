//
// RouteComposer
// CityURLTranslator.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

class CityURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> AnyDestination? {
        return nil
//        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
//              let queryItems = urlComponents.queryItems,
//              let cityItem = queryItems.first(where: { $0.name == "city" }),
//              let cityValue = cityItem.value,
//              let cityId = Int(cityValue) else {
//            return nil
//        }
//
//        let cityDestination = CitiesConfiguration.cityDetail(cityId: cityId)
//        return cityDestination.unwrapped()
    }

}
