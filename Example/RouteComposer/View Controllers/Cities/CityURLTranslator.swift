//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

class CityURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> ExampleDestination<UIViewController, Any?>? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = urlComponents.queryItems,
              let cityItem = queryItems.first(where: { $0.name == "city" }),
              let cityValue = cityItem.value,
              let cityId = Int(cityValue) else {
            return nil
        }

        let cityDestination = CitiesConfiguration.cityDetail(cityId: cityId)
        return cityDestination.unwrapped()
    }

}
