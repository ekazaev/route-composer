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
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: TopMostViewControllerStep())
        config.register(screen: loginScreen, for: ExampleSource.login)

        // Home Tab Bar Screen
        let homeScreen = Screen(
                finder: ViewControllerClassFinder(containerType: UITabBarController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", action: ReplaceRootAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RootViewControllerStep()
                ]))

        config.register(screen: homeScreen, for: ExampleSource.home)

        // Square Tab Bar Screen
        let squareScreen = Screen(
                finder: ViewControllerClassFinder(containerType: SquareViewController.self, policy: .currentLevel),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireScreenStep(screen: homeScreen)
                ]))

        config.register(screen: squareScreen, for: ExampleSource.square)

        // Circle Tab Bar screen
        let circleScreen = Screen(
                finder: ViewControllerClassFinder(containerType: CircleViewController.self, policy: .currentLevel),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireScreenStep(screen: homeScreen)
                ]))

        config.register(screen: circleScreen, for: ExampleSource.circle)

        //Color screen
        let colorScreen = Screen(
                finder: ColorViewControllerFinder(), factory: ColorViewControllerFactory(action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    NavigationContainerStep(action: PresentModallyAction()),
                    TopMostViewControllerStep(),
                ]))

        config.register(screen: colorScreen, for: ExampleSource.color)

        //Sceen with Routing support
        let routingSuportScreen = Screen(finder: ViewControllerClassFinder(containerType: RoutingRuleSupportViewController.self, policy: .currentLevel),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "RoutingRuleSupportViewController", action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireScreenStep(screen: colorScreen)
                ]))
        config.register(screen: routingSuportScreen,
                for: ExampleSource.ruleSupport)

        // Empty Screen
        let emptyScreen = Screen(finder: ViewControllerClassFinder(containerType: EmptyViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "Main", viewControllerID: "EmptyViewController", action: PushAction()),
                interceptor: InterceptorMultiplex([LoginInterceptor(), ExampleAnalyticsInterceptor()]),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireScreenStep(screen: circleScreen)
                ]))

        config.register(screen: emptyScreen, for: ExampleSource.empty)

        // Product Screen
        let productScreen = Screen(
                finder: ProductViewControllerFinder(),
                factory: ProductViewControllerFactory(action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RequireScreenStep(screen: circleScreen)
                ]))

        config.register(screen: productScreen, for: ExampleSource.product)

        // Two modal presentations screen
        let superModlaScreen = Screen(
                finder: ViewControllerClassFinder(containerType: ColorViewController.self),
                factory: ViewControllerFromClassFactory(viewControllerName: NSStringFromClass(ColorViewController.self), action: PushAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    NavigationContainerStep(action: PresentModallyAction()),
                    RequireScreenStep(screen: routingSuportScreen)
                ]))
        config.register(screen: superModlaScreen, for: ExampleSource.superModal)

        // Welcome Screen
        let welcomeScreen = Screen(
                finder: ViewControllerClassFinder(containerType: PromptViewController.self),
                factory: ViewControllerFromStoryboard(storyboardName: "PromptScreen", action: ReplaceRootAction()),
                interceptor: ExampleAnalyticsInterceptor(),
                postTask: ExampleAnalyticsPostAction(),
                step: chain([
                    RootViewControllerStep()
                ]))

        config.register(screen: welcomeScreen, for: ExampleSource.welcome)

        self.config = config

        ExampleUniversalLinksManager.register(translator: ColorURLTranslator(config))
        ExampleUniversalLinksManager.register(translator: ProductURLTranslator(config))
        ExampleUniversalLinksManager.register(translator: CityURLTranslator())

        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        guard let destination = ExampleUniversalLinksManager.destination(for: url) else {
            return false
        }

        return DefaultRouter().deepLinkTo(destination: destination) == .handled
    }
}

