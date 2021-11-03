//
// RouteComposer
// InternalSearchConfiguration.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import UIKit

struct InternalSearchConfiguration {
    private static let completeFactory = CompleteFactoryAssembly(factory: TabBarControllerFactory())
        .with(CompleteFactoryAssembly(factory: NavigationControllerFactory<UINavigationController, MainScreenContext>(configuration: { $0.tabBarItem.title = "Home" /* One way */ }))
            .with(ClassFactory<HomeViewController, MainScreenContext>())
            .assemble())
        .with(CompleteFactoryAssembly(factory: NavigationControllerFactory<UINavigationController, MainScreenContext>())
            .with(ClassFactory<SettingsViewController, MainScreenContext>())
            .assemble())
        .adding(InlineContextTask { (viewController: UINavigationController, _: MainScreenContext) in
            viewController.tabBarItem.title = "Settings" /* Another way way */
        })
        .assemble()

    private static let mainScreenFromCircle = StepAssembly(
        finder: NilFinder<UITabBarController, MainScreenContext>(),
        factory: completeFactory)
        // Comment `adding` and navigate to the Settings view controller to see the difference.
            .adding(InlineContextTask { (viewController: UITabBarController, context: MainScreenContext) in
                // This block of code allows you to select necessary view controller according to the context passes at the moment when
                // the UITabBarController was just created. No mater if the child view controllers are wrapped in some other containers
                // or tif they order will change. You can use this approach also in your own container factories.
                viewController.selectedIndex = viewController.viewControllers?.firstIndex(where: { viewController in
                    ClassWithContextFinder<AnyContextCheckingViewController<MainScreenContext>, MainScreenContext>(options: .currentAllStack, startingPoint: .custom(viewController)).getViewController(with: context) != nil
                }) ?? 0
            })
            .using(UINavigationController.push())
            .from(ConfigurationHolder.configuration.circleScreen.expectingContainer())
            .assemble()

    static let home = Destination(to: StepAssembly(
        finder: ClassWithContextFinder<HomeViewController, MainScreenContext>(),
        factory: NilFactory())
        .from(mainScreenFromCircle)
        .assemble(), with: .home)

    static let settings = Destination(to: StepAssembly(
        finder: ClassWithContextFinder<SettingsViewController, MainScreenContext>(),
        factory: NilFactory())
        .from(mainScreenFromCircle)
        .assemble(), with: .settings)
}
