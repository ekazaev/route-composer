//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

class MainAppProductContext: ExampleContext, ProductArrayContext, CategoriesContext {

    var analyticParameters: ExampleAnalyticsParameters?

    let categoryId: String

    init(categoryId: String, _ analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.analyticParameters = analyticParameters
        self.categoryId = categoryId
    }
}