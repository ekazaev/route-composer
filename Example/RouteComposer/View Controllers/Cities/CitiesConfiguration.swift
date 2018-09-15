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

    private let city: DestinationStep<Any?>
    private let citiesList: DestinationStep<Int?>
    private let cityDetails: DestinationStep<Int>

    private init() {
        // Split View Controller
        city = StepAssembly(finder: ClassFinder<UISplitViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "Split"))
                .add(LoginInterceptor())
                .using( GeneralAction.ReplaceRoot())
                .from(GeneralStep.root())
                .assemble()

        // Cities List
        citiesList = StepAssembly(finder: ClassFinder<CitiesTableViewController, Int?>(),
                factory: NilFactory())
                .add(CityTableContextTask())
                .usingNoAction()
                .from(city)
                .assemble()

        // City Details
        cityDetails = StepAssembly(
                finder: ClassFinder<CityDetailViewController, Int>(),
                factory: StoryboardFactory(storyboardName: "Split",
                        viewControllerID: "CityDetailViewController"))
                .add(CityDetailContextTask())
                .using(SplitControllerFactory.PushToDetails())
                .from(citiesList)
                .assemble()
    }

    static func citiesList(cityId: Int? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination<Int?> {
        return ExampleDestination(step: shared.citiesList, context: cityId)
    }

    static func cityDetail(cityId: Int, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination<Int> {
        return ExampleDestination(step: shared.cityDetails, context: cityId)
    }

}
