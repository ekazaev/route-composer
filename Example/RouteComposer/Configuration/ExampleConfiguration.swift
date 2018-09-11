//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

let transitionController = BlurredBackgroundTransitionController()

// NB: Keeping the screen configurations in the Dictionary has no practical value, demo only.
class ExampleConfiguration {

    private static var screens: [AnyHashable: RoutingStep] = [:]

    static func step<T: Hashable>(for target: T) -> RoutingStep? {
        return screens[target]
    }

    static func register<T: Hashable>(screen: RoutingStep, for target: T) {
        screens[target] = screen
    }

    static func destination<T: Hashable>(for target: T, context: ExampleDictionaryContext? = nil) -> ExampleDestination? {
        guard let assembly = step(for: target) else {
            return nil
        }

        return ExampleDestination(finalStep: assembly, context: context ?? ExampleDictionaryContext())
    }

}

extension ExampleConfiguration {

    static func configure() {
        // Home Tab Bar Screen
        let homeScreen = StepAssembly(
                // Because both factory and finder are Generic, You have to provide to at least one instance
                // what type of view controller and context to expect. You do not need to do so if you are using at
                // least one custom factory of finder that have set typealias for ViewController and Context.
                finder: ClassFinder<UITabBarController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar"))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleAnalyticsPostAction())
                .using(GeneralAction.ReplaceRoot())
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
                .usingNoAction()
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
                .usingNoAction()
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: circleScreen, for: ExampleTarget.circle)

        //Color screen
        let colorScreen = StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.PresentModally())
                .from(CurrentViewControllerStep())
                .assemble()
        ExampleConfiguration.register(screen: colorScreen, for: ExampleTarget.color)

        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .add(LoginInterceptor())
                .using(TabBarControllerFactory.AddTab())
                .from(homeScreen)
                .assemble()

        ExampleConfiguration.register(screen: starScreen, for: ExampleTarget.star)

        //Screen with Routing support
        let routingSupportScreen = StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, Any?>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(colorScreen)
                .assemble()

        ExampleConfiguration.register(screen: routingSupportScreen,
                for: ExampleTarget.ruleSupport)

        // Empty Screen
        let emptyScreen = StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                .add(LoginInterceptor())
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(circleScreen)
                .assemble()

        ExampleConfiguration.register(screen: emptyScreen, for: ExampleTarget.empty)

        // Two modal presentations in a row screen
        let superModalScreen = StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.PresentModally(transitioningDelegate: transitionController))
                .from(routingSupportScreen)
                .assemble()

        ExampleConfiguration.register(screen: superModalScreen, for: ExampleTarget.secondLevelModal)

        // Welcome Screen
        let welcomeScreen = StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen"))
                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                .add(ExampleAnalyticsPostAction())
                .using(GeneralAction.ReplaceRoot())
                .from(RootViewControllerStep())
                .assemble()

        ExampleConfiguration.register(screen: welcomeScreen, for: ExampleTarget.welcome)
    }

}
