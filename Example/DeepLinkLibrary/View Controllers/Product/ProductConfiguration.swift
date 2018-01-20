//
// Created by Eugene Kazaev on 20/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

class ProductArguments: ExampleArguments {

    var analyticParameters: ExampleAnalyticsParameters?

    let productId: String?

    init(productId: String?, _ analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.analyticParameters = analyticParameters
        self.productId = productId
    }
}

class ProductConfiguration {

    static func productDestination(productId: String, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        let productScreen = Screen(
                finder: ProductViewControllerFinder(),
                factory: ProductViewControllerFactory(action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireScreenStep(screen: ExampleConfiguration.screen(for: ExampleSource.circle)!)
                ]))

        return ExampleDestination(screen: productScreen, arguments: ProductArguments(productId: productId, analyticParameters))
    }
}
