//
//  AppDelegate.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        configureNavigationUsingDictionaryConfig()

        return true
    }

    private func configureNavigationUsingDictionaryConfig() {
        //As one of examples configuration can be stored in one configuration object. Other configs are in CitiesConfiguration, Product configuration and LoginConfiguration as static objects

        // Home Tab Bar Screen
        let homeScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: UITabBarController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", action: ReplaceRootAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RootViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: homeScreen, for: ExampleTarget.home)

        // Square Tab Bar Screen
        let squareScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: SquareViewController.self, policy: .currentLevel))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: squareScreen, for: ExampleTarget.square)

        // Circle Tab Bar screen
        let circleScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: CircleViewController.self, policy: .currentLevel))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: circleScreen, for: ExampleTarget.circle)

        //Color screen
        let colorScreen = ScreenStepAssembly(
                finder: ColorViewControllerFinder(), factory: ColorViewControllerFactory(action: PushAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(NavigationContainerStep(action: PresentModallyAction()))
                .from(TopMostViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: colorScreen, for: ExampleTarget.color)

        //Star screen
        let starScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: StarViewController.self, policy: .currentLevel), factory: StarViewControllerFactory(action: AddTabAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .add(LoginInterceptor())
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: starScreen, for: ExampleTarget.star)

        //Screen with Routing support
        let routingSupportScreen = ScreenStepAssembly(finder: ViewControllerClassFinder(classType: RoutingRuleSupportViewController.self, policy: .currentLevel),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "RoutingRuleSupportViewController", action: PushAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(colorScreen)
                .assemble()

        ExampleConfiguration.register(screen: routingSupportScreen,
                for: ExampleTarget.ruleSupport)

        // Empty Screen
        let emptyScreen = ScreenStepAssembly(finder: ViewControllerClassFinder(classType: EmptyViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "EmptyViewController", action: PushAction()))
                .add(LoginInterceptor())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(circleScreen)
                .assemble()

        ExampleConfiguration.register(screen: emptyScreen, for: ExampleTarget.empty)

        // Two modal presentations screen
        let superModalScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: SecondModalLevelViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "SecondModalLevelViewController", action: PushAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(NavigationContainerStep(action: PresentModallyAction()))
                .from(routingSupportScreen)
                .assemble()
        ExampleConfiguration.register(screen: superModalScreen, for: ExampleTarget.secondLevelModal)

        // Welcome Screen
        let welcomeScreen = ScreenStepAssembly(
                finder: ViewControllerClassFinder(classType: PromptViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "PromptScreen", action: ReplaceRootAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RootViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: welcomeScreen, for: ExampleTarget.welcome)

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

