//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

// Another example to provide a routing destination
class CitiesConfiguration {

    static let shared = CitiesConfiguration()

    private let city: RoutingStep
    private let citiesList: RoutingStep
    private let cityDetails: RoutingStep

    private init() {
        // Split View Controller
        city = StepAssembly(finder: ClassFinder<UISplitViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "Split"))
                .add(LoginInterceptor())
                .using( GeneralAction.ReplaceRoot())
                .from(RootViewControllerStep())
                .assemble()

        // Cities List
        citiesList = StepAssembly(finder: ClassFinder<CitiesTableViewController, Int?>(),
                factory: NilFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(CityTableContextTask())
                .add(ExampleAnalyticsPostAction())
                .usingNoAction()
                .from(city)
                .assemble()

        // City Details
        cityDetails = StepAssembly(
                finder: ClassFinder<CityDetailViewController, Int>(),
                factory: StoryboardFactory(storyboardName: "Split",
                        viewControllerID: "CityDetailViewController"))
                .add(ExampleAnalyticsInterceptor())
                .add(CityDetailContextTask())
                .add(ExampleAnalyticsPostAction())
                .using(SplitControllerFactory.PushToDetails())
                .from(citiesList)
                .assemble()
    }

    static func citiesList(cityId: Int? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.citiesList, context: cityId, analyticParameters)
    }

    static func cityDetail(cityId: Int, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.cityDetails, context: cityId, analyticParameters)
    }

}
