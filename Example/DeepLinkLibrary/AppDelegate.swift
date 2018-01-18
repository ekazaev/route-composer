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

    var config: ExampleConfiguration?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let config = ExampleConfiguration()

        // Login
        let loginScreen = Screen(
                finder: LoginViewControllerFinder(),
                factory: ViewControllerFromStoryboard(storyboardName: "Login", action: PresentModallyAction()),
                step: TopMostViewControllerStep())
        config.register(screen: loginScreen, for: ExampleTarget.login)

        // Home Tab Bar Screen
        let homeScreen = Screen(
                finder: ViewControllerClassFinder(containerType: UITabBarController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", action: ReplaceRootAction()),
                step: chain([
                    RootViewControllerStep()
                ]))

        config.register(screen: homeScreen, for: ExampleTarget.home)

        // Square Tab Bar Screen
        let squareScreen = Screen(
                finder: ViewControllerClassFinder(containerType: SquareViewController.self, policy: .currentLevel),
                step: chain([
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.home))
                ]))

        config.register(screen: squareScreen, for: ExampleTarget.square)

        // Circle Tab Bar screen
        let circleScreen = Screen(
                finder: ViewControllerClassFinder(containerType: CircleViewController.self, policy: .currentLevel),
                step: chain([
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.home))
                ]))

        config.register(screen: circleScreen, for: ExampleTarget.circle)

        //Color screen
        let colorScreen = Screen(
                finder: ColorViewControllerFinder(), factory: ColorViewControllerFactory(action: PushAction()),
                step: chain([
                    NavigationContainerStep(action: PresentModallyAction()),
                    TopMostViewControllerStep(),
                ]))

        config.register(screen: colorScreen, urlTranslator: ColorURLTranslator(), for: ExampleTarget.color)

        //Sceen with Routing support
        let routingSuportScreen = Screen(finder: ViewControllerClassFinder(containerType: RoutingRuleSupportViewController.self, policy: .currentLevel),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "RoutingRuleSupportViewController", action: PushAction()),
                step: chain([
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.color))
                ]))
        config.register(screen: routingSuportScreen,
                for: ExampleTarget.ruleSupport)

        // Empty Screen
        let emptyScreen = Screen(finder: ViewControllerClassFinder(containerType: EmptyViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "EmptyViewController", action: PushAction()),
                interceptor: LoginInterceptor(screen: loginScreen),
                step: chain([
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.circle))
                ]))

        config.register(screen: emptyScreen, for: ExampleTarget.empty)

        // Product Screen
        let productScreen = Screen(
                finder: ProductViewControllerFinder(),
                factory: ProductViewControllerFactory(action: PushAction()),
                step: chain([
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.circle))
                ]))

        config.register(screen: productScreen, urlTranslator: ProductURLTranslator(), for: ExampleTarget.product)

        // Two modal presentations screen
        let superModlaScreen = Screen(
                finder: ViewControllerClassFinder(containerType: ColorViewController.self),
                factory: ViewControllerFromClassFactory(viewControllerName: NSStringFromClass(ColorViewController.self), action: PushAction()),
                step: chain([
                    NavigationContainerStep(action: PresentModallyAction()),
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.ruleSupport))
                ]))
        config.register(screen: superModlaScreen, for: ExampleTarget.superModal)

        // Welcome Screen
        let welcomeScreen = Screen(
                finder: ViewControllerClassFinder(containerType: PromptViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "PromptScreen", action: ReplaceRootAction()),
                step: chain([
                    RootViewControllerStep()
                ]))

        config.register(screen: welcomeScreen, for: ExampleTarget.welcome)

        // Split View Controller
        let splitScreen = Screen(finder: ViewControllerClassFinder(containerType: UISplitViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Split", action: ReplaceRootAction()),
                interceptor: LoginInterceptor(screen: loginScreen),
                step: chain([
                    RootViewControllerStep()
                ]))
        config.register(screen: splitScreen, for: ExampleTarget.split)

        // Cities List
        let ciliesListScreen = Screen(
                finder: CityTableViewControllerFinder(),
                postTask: CityTablePostTask(),
                step: chain([
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.split))
                ]))
        config.register(screen: ciliesListScreen, for: ExampleTarget.citiesList)

        // City Details
        let ciryDetailsScreen = Screen(
                finder: CityDetailsViewControllerFinder(),
                factory: CityDetailsViewControllerFactory(action: PresentDetailsAction()),
                postTask: CityDetailPostTask(),
                step: chain([
                    RequireScreenStep(screenProvider: config.provider(for: ExampleTarget.citiesList))
                ]))
        config.register(screen: ciryDetailsScreen, urlTranslator: CityURLTranslator(), for: ExampleTarget.cityDetail)

        self.config = config

        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        guard let destination = config?.destination(for: url) else {
            return false
        }

        return DefaultRouter().deepLinkTo(destination: destination) == .handled
    }
}

