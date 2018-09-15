//
// Created by Eugene Kazaev on 20/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit

class ProductConfiguration {

    static func productStep() -> DestinationStep<ProductContext> {
        let productScreen = StepAssembly(
                finder: ClassWithContextFinder<ProductViewController, ProductContext>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "ProductViewController"))
                .add(InlineInterceptor({ (_: ProductContext) in
                    print("On before navigation to Product view controller")
                }))
                .add(InlineContextTask({ (_: ProductViewController, _: ProductContext) in
                    print("Product view controller built or found")
                }))
                .add(InlinePostTask({ (_: ProductViewController, _: ProductContext, _) in
                    print("After navigation to Produce view controller")
                }))
                .add(ProductContextTask())
                .using(NavigationControllerFactory.PushToNavigation())
                                .from(SwitchAssembly<Any?>()
                                        .addCase { (context: ProductContext) in
                                            // If routing requested by Universal Link - Presenting modally
                                            // Try in Mobile Safari dll://productView?product=123
                                            guard context.productURL != nil else {
                                                return nil
                                            }

                                            return ChainAssembly(from: NavigationControllerStep())
                                                    .using(GeneralAction.PresentModally())
                                                    .from(GeneralStep.current())
                                                    .assemble()

                                        }
                                        // If UINavigationController exists on current level - just push
                                        .addCase(when: ClassFinder<UINavigationController, Any?>(options: .currentAllStack))
                                        .assemble(default: {
                                            // Otherwise - presenting in Circle Tab
                                            return ExampleConfiguration.wireframe.goToCircle().destination
                                        }))
                .assemble()

        return productScreen
    }
}
