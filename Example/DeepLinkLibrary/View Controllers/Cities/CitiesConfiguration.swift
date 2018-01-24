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

    private let cityAssembly: ViewControllerAssembly
    private let citiesListAssembly: ViewControllerAssembly
    private let cityDetailsAssembly: ViewControllerAssembly

    private init() {
        // Split View Controller
        cityAssembly = ViewControllerAssembly(finder: ViewControllerClassFinder(classType: UISplitViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Split", action: ReplaceRootAction()),
                interceptor: LoginInterceptor(),
                step: RootViewControllerStep())

        // Cities List
        citiesListAssembly = ViewControllerAssembly(
                finder: CityTableViewControllerFinder(),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: PostRoutingTaskMultiplexer([CityTablePostTask(), ExampleAnalyticsPostAction()]),
                step: RequireAssemblyStep(assembly: self.cityAssembly))

        // City Details
        cityDetailsAssembly = ViewControllerAssembly(
                finder: CityDetailsViewControllerFinder(),
                factory: CityDetailsViewControllerFactory(action: PresentDetailsAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: PostRoutingTaskMultiplexer([CityDetailPostTask(), ExampleAnalyticsPostAction()]),
                step: RequireAssemblyStep(assembly: self.citiesListAssembly))
    }


    static func citiesList(cityId: Int? = nil, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.citiesListAssembly, arguments: CityArguments(cityId: cityId, analyticParameters))
    }

    static func cityDetail(cityId: Int, _ analyticParameters: ExampleAnalyticsParameters? = nil) -> ExampleDestination {
        return ExampleDestination(finalStep: shared.cityDetailsAssembly, arguments: CityArguments(cityId: cityId, analyticParameters))
    }
}
