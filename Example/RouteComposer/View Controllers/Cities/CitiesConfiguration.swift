//
// Created by Eugene Kazaev on 19/01/2018.
//

import Foundation
import UIKit
import RouteComposer

// Another example to provide a destination
class CitiesConfiguration {

    // Split View Controller
    private static var city = StepAssembly(finder: ClassFinder<UISplitViewController, Any?>(),
            factory: StoryboardFactory(name: "Split"))
            .adding(LoginInterceptor<Any?>())
            .using(GeneralAction.replaceRoot())
            .from(GeneralStep.root())
            .assemble()

    // Cities List
    private static var citiesList = StepAssembly(finder: ClassFinder<CitiesTableViewController, Int?>(),
            factory: NilFactory())
            .adding(CityTableContextTask())
            .from(city.adaptingContext())
            .assemble()

    // City Details
    private static var cityDetails = StepAssembly(
            finder: ClassFinder<CityDetailViewController, Int>(),
            factory: StoryboardFactory(name: "Split",
                    identifier: "CityDetailViewController"))
            .adding(CityDetailContextTask())
            .using(UISplitViewController.pushToDetails())
            .from(citiesList.unsafelyRewrapped())
            // We have to rewrap the step unsafely, as we will take responsibility for the runtime type conversion.
            // In this particular case it will work as Int can always be converted to Int? and `citiesList` will
            // be able to select right cell while we are navigating to the `cityDetails`.
            .assemble()

    static func citiesList(cityId: Int? = nil) -> Destination<CitiesTableViewController, Int?> {
        return Destination(to: citiesList, with: cityId)
    }

    static func cityDetail(cityId: Int) -> Destination<CityDetailViewController, Int> {
        return Destination(to: cityDetails, with: cityId)
    }

}
