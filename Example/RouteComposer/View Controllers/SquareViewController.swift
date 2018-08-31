//
//  SquareViewController.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 HBC Tech. All rights reserved.
//

import UIKit
import RouteComposer

class SquareViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .square)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToCircleTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToHomeTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.empty)!)
    }

    @IBAction func goToSplitTapped() {
        router.navigate(to: CitiesConfiguration.citiesList())
    }

    @IBAction func goToLoginTapped() {
        router.navigate(to: LoginConfiguration.login())
    }

    @IBAction func goToStarTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.star)!)
    }

    @IBAction func goToFakeContainerTapped() {
        router.navigate(to: WishListConfiguration.collections())
    }

    @IBAction func switchValueChanged(sender: UISwitch) {
        let starScreen: RoutingStep
        if sender.isOn {
            starScreen = StepAssembly(
                    finder: ClassFinder<StarViewController, Any>(options: .currentAllStack),
                    factory: XibFactory())
                    .add(ExampleAnalyticsInterceptor())
                    .add(ExampleGenericContextTask())
                    .add(ExampleAnalyticsPostAction())
                    .add(LoginInterceptor())
                    .using(NavigationControllerFactory.PushToNavigation())
                    .from(ExampleConfiguration.destination(for: ExampleTarget.circle)!.finalStep)
                    .assemble()

        } else {
            starScreen = StepAssembly(
                    finder: ClassFinder<StarViewController, Any>(options: .currentAllStack),
                    factory: XibFactory())
                    .add(ExampleAnalyticsInterceptor())
                    .add(ExampleGenericContextTask())
                    .add(ExampleAnalyticsPostAction())
                    .add(LoginInterceptor())
                    .using(TabBarControllerFactory.AddTab())
                    .from(ExampleConfiguration.destination(for: ExampleTarget.home)!.finalStep)
                    .assemble()
        }
        ExampleConfiguration.register(screen: starScreen, for: ExampleTarget.star)
    }

}
