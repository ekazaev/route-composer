//
//  AppDelegate.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

/*

CONTAINERS: (Can be named and anonimus)
Window
TabBar
NavigationController
Child?
Empty

PRESENTATIONS:
Modal
Custom?

*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        configureNavigationUsingDictionaryConfig()

        return true
    }

    private func configureNavigationUsingDictionaryConfig() {
        //As one of examples configuration can be stored in one configuration object. Other configs are in CitiesConfiguration, Product cofiguration and LoginConfiguration as static objects

        // Home Tab Bar Screen
        let homeScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: UITabBarController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", action: ReplaceRootAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RootViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: homeScreen, for: ExampleSource.home)

        // Square Tab Bar Screen
        let squareScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: SquareViewController.self, policy: .currentLevel))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RequireStep(homeScreen))
                .assemble()

        ExampleConfiguration.register(screen: squareScreen, for: ExampleSource.square)

        // Circle Tab Bar screen
        let circleScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: CircleViewController.self, policy: .currentLevel))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RequireStep(homeScreen))
                .assemble()

        ExampleConfiguration.register(screen: circleScreen, for: ExampleSource.circle)

        //Color screen
        let colorScreen = ScreenStepAssembly(
                finder: ColorViewControllerFinder(), factory: ColorViewControllerFactory(action: PushAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(NavigationContainerStep(action: PresentModallyAction()))
                .from(TopMostViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: colorScreen, for: ExampleSource.color)

        //Star screen
        let starScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: StarViewController.self, policy: .currentLevel), factory: StarViewControllerFactory(action: AddTabAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RequireStep(homeScreen))
                .assemble()

        ExampleConfiguration.register(screen: starScreen, for: ExampleSource.star)

        //Screen with Routing support
        let routingSupportScreen = ScreenStepAssembly(finder: ViewControllerClassFinder(classType: RoutingRuleSupportViewController.self, policy: .currentLevel),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "RoutingRuleSupportViewController", action: PushAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RequireStep(colorScreen))
                .assemble()

        ExampleConfiguration.register(screen: routingSupportScreen,
                for: ExampleSource.ruleSupport)

        // Empty Screen
        let emptyScreen = ScreenStepAssembly(finder: ViewControllerClassFinder(classType: EmptyViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "EmptyViewController", action: PushAction()))
                .add(LoginInterceptor())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RequireStep(circleScreen))
                .assemble()

        ExampleConfiguration.register(screen: emptyScreen, for: ExampleSource.empty)

        // Two modal presentations screen
        let superModalScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: SecondModalLevelViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "SecondModalLevelViewController", action: PushAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(NavigationContainerStep(action: PresentModallyAction()))
                .from(RequireStep(routingSupportScreen))
                .assemble()
        ExampleConfiguration.register(screen: superModalScreen, for: ExampleSource.secondLevelModal)

        // Welcome Screen
        let welcomeScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: PromptViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "PromptScreen", action: ReplaceRootAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RootViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: welcomeScreen, for: ExampleSource.welcome)

        ExampleUniversalLinksManager.register(translator: ColorURLTranslator())
        ExampleUniversalLinksManager.register(translator: ProductURLTranslator())
        ExampleUniversalLinksManager.register(translator: CityURLTranslator())
    }

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        guard let destination = ExampleUniversalLinksManager.destination(for: url) else {
            return false
        }

        return DefaultRouter(logger: nil).deepLinkTo(destination: destination) == .handled
    }
}

