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
        let homeScreen = StepAssembly(
                // Because both factory and finder are Generic, You have to provide to at least one instance
                // what type of view controller and context to expect. You do not need to do so if you are using at
                // least one custom factory of finder that have set typealias for ViewController and Context.
                finder: ClassFinder<UITabBarController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", action: ReplaceRootAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(RootViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: homeScreen, for: ExampleTarget.home)

        // Square Tab Bar Screen
        let squareScreen = StepAssembly(
                finder: ClassFinder<SquareViewController, ExampleDictionaryContext>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: squareScreen, for: ExampleTarget.square)

        // Circle Tab Bar screen
        let circleScreen = StepAssembly(
                finder: ClassFinder<CircleViewController, ExampleDictionaryContext>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: circleScreen, for: ExampleTarget.circle)

        //Color screen
        let colorScreen = StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory(action: PushToNavigationAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(NavigationControllerStep(action: PresentModallyAction()))
                .from(CurrentViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: colorScreen, for: ExampleTarget.color)

        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any>(options: .currentAllStack),
                factory: XibFactory(action: AddTabAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .add(LoginInterceptor())
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: starScreen, for: ExampleTarget.star)

        //Screen with Routing support
        let routingSupportScreen = StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, Any?>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController", action: PushToNavigationAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(colorScreen)
                .assemble()

        ExampleConfiguration.register(screen: routingSupportScreen,
                for: ExampleTarget.ruleSupport)

        // Empty Screen
        let emptyScreen = StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController", action: PushToNavigationAction()))
                .add(LoginInterceptor())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(circleScreen)
                .assemble()

        ExampleConfiguration.register(screen: emptyScreen, for: ExampleTarget.empty)

        // Two modal presentations in a row screen
        let superModalScreen = StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController", action: PushToNavigationAction()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .from(NavigationControllerStep(action: PresentModallyAction()))
                .from(routingSupportScreen)
                .assemble()

        ExampleConfiguration.register(screen: superModalScreen, for: ExampleTarget.secondLevelModal)

        // Welcome Screen
        let welcomeScreen = StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen", action: ReplaceRootAction()))
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

