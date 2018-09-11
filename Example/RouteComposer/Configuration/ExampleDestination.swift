//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

class ExampleDestination {

    let finalStep: RoutingStep

    let context: Any?

    var analyticParameters: ExampleAnalyticsParameters?

    init(finalStep: RoutingStep, context: Any? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.finalStep = finalStep
        self.context = context
        self.analyticParameters = analyticParameters
    }

}
