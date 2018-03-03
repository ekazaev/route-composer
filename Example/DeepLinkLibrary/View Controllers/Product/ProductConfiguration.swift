//
// Created by Eugene Kazaev on 20/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary
import UIKit

class ProductContext: ExampleContext {

    var analyticParameters: ExampleAnalyticsParameters?

    let productId: String?

    init(productId: String?, _ analyticParameters: ExampleAnalyticsParameters? = nil) {
        self.analyticParameters = analyticParameters
        self.productId = productId
    }

}

class ProductConfiguration {

    static func productDestination(productId: String, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        let productScreen = ScreenStepAssembly(
                finder: ViewControllerClassWithContextFinder<ProductViewController, ProductContext>(),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "ProductViewController", action: PushAction()))
                .add(ProductContentTask())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(SwitcherStepAssembly()
                        .addCase { context in
                            // If routing requested by Universal Link - Presenting modally
                            // Try in Mobile Safari dll://productView?product=123
                            guard let context = context as? ExampleContext, context.analyticParameters?.webpageURL != nil else {
                                return nil
                            }

                            return StepChainAssembly(from: NavigationContainerStep(action: PresentModallyAction()))
                                    .from(TopMostViewControllerStep())
                                    .assemble()

                        }
                        // If UINavigationController exists on current level - just push
                        .addCase(when: ViewControllerClassFinder<UINavigationController, Any>(policy: .currentLevel))
                        .assemble(default: {
                            // Otherwise - presenting in Circle Tab
                            return ExampleConfiguration.step(for: ExampleTarget.circle)!
                        })
                ).assemble()


        return ExampleDestination(finalStep: productScreen, context: ProductContext(productId: productId, analyticParameters))
    }

}
