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
    private static var city = DestinationAssembly<Any?>(from: GeneralStep.root())
            .using(GeneralAction.replaceRoot())
            .present(SingleStep(finder: ClassFinder<UISplitViewController, Any?>(),
                    factory: StoryboardFactory(storyboardName: "Split"))
                    .adding(LoginInterceptor<Any?>()))
            .assemble()

    // Cities List
    private static var citiesList = ContainerDestinationAssembly<UISplitViewController, Int?>(from: city.adaptingContext())
            .inside()
            .present(SingleStep(finder: ClassFinder<CitiesTableViewController, Int?>(),
                    factory: NilFactory())
                    .adding(CityTableContextTask()))
            .assemble()

    // City Details
    private static var cityDetails = ContainerDestinationAssembly<UISplitViewController, Int>(from: citiesList.unsafelyRewrapped())
            .using(UISplitViewController.pushToDetails())
            .present(SingleStep(
                    finder: ClassFinder<CityDetailViewController, Int>(),
                    factory: StoryboardFactory(storyboardName: "Split",
                            viewControllerID: "CityDetailViewController"))
                    .adding(CityDetailContextTask()))
            .assemble()

    static func citiesList(cityId: Int? = nil) -> ExampleDestination<CitiesTableViewController, Int?> {
        return ExampleDestination(step: citiesList, context: cityId)
    }

    static func cityDetail(cityId: Int) -> ExampleDestination<CityDetailViewController, Int> {
        return ExampleDestination(step: cityDetails, context: cityId)
    }

}
