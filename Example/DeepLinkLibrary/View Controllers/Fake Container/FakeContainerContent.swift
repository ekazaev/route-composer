//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

class FakeContainerArguments: ExampleArguments {

    var analyticParameters: ExampleAnalyticsParameters?

    var content: FakeContainerContent

    init(content: FakeContainerContent, analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.content = content
        self.analyticParameters = analyticParameters
    }

}

enum FakeContainerContent: Int {
    case favorites = 0
    case collections
}

struct FakeContainerDataModel {

    static let data = [
        FakeContainerContent.favorites: ["Gucci", "Dolce & Gabbana", "Anna Valentine", "Lacoste"],
        .collections: ["Shoes", "Dresses", "Hats"]
    ]

}