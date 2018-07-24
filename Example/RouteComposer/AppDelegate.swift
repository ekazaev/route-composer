//
//  AppDelegate.swift
//  CircumferenceKit
//
//  Created by Eugene Kazaev on 18/12/2017.
//  Copyright © 2017 HBC Tech. All rights reserved.
//

import UIKit
import RouteComposer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let transitionDelegate = BlurredBackgroundPresentationController()
    
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
                factory: StoryboardFactory(storyboardName: "TabBar", action: GeneralAction.ReplaceRoot()))
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
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(homeScreen)
                .assemble()
        
        ExampleConfiguration.register(screen: squareScreen, for: ExampleTarget.square)
        
        // Circle Tab Bar screen
        let circleScreen = StepAssembly(
                finder: ClassFinder<CircleViewController, ExampleDictionaryContext>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(homeScreen)
                .assemble()
        
        ExampleConfiguration.register(screen: circleScreen, for: ExampleTarget.circle)
        
        //Color screen
        let colorScreen = StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory(action: NavigationControllerFactory.PushToNavigation()))
                .add(ExampleAnalyticsInterceptor())
                .add(InlineInterceptor({ (d: ExampleDestination) in
                    print("On before navigation to Color view controller")
                }))
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .add(InlineContextTask({ (vc: ColorViewController, context: ExampleDictionaryContext) in
                    print("Color view controller built or found")
                }))
                .add(InlinePostTask({ (vc:ColorViewController, d: ExampleDestination, _) in
                    print("After navigation to Color view controller")
                }))
                .from(NavigationControllerStep(action: GeneralAction.PresentModally(transitioningDelegate: transitionDelegate)))
                .from(CurrentViewControllerStep())
                .assemble()
        
        ExampleConfiguration.register(screen: colorScreen, for: ExampleTarget.color)
        
        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any>(options: .currentAllStack),
                factory: XibFactory(action: TabBarControllerFactory.AddTab()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .add(LoginInterceptor())
                .from(homeScreen)
                .assemble()
        
        ExampleConfiguration.register(screen: starScreen, for: ExampleTarget.star)
        
        //Screen with Routing support
        let routingSupportScreen = StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, Any?>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController", action: NavigationControllerFactory.PushToNavigation()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(colorScreen)
                .assemble()
        
        ExampleConfiguration.register(screen: routingSupportScreen,
                for: ExampleTarget.ruleSupport)
        
        // Empty Screen
        let emptyScreen = StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController", action: NavigationControllerFactory.PushToNavigation()))
                .add(LoginInterceptor())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(circleScreen)
                .assemble()
        
        ExampleConfiguration.register(screen: emptyScreen, for: ExampleTarget.empty)
        
        // Two modal presentations in a row screen
        let superModalScreen = StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController", action: NavigationControllerFactory.PushToNavigation()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(NavigationControllerStep(action: GeneralAction.PresentModally()))
                .from(routingSupportScreen)
                .assemble()
        
        ExampleConfiguration.register(screen: superModalScreen, for: ExampleTarget.secondLevelModal)
        
        // Welcome Screen
        let welcomeScreen = StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen", action: GeneralAction.ReplaceRoot()))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .from(RootViewControllerStep())
                .assemble()
        
        let testScreen = ContainerStepAssembly(
                finder: ClassFinder<UINavigationController, Any?>(),
                factory: NavigationControllerFactory(action: GeneralAction.ReplaceRoot()))
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

