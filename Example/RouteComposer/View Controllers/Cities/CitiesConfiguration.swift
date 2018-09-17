//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

// Another example to provide a routing destination
class CitiesConfiguration {

    // Split View Controller
    private static var city = StepAssembly(finder: ClassFinder<UISplitViewController, Any?>(),
            factory: StoryboardFactory(storyboardName: "Split"))
            .add(LoginInterceptor<Any?>())
            .using(GeneralAction.ReplaceRoot())
            .from(GeneralStep.root())
            .assemble()
    // Cities List
    private static var citiesList = StepAssembly(finder: ClassFinder<CitiesTableViewController, Int?>(),
            factory: NilFactory())
            .add(CityTableContextTask())
            .usingNoAction()
            .from(city)
            .assemble()

    // City Details
    private static var cityDetails = StepAssembly(
            finder: ClassFinder<CityDetailViewController, Int>(),
            factory: StoryboardFactory(storyboardName: "Split",
                    viewControllerID: "CityDetailViewController"))
            .add(CityDetailContextTask())
            .using(SplitControllerFactory.PushToDetails())
            .from(citiesList)
            .assemble()

    static func citiesList(cityId: Int? = nil) -> ExampleDestination<Int?> {
        return ExampleDestination(step: citiesList, context: cityId)
    }

    static func cityDetail(cityId: Int) -> ExampleDestination<Int> {
        return ExampleDestination(step: cityDetails, context: cityId)
    }

}
