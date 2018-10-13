//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

// Another example to provide a destination
class CitiesConfiguration {

    // Split View Controller
    private static var city = StepAssembly(finder: ClassFinder<UISplitViewController, Any?>(),
            factory: StoryboardFactory(storyboardName: "Split"))
            .add(LoginInterceptor<Any?>())
            .using(GeneralAction.replaceRoot())
            .from(GeneralStep.root())
            .assemble()

    // Cities List
    private static var citiesList = EnclosedStepAssembly(finder: ClassFinder<CitiesTableViewController, Int?>())
            .add(CityTableContextTask())
            .from(city.adoptingContext())
            .assemble()

    // City Details
    private static var cityDetails = StepAssembly(
            finder: ClassFinder<CityDetailViewController, Int>(),
            factory: StoryboardFactory(storyboardName: "Split",
                    viewControllerID: "CityDetailViewController"))
            .add(CityDetailContextTask())
            .using(UISplitViewController.pushToDetails())
            .from(citiesList.unsafelyUnwrapping())
            // We are using within as we must provide a UINavigationController step to use `pushToDetails` action.
            // We have to unwrap the step unsafely, as we will take responsibility for the runtime type conversion.
            // In this particular case it will work as Int can always be converted to Int? and `citiesList` will
            // be able to select right cell while we are navigating to the `cityDetails`.
            .assemble()

    static func citiesList(cityId: Int? = nil) -> ExampleDestination<CitiesTableViewController, Int?> {
        return ExampleDestination(step: citiesList, context: cityId)
    }

    static func cityDetail(cityId: Int) -> ExampleDestination<CityDetailViewController, Int> {
        return ExampleDestination(step: cityDetails, context: cityId)
    }

}
