//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class MainApp {

    static let shared = MainApp()

    static let categoryContainer = ScreenStepAssembly(finder: CategoriesFinder(),
            factory: CategoriesFactory(delegate: MainApp.shared, fetcher: CategoriesFetcher(), action: PushAction()))
            .from(NavigationContainerStep(action: AddTabAction()))
            .from(ExampleConfiguration.step(for: ExampleTarget.home)!)
            .assemble()

    static func category(id categoryId: String, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> RoutingDestination {
        var config = ScreenStepAssembly(finder: ProductArrayFinder(),
                factory: ProductArrayFactory(fetcher: PAProductFetcher(), action: PushChildCategoryAction()))
        if categoryId == "2" {
            config = config.add(LoginInterceptor())
        }
        return ExampleDestination(finalStep: config.from(MainApp.categoryContainer).assemble(),
                context: MainAppProductContext(categoryId: categoryId, nil))
    }

}

extension MainApp: CategoriesViewControllerDelegate {

    func showCategory(for categoryId: String) {
        DefaultRouter(logger: DefaultLogger()).deepLinkTo(destination: MainApp.category(id: categoryId))
    }

}