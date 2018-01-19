//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

class CityArguments: ExampleArguments {

    var analyticParameters: ExampleAnalyticsParameters?

    let cityId: Int?

    init(cityId: Int?, _ analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.analyticParameters = analyticParameters
        self.cityId = cityId
    }
}
