//
// Created by Eugene Kazaev on 20/01/2018.
//

import Foundation
import RouteComposer
import UIKit

class ProductConfiguration {

    static let productScreen = StepAssembly(
            finder: ClassWithContextFinder<ProductViewController, ProductContext>(),
            factory: StoryboardFactory(name: "TabBar", identifier: "ProductViewController"))
            .adding(InlineInterceptor({ (_: ProductContext) in
                print("On before navigation to Product view controller")
            }))
            .adding(InlineContextTask({ (_: ProductViewController, _: ProductContext) in
                print("Product view controller built or found")
            }))
            .adding(InlinePostTask({ (_: ProductViewController, _: ProductContext, _) in
                print("After navigation to Produce view controller")
            }))
            .adding(ContextSettingTask())
            .using(UINavigationController.push())
            .from(SwitchAssembly<UINavigationController, ProductContext>()
                    .addCase { (context: ProductContext) in
                        // If this configuration is requested by a Universal Link (productURL != nil), then present modally.
                        // Try in Mobile Safari dll://productView?product=123
                        guard context.productURL != nil else {
                            return nil
                        }

                        return ChainAssembly.from(NavigationControllerStep())
                                .using(GeneralAction.presentModally())
                                .from(GeneralStep.current())
                                .assemble()

                    }
                    // If UINavigationController is visible on the screen - just push
                    .addCase(from: ClassFinder<UINavigationController, ProductContext>(options: .currentVisibleOnly))
                    .assemble(default: {
                        // Otherwise - present in the UINavigation controller that belongs to Circle tab
                        return ConfigurationHolder.configuration.circleScreen.expectingContainer()
                    }))
            .assemble()

}
