//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

class CityURLTranslator: ExampleURLTranslator {

    func arguments(from url: URL) -> ExampleTargetArguments? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let cityItem = queryItems.first(where: { $0.name == "city" }),
              let cityValue = cityItem.value,
              let cityId = Int(cityValue) else {
            return nil
        }

        return ExampleTargetArguments(originalUrl: url, arguments: [Argument.cityId: cityId])
    }

}
