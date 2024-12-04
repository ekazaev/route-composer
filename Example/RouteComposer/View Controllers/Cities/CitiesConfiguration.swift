//
// RouteComposer
// CitiesConfiguration.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

// Another example to provide a destination
class CitiesConfiguration {

    // Split View Controller
    @MainActor private static var city = StepAssembly(finder: ClassFinder<UISplitViewController, Void>(), // Context type `Void` here is only used to demonstrate the possibility of context transformation.
                                           factory: StoryboardFactory(name: "Split"))
        .adding(LoginInterceptor<Void>())
        .using(GeneralAction.replaceRoot())
        .from(GeneralStep.root())
        .assemble()

    // Cities List
    @MainActor private static var citiesList = StepAssembly(finder: ClassFinder<CitiesTableViewController, String?>(),
                                                 factory: NilFactory())
        .adding(CityTableContextTask())
        .from(city.adaptingContext(using: InlineContextTransformer { _ in () })) // We have to transform `String?` to `Void` to satisfy the requirements
        .assemble()

    // City Details
    @MainActor private static var cityDetails = StepAssembly(
        finder: ClassFinder<CityDetailViewController, Int>(),
        factory: StoryboardFactory(name: "Split",
                                   identifier: "CityDetailViewController"))
        .adding(CityDetailContextTask())
        .using(UISplitViewController.pushToDetails())
        .from(citiesList.adaptingContext(using: InlineContextTransformer { $0.flatMap { "\($0)" } }).expectingContainer()) // We have to transform `Int` to `String?` to satisfy the requirements
        .assemble()

    @MainActor static func citiesList(cityId: Int? = nil) -> Destination<CitiesTableViewController, String?> {
        Destination(to: citiesList, with: cityId.flatMap { "\($0)" } ?? nil)
    }

    @MainActor static func cityDetail(cityId: Int) -> Destination<CityDetailViewController, Int> {
        Destination(to: cityDetails, with: cityId)
    }

}
