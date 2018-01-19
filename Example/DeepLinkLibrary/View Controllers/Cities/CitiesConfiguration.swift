//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

// Another example to provide a deeplinking destination
class CitiesConfiguration {

    static let shared = CitiesConfiguration()

    private let cityScreen: Screen
    private let citiesListScreen: Screen
    private let cityDetailsScreen: Screen

    private init() {
        // Split View Controller
        cityScreen = Screen(finder: ViewControllerClassFinder(containerType: UISplitViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Split", action: ReplaceRootAction()),
                interceptor: LoginInterceptor(),
                step: chain([
                    RootViewControllerStep()
                ]))

        // Cities List
        citiesListScreen = Screen(
                finder: CityTableViewControllerFinder(),
                postTask: CityTablePostTask(),
                step: chain([
                    RequireScreenStep(screen: self.cityScreen)
                ]))

        // City Details
        cityDetailsScreen = Screen(
                finder: CityDetailsViewControllerFinder(),
                factory: CityDetailsViewControllerFactory(action: PresentDetailsAction()),
                postTask: CityDetailPostTask(),
                step: chain([
                    RequireScreenStep(screen: self.citiesListScreen)
                ]))
    }


    static func citiesList(cityId: Int? = nil) -> ExampleDestination {
        return ExampleDestination(screen: shared.citiesListScreen, arguments: CityArguments(cityId: cityId))
    }

    static func cityDetail(cityId: Int) -> ExampleDestination {
        return ExampleDestination(screen: shared.cityDetailsScreen, arguments: CityArguments(cityId: cityId))
    }
}