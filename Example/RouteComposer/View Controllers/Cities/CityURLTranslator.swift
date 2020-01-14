//
// Created by Eugene Kazaev on 16/01/2018.
//

import Foundation
import RouteComposer
import UIKit

class CityURLTranslator: ExampleURLTranslator {

    func destination(from url: URL) -> AnyDestination? {
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
