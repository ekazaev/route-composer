//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation

//class CityURLTranslator: ExampleURLTranslator {
//
//    func destination(from url: URL) -> ExampleDestination? {
//        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
//              let queryItems = urlComponents.queryItems,
//              let cityItem = queryItems.first(where: { $0.name == "city" }),
//              let cityValue = cityItem.value,
//              let cityId = Int(cityValue) else {
//            return nil
//        }
//
//        let cityDestination = CitiesConfiguration.cityDetail(cityId: cityId, ExampleAnalyticsParameters(source: .appLink, webpageURL: url, referrerURL: nil))
//        return cityDestination
//    }
//
//}
