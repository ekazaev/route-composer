//
// Created by Eugene Kazaev on 20/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary
import UIKit

class ProductConfiguration {

    static func productDestination(productId: String, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        let productScreen = ScreenStepAssembly(
                finder: ViewControllerClassWithContextFinder<ProductViewController, String>(),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "ProductViewController", action: PushToNavigationAction()))
                .add(ProductContentTask())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(SwitcherStepAssembly()
                        .addCase { (destination: ExampleDestination) in
                            // If routing requested by Universal Link - Presenting modally
                            // Try in Mobile Safari dll://productView?product=123
                            guard destination.analyticParameters?.webpageURL != nil else {
                                return nil
                            }

                            return StepChainAssembly(from: NavigationControllerStep(action: PresentModallyAction()))
                                    .from(CurrentViewControllerStep())
                                    .assemble()

                        }
                        // If UINavigationController exists on current level - just push
                        .addCase(when: ViewControllerClassFinder<UINavigationController, Any>(policy: .currentLevel))
                        .assemble(default: {
                            // Otherwise - presenting in Circle Tab
                            return ExampleConfiguration.step(for: ExampleTarget.circle)!
                        })
                ).assemble()


        return ExampleDestination(finalStep: productScreen, context: productId, analyticParameters)
    }

}
