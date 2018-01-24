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
        let homeAssembly = ViewControllerAssembly(
                finder: ViewControllerClassFinder(classType: UITabBarController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", action: ReplaceRootAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RootViewControllerStep()
                ]))

        ExampleConfiguration.register(assembly: homeAssembly, for: ExampleSource.home)

        // Square Tab Bar Screen
        let squareAssembly = ViewControllerAssembly(
                finder: ViewControllerClassFinder(classType: SquareViewController.self, policy: .currentLevel),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireAssemblyStep(assembly: homeAssembly)
                ]))

        ExampleConfiguration.register(assembly: squareAssembly, for: ExampleSource.square)

        // Circle Tab Bar screen
        let circleAssembly = ViewControllerAssembly(
                finder: ViewControllerClassFinder(classType: CircleViewController.self, policy: .currentLevel),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireAssemblyStep(assembly: homeAssembly)
                ]))

        ExampleConfiguration.register(assembly: circleAssembly, for: ExampleSource.circle)

        //Color screen
        let colorAssembly = ViewControllerAssembly(
                finder: ColorViewControllerFinder(), factory: ColorViewControllerFactory(action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    NavigationContainerStep(action: PresentModallyAction()),
                    TopMostViewControllerStep(),
                ]))

        ExampleConfiguration.register(assembly: colorAssembly, for: ExampleSource.color)

        //Sceen with Routing support
        let routingSupportAssembly = ViewControllerAssembly(finder: ViewControllerClassFinder(classType: RoutingRuleSupportViewController.self, policy: .currentLevel),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "RoutingRuleSupportViewController", action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireAssemblyStep(assembly: colorAssembly)
                ]))
        ExampleConfiguration.register(assembly: routingSupportAssembly,
                for: ExampleSource.ruleSupport)

        // Empty Screen
        let emptyAssembly = ViewControllerAssembly(finder: ViewControllerClassFinder(classType: EmptyViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "EmptyViewController", action: PushAction()),
                interceptor: InterceptorMultiplexer([LoginInterceptor(), ExampleAnalyticsInterceptor()]),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireAssemblyStep(assembly: circleAssembly)
                ]))

        ExampleConfiguration.register(assembly: emptyAssembly, for: ExampleSource.empty)

        // Two modal presentations screen
        let superModalAssembly = ViewControllerAssembly(
                finder: ViewControllerClassFinder(classType: SecondModalLevelViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "SecondModalLevelViewController", action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    NavigationContainerStep(action: PresentModallyAction()),
                    RequireAssemblyStep(assembly: routingSupportAssembly)
                ]))
        ExampleConfiguration.register(assembly: superModalAssembly, for: ExampleSource.secondLevelModal)

        // Welcome Screen
        let welcomeAssembly = ViewControllerAssembly(
                finder: ViewControllerClassFinder(classType: PromptViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "PromptScreen", action: ReplaceRootAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RootViewControllerStep()
                ]))

        ExampleConfiguration.register(assembly: welcomeAssembly, for: ExampleSource.welcome)

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

