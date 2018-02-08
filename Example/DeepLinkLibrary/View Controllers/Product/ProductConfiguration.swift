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
        let productScreen = ScreenStepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory(action: PushAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(SmartStepAssembly()
                        .addCase { arguments in
                            // If routing requested by Universal Link - Presenting modally
                            // Try in Mobile Safari dll://productView?product=123
                            guard let arguments = arguments as? ExampleArguments, arguments.analyticParameters?.webpageURL != nil else {
                                return nil
                            }

                            return StepChainAssembly(from: NavigationContainerStep(action: PresentModallyAction()))
                                    .from(TopMostViewControllerStep())
                                    .assemble()

                        }
                        // If UINavigationController exists on current level - just push
                        .addCase(when: ViewControllerClassFinder(classType: UINavigationController.self, policy: .currentLevel))
                        .addCase { _ in
                            // Otherwise - presenting in Circle Tab
                            return ExampleConfiguration.step(for: ExampleTarget.circle)!
                        }.assemble()
                ).assemble()


        return ExampleDestination(finalStep: productScreen, arguments: ProductArguments(productId: productId, analyticParameters))
    }
}
