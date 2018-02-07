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

    private let city: ViewControllerStep
    private let citiesList: ViewControllerStep
    private let cityDetails: ViewControllerStep

    private init() {
        // Split View Controller
        city = ViewControllerAssembly(finder: ViewControllerClassFinder(classType: UISplitViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Split", action: ReplaceRootAction()))
                .add(LoginInterceptor())
                .from(RootViewControllerStep())
                .assemble()

        // Cities List
        citiesList = ViewControllerAssembly(finder: CityTableViewControllerFinder())
                .add(ExampleAnalyticsInterceptor())
                .add(CityTablePostTask())
                .add(ExampleAnalyticsPostAction())
                .from(RequireAssemblyStep(assembly: self.city))
                .assemble()

        // City Details
        cityDetails = ViewControllerAssembly(
                finder: CityDetailsViewControllerFinder(),
                factory: CityDetailsViewControllerFactory(action: PresentDetailsAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(CityDetailPostTask())
                .add(ExampleAnalyticsPostAction())
                .from(RequireAssemblyStep(assembly: self.citiesList))
                .assemble()
    }


    static func citiesList(cityId: Int? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.citiesList, arguments: CityArguments(cityId: cityId, analyticParameters))
    }

    static func cityDetail(cityId: Int, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.cityDetails, arguments: CityArguments(cityId: cityId, analyticParameters))
    }
}
