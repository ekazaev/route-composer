//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

// Another example to provide a deep linking destination
class CitiesConfiguration {

    static let shared = CitiesConfiguration()

    private let city: RoutingStep
    private let citiesList: RoutingStep
    private let cityDetails: RoutingStep

    private init() {
        // Split View Controller
        city = ScreenStepAssembly(finder: ViewControllerClassFinder<UISplitViewController, Any>(),
                factory: ViewControllerFromStoryboard<UISplitViewController, Any>(storyboardName: "Split", action: ReplaceRootAction()))
                .add(LoginInterceptor())
                .from(RootViewControllerStep())
                .assemble()

        // Cities List
        citiesList = ScreenStepAssembly(finder: ViewControllerClassFinder<CitiesTableViewController, CityContext>(),
                factory: NilFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(CityTableContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(city)
                .assemble()

        // City Details
        cityDetails = ScreenStepAssembly(
                finder: ViewControllerClassFinder<CityDetailViewController, CityContext>(),
                factory: ViewControllerFromStoryboard(storyboardName: "Split", viewControllerID: "CityDetailViewController", action: PresentDetailsAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(CityDetailContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(citiesList)
                .assemble()
    }


    static func citiesList(cityId: Int? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.citiesList, context: CityContext(cityId: cityId, analyticParameters))
    }

    static func cityDetail(cityId: Int, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.cityDetails, context: CityContext(cityId: cityId, analyticParameters))
    }
}
