//
// Created by Eugene Kazaev on 19/01/2018.
//

import Foundation
import UIKit
import RouteComposer

// Another example to provide a destination
class CitiesConfiguration {

    static var citiesTab = ContainerStepAssembly(finder: ClassFinder<CitiesTabBarController, Any?>(),
            factory: CompleteFactoryAssembly(factory: TabBarControllerFactory<CitiesTabBarController, Any?>())
                    .with(CompleteFactoryAssembly(factory: SplitControllerFactory<CitiesSplitController, Any?>(configuration: { $0.title = "Cities" }))
                            .with(CompleteFactoryAssembly(factory: NavigationControllerFactory())
                                    .with(StoryboardFactory(name: "Split", identifier: "CitiesTableViewController"))
                                    .assemble(),
                                    using: CitiesSplitController.setAsMaster())
                            .with(CompleteFactoryAssembly(factory: NavigationControllerFactory())
                                    .with(StoryboardFactory(name: "Split", identifier: "CityDetailViewController"))
                                    .assemble(),
                                    using: CitiesSplitController.pushToDetails())
                            .assemble())
                    .with(CompleteFactoryAssembly(factory: NavigationControllerFactory())
                            .with(StoryboardFactory<ProductViewController, Any?>(name: "TabBar", identifier: "ProductViewController"))
                            .assemble())
                    .assemble())
            .using(GeneralAction.replaceRoot())
            .from(GeneralStep.root())
            .assemble()

    // Cities List
    private static var citiesList = StepAssembly(finder: ClassFinder<CitiesTableViewController, Int?>(),
            factory: NilFactory())
            .from(SingleStep(finder: ClassFinder<CitiesSplitController, Any?>(), factory: NilFactory<CitiesSplitController, Any?>()).adaptingContext())
            .using(GeneralAction.nilAction())
            .from(citiesTab.adaptingContext())
            .assemble()

    // City Details
    private static var cityDetails = StepAssembly(
            finder: NilFinder<CityDetailViewController, Int>(),
            factory: StoryboardFactory<CityDetailViewController, Int>(name: "Split",
                    identifier: "CityDetailViewController"))
            .adding(CityDetailContextTask())
            .using(CitiesSplitController.pushOnToDetails())
            .from(SingleStep(finder: ClassFinder<CitiesSplitController, Any?>(), factory: NilFactory<CitiesSplitController, Any?>()).adaptingContext())
            .using(GeneralAction.nilAction())
            .from(citiesTab.adaptingContext())
            .assemble()

    static func citiesList(cityId: Int? = nil) -> Destination<CitiesTableViewController, Int?> {
        return Destination(to: citiesList, with: cityId)
    }

    static func cityDetail(cityId: Int) -> Destination<CityDetailViewController, Int> {
        return Destination(to: cityDetails, with: cityId)
    }

}

// Just to distinguish from other tabs and split controllers on the experiment
class CitiesSplitController: UISplitViewController {

}
class CitiesTabBarController: UITabBarController {

}