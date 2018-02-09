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
        citiesList = ScreenStepAssembly(finder: CityTableViewControllerFinder(),
                factory: NilFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(CityTablePostTask())
                .add(ExampleAnalyticsPostAction())
                .from(city)
                .assemble()

        // City Details
        cityDetails = ScreenStepAssembly(
                finder: CityDetailsViewControllerFinder(),
                factory: ViewControllerFromStoryboard(storyboardName: "Split", viewControllerID: "CityDetailViewController", action: PresentDetailsAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(CityDetailPostTask())
                .add(ExampleAnalyticsPostAction())
                .from(citiesList)
                .assemble()
    }


    static func citiesList(cityId: Int? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.citiesList, arguments: CityArguments(cityId: cityId, analyticParameters))
    }

    static func cityDetail(cityId: Int, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.cityDetails, arguments: CityArguments(cityId: cityId, analyticParameters))
    }
}