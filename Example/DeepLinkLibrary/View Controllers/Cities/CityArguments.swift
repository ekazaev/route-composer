//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

struct CityArguments: ExampleArguments {

    let url: URL?

    let cityId: Int?

    init(url: URL? = nil, cityId: Int?) {
        self.url = url
        self.cityId = cityId
    }
}
