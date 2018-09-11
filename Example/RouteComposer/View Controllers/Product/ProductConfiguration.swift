//
// Created by Eugene Kazaev on 20/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit

class ProductConfiguration {

    static func productStep() -> TempStep<String> {
        let productScreen = StepAssembly(
                finder: ClassWithContextFinder<ProductViewController, String>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "ProductViewController"))
                .add(InlineInterceptor({ (_: String) in
                    print("On before navigation to Product view controller")
                }))
                .add(InlineContextTask({ (_: ProductViewController, _: String) in
                    print("Product view controller built or found")
                }))
                .add(InlinePostTask({ (_: ProductViewController, _: String, _) in
                    print("After navigation to Produce view controller")
                }))
                .add(ProductContextTask())
                //                .add(ExampleAnalyticsInterceptor())
                //                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                //                .from(SwitchAssembly()
                //                        .addCase { (destination: ExampleDestination) in
                //                            // If routing requested by Universal Link - Presenting modally
                //                            // Try in Mobile Safari dll://productView?product=123
                //                            guard destination.analyticParameters?.webpageURL != nil else {
                //                                return nil
                //                            }
                //
                //                            return ChainAssembly(from: NavigationControllerStep())
                //                                    .using(GeneralAction.PresentModally())
                //                                    .from(CurrentViewControllerStep())
                //                                    .assemble().lastStep
                //
                //                        }
                //                        // If UINavigationController exists on current level - just push
                //                        .addCase(when: ClassFinder<UINavigationController, Any>(options: .currentAllStack))
                //                        .assemble(default: {
                //                            // Otherwise - presenting in Circle Tab
                //                            return ExampleConfiguration.step(for: ExampleTarget.circle)!
                //                        }))
                .from(SingleStep(finder: ClassFinder<UINavigationController, Any?>(), factory: NilFactory()))
                .using(GeneralAction.PresentModally())
                .from(CurrentViewControllerStep())
                .assemble()

        return productScreen
    }
}
