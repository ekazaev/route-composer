//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

let transitionController = BlurredBackgroundTransitionController()

protocol ExampleWireframe {

    func goToHome() -> ExampleDestination

    func goToCircle() -> ExampleDestination

    func goToSquare() -> ExampleDestination

    func goToColor(_ color: String) -> ExampleDestination

    func goToStar() -> ExampleDestination

    func goToRoutingSupport(_ color: String) -> ExampleDestination

    func goToEmptyScreen() -> ExampleDestination

    func goToSecondLevelModal(_ color: String) -> ExampleDestination

    func goToWelcome() -> ExampleDestination

}

extension ExampleWireframe {

    func goToHome() -> ExampleDestination {
        // Home Tab Bar Screen
        let homeScreen = StepAssembly(
                // Because both factory and finder are Generic, You have to provide to at least one instance
                // what type of view controller and context to expect. You do not need to do so if you are using at
                // least one custom factory of finder that have set typealias for ViewController and Context.
                finder: ClassFinder<UITabBarController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar"))
                //                .add(ExampleAnalyticsInterceptor())
                //                .add(ExampleAnalyticsPostAction())
                .using(GeneralAction.ReplaceRoot())
                .from(RootViewControllerStep())
                .assemble()
        return ExampleDestination(finalStep: homeScreen.lastStep)
    }

    func goToCircle() -> ExampleDestination {
        // Circle Tab Bar screen
        let circleScreen = StepAssembly(
                finder: ClassFinder<CircleViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .usingNoAction()
                .from(goToHome().finalStep)
                .assemble()

        return ExampleDestination(finalStep: circleScreen.lastStep)
    }

    func goToSquare() -> ExampleDestination {
        // Square Tab Bar Screen
        let squareScreen = StepAssembly(
                finder: ClassFinder<SquareViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .usingNoAction()
                .from(goToHome().finalStep)
                .assemble()
        return ExampleDestination(finalStep: squareScreen.lastStep)

    }
    func goToColor(_ color: String) -> ExampleDestination {
        //Color screen
        let colorScreen = StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory())
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.PresentModally())
                .from(CurrentViewControllerStep())
                .assemble()
        return ExampleDestination(finalStep: colorScreen.lastStep, context: ExampleDictionaryContext(arguments: [.color: color]))

    }

    func goToRoutingSupport(_ color: String) -> ExampleDestination {
        //Screen with Routing support
        let routingSupportScreen = StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, Any?>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(goToColor(color).finalStep)
                .assemble()
        return ExampleDestination(finalStep: routingSupportScreen.lastStep, context: ExampleDictionaryContext(arguments: [.color: color]))

    }

    func goToEmptyScreen() -> ExampleDestination {
        // Empty Screen
        let emptyScreen = StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                .add(LoginInterceptor())
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(goToCircle().finalStep)
                .assemble()

        return ExampleDestination(finalStep: emptyScreen.lastStep)
    }

    func goToSecondLevelModal(_ color: String) -> ExampleDestination {
        // Two modal presentations in a row screen
        let superModalScreen = StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.PresentModally(transitioningDelegate: transitionController))
                .from(goToRoutingSupport(color).finalStep)
                .assemble()
        return ExampleDestination(finalStep: superModalScreen.lastStep, context: ExampleDictionaryContext(arguments: [.color: color]))
    }

    func goToWelcome() -> ExampleDestination {
        // Welcome Screen
        let welcomeScreen = StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen"))
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .using(GeneralAction.ReplaceRoot())
                .from(RootViewControllerStep())
                .assemble()
        return ExampleDestination(finalStep: welcomeScreen.lastStep)

    }
}

struct ExampleWireframeImpl: ExampleWireframe {

    func goToStar() -> ExampleDestination {
        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                //                .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                .add(ExampleAnalyticsPostAction())
                .add(LoginInterceptor())
                .using(TabBarControllerFactory.AddTab())
                .from(goToHome().finalStep)
                .assemble()
        return ExampleDestination(finalStep: starScreen.lastStep)
    }


}

struct AlternativeExampleWireframeImpl: ExampleWireframe {

    func goToStar() -> ExampleDestination {
        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any>(options: .currentAllStack),
                factory: XibFactory())
                //                    .add(ExampleAnalyticsInterceptor())
                .add(ExampleGenericContextTask())
                //                    .add(ExampleAnalyticsPostAction())
                .add(LoginInterceptor())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(goToCircle().finalStep)
                .assemble()
        return ExampleDestination(finalStep: starScreen.lastStep)
    }


}

// NB: Keeping the screen configurations in the Dictionary has no practical value, demo only.
class ExampleConfiguration {

    static var wireframe: ExampleWireframe = ExampleWireframeImpl()

}
