//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import DeepLinkLibrary

class ExampleDestination: RoutingDestination {

    let finalStep: RoutingStep

    let context: Any?

    var analyticParameters: ExampleAnalyticsParameters?

    init(finalStep: RoutingStep, context: Any? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.finalStep = finalStep
        self.context = context
        self.analyticParameters = analyticParameters
    }

}
