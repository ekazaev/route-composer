//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

let transitionController = BlurredBackgroundTransitionController()

protocol ExampleWireframe {

    func goToHome() -> ExampleDestination<UITabBarController, Any?>

    func goToCircle() -> ExampleDestination<CircleViewController, Any?>

    func goToSquare() -> ExampleDestination<SquareViewController, Any?>

    func goToColor(_ color: String) -> ExampleDestination<ColorViewController, ExampleDictionaryContext>

    func goToStar() -> ExampleDestination<StarViewController, Any?>

    func goToRoutingSupport(_ color: String) -> ExampleDestination<RoutingRuleSupportViewController, Any?>

    func goToEmptyScreen() -> ExampleDestination<EmptyViewController, Any?>

    func goToSecondLevelModal(_ color: String) -> ExampleDestination<SecondModalLevelViewController, Any?>

    func goToWelcome() -> ExampleDestination<PromptViewController, Any?>

}

extension ExampleWireframe {

    func goToHome() -> ExampleDestination<UITabBarController, Any?> {
        // Home Tab Bar Screen
        let homeScreen = StepAssembly(
                // Because both factory and finder are Generic, You have to provide to at least one instance
                // what type of view controller and context to expect. You do not need to do so if you are using at
                // least one custom factory of finder that have set typealias for ViewController and Context.
                finder: ClassFinder<UITabBarController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar"))
                .using(GeneralAction.replaceRoot())
                .from(GeneralStep.root())
                .assemble()
        return ExampleDestination(step: homeScreen, context: nil)
    }

    func goToCircle() -> ExampleDestination<CircleViewController, Any?> {
        // Circle Tab Bar screen
        let circleScreen = StepAssembly(
                finder: ClassFinder<CircleViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleGenericContextTask<CircleViewController, Any?>())
                .from(goToHome().step)
                .assemble()

        return ExampleDestination(step: circleScreen, context: nil)
    }

    func goToSquare() -> ExampleDestination<SquareViewController, Any?> {
        // Square Tab Bar Screen
        let squareScreen = StepAssembly(
                finder: ClassFinder<SquareViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleGenericContextTask<SquareViewController, Any?>())
                .from(goToHome().step)
                .assemble()
        return ExampleDestination(step: squareScreen, context: nil)

    }

    func goToColor(_ color: String) -> ExampleDestination<ColorViewController, ExampleDictionaryContext> {
        //Color screen
        let colorScreen = StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory())
                .add(ExampleGenericContextTask<ColorViewController, ExampleDictionaryContext>())
                .using(NavigationControllerFactory.pushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally())
                .from(GeneralStep.current())
                .assemble()
        return ExampleDestination(step: colorScreen, context: ExampleDictionaryContext(arguments: [.color: color]))

    }

    func goToRoutingSupport(_ color: String) -> ExampleDestination<RoutingRuleSupportViewController, Any?> {
        //Screen with Routing support
        let routingSupportScreen = StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, Any?>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                .add(ExampleGenericContextTask<RoutingRuleSupportViewController, Any?>())
                .using(NavigationControllerFactory.pushToNavigation())
                .within(goToColor(color).step)
                .assemble()
        return ExampleDestination(step: routingSupportScreen, context: ExampleDictionaryContext(arguments: [.color: color]))

    }

    func goToEmptyScreen() -> ExampleDestination<EmptyViewController, Any?> {
        // Empty Screen
        let emptyScreen = StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                .add(LoginInterceptor<Any?>())
                .add(ExampleGenericContextTask<EmptyViewController, Any?>())
                .using(NavigationControllerFactory.pushToNavigation())
                .within(goToCircle().step)
                .assemble()

        return ExampleDestination(step: emptyScreen, context: nil)
    }

    func goToSecondLevelModal(_ color: String) -> ExampleDestination<SecondModalLevelViewController, Any?> {
        // Two modal presentations in a row screen
        let superModalScreen = StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                .add(ExampleGenericContextTask<SecondModalLevelViewController, Any?>())
                .using(NavigationControllerFactory.pushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally(transitioningDelegate: transitionController))
                .from(goToRoutingSupport(color).step)
                .assemble()

        return ExampleDestination(step: superModalScreen, context: ExampleDictionaryContext(arguments: [.color: color]))
    }

    func goToWelcome() -> ExampleDestination<PromptViewController, Any?> {
        // Welcome Screen
        let welcomeScreen = StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen"))
                .add(ExampleGenericContextTask<PromptViewController, Any?>())
                .using(GeneralAction.replaceRoot())
                .from(GeneralStep.root())
                .assemble()
        return ExampleDestination(step: welcomeScreen, context: nil)

    }
}

struct ExampleWireframeImpl: ExampleWireframe {

    func goToStar() -> ExampleDestination<StarViewController, Any?> {
        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .add(ExampleGenericContextTask<StarViewController, Any?>())
                .add(LoginInterceptor<Any?>())
                .using(TabBarControllerFactory.addTab())
                .from(goToHome().step)
                .assemble()
        return ExampleDestination(step: starScreen, context: nil)
    }

}

struct AlternativeExampleWireframeImpl: ExampleWireframe {

    func goToStar() -> ExampleDestination<StarViewController, Any?> {
        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .add(ExampleGenericContextTask<StarViewController, Any?>())
                .add(LoginInterceptor())
                .using(NavigationControllerFactory.pushToNavigation())
                .within(goToCircle().step)
                .assemble()
        return ExampleDestination(step: starScreen, context: nil)
    }

}

class ExampleConfiguration {

    // Declared as static to avoid dependency injection in the Example app. So this variable is available everywhere.
    static var wireframe: ExampleWireframe = ExampleWireframeImpl()

}
