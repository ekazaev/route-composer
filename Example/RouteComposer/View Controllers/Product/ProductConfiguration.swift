//
// Created by Eugene Kazaev on 20/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit

class ProductConfiguration {

    static func productDestination(productId: String, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        let productScreen = StepAssembly(
                finder: ClassWithContextFinder<ProductViewController, String>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "ProductViewController", action: NavigationControllerFactory.PushToNavigation()))
                .add(ProductContextTask())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(SwitchAssembly()
                        .addCase { (destination: ExampleDestination) in
                            // If routing requested by Universal Link - Presenting modally
                            // Try in Mobile Safari dll://productView?product=123
                            guard destination.analyticParameters?.webpageURL != nil else {
                                return nil
                            }

                            return ChainAssembly()
                                    .from(NavigationControllerStep(action: GeneralAction.PresentModally()))
                                    .from(CurrentViewControllerStep())
                                    .assemble()

                        }
                        // If UINavigationController exists on current level - just push
                        .addCase(when: ClassFinder<UINavigationController, Any>(options: .currentAllStack))
                        .assemble(default: {
                            // Otherwise - presenting in Circle Tab
                            return ExampleConfiguration.step(for: ExampleTarget.circle)!
                        })
                ).assemble()

        return ExampleDestination(finalStep: productScreen, context: productId, analyticParameters)
    }

}
