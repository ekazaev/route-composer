//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

let transitionController = BlurredBackgroundTransitionController()

protocol ExampleWireframe {

    func goToHome() -> ExampleDestination<Any?>

    func goToCircle() -> ExampleDestination<Any?>

    func goToSquare() -> ExampleDestination<Any?>

    func goToColor(_ color: String) -> ExampleDestination<ExampleDictionaryContext>

    func goToStar() -> ExampleDestination<Any?>

    func goToRoutingSupport(_ color: String) -> ExampleDestination<Any?>

    func goToEmptyScreen() -> ExampleDestination<Any?>

    func goToSecondLevelModal(_ color: String) -> ExampleDestination<Any?>

    func goToWelcome() -> ExampleDestination<Any?>

}

extension ExampleWireframe {

    func goToHome() -> ExampleDestination<Any?> {
        // Home Tab Bar Screen
        let homeScreen = StepAssembly(
                // Because both factory and finder are Generic, You have to provide to at least one instance
                // what type of view controller and context to expect. You do not need to do so if you are using at
                // least one custom factory of finder that have set typealias for ViewController and Context.
                finder: ClassFinder<UITabBarController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar"))
                .using(GeneralAction.ReplaceRoot())
                .from(GeneralStep.root())
                .assemble()
        return ExampleDestination(step: homeScreen, context: nil)
    }

    func goToCircle() -> ExampleDestination<Any?> {
        // Circle Tab Bar screen
        let circleScreen = StepAssembly(
                finder: ClassFinder<CircleViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleGenericContextTask())
                .usingNoAction()
                .from(goToHome().destination)
                .assemble()

        return ExampleDestination(step: circleScreen, context: nil)
    }

    func goToSquare() -> ExampleDestination<Any?> {
        // Square Tab Bar Screen
        let squareScreen = StepAssembly(
                finder: ClassFinder<SquareViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleGenericContextTask())
                .usingNoAction()
                .from(goToHome().destination)
                .assemble()
        return ExampleDestination(step: squareScreen, context: nil)

    }
    func goToColor(_ color: String) -> ExampleDestination<ExampleDictionaryContext> {
        //Color screen
        let colorScreen = StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory())
                .add(ExampleGenericContextTask())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.PresentModally())
                .from(GeneralStep.current())
                .assemble()
        return ExampleDestination(step: colorScreen, context: ExampleDictionaryContext(arguments: [.color: color]))

    }

    func goToRoutingSupport(_ color: String) -> ExampleDestination<Any?> {
        //Screen with Routing support
        let routingSupportScreen = StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, Any?>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                .add(ExampleGenericContextTask())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(goToColor(color).destination)
                .assemble()
        return ExampleDestination(step: routingSupportScreen, context: ExampleDictionaryContext(arguments: [.color: color]))

    }

    func goToEmptyScreen() -> ExampleDestination<Any?> {
        // Empty Screen
        let emptyScreen = StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                .add(LoginInterceptor())
                .add(ExampleGenericContextTask())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(goToCircle().destination)
                .assemble()

        return ExampleDestination(step: emptyScreen, context: nil)
    }

    func goToSecondLevelModal(_ color: String) -> ExampleDestination<Any?> {
        // Two modal presentations in a row screen
        let superModalScreen = StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                .add(ExampleGenericContextTask())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.PresentModally(transitioningDelegate: transitionController))
                .from(goToRoutingSupport(color).destination)
                .assemble()
        return ExampleDestination(step: superModalScreen, context: ExampleDictionaryContext(arguments: [.color: color]))
    }

    func goToWelcome() -> ExampleDestination<Any?> {
        // Welcome Screen
        let welcomeScreen = StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen"))
                .add(ExampleGenericContextTask())
                .using(GeneralAction.ReplaceRoot())
                .from(GeneralStep.root())
                .assemble()
        return ExampleDestination(step: welcomeScreen, context: nil)

    }
}

struct ExampleWireframeImpl: ExampleWireframe {

    func goToStar() -> ExampleDestination<Any?> {
        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .add(ExampleGenericContextTask())
                .add(LoginInterceptor())
                .using(TabBarControllerFactory.AddTab())
                .from(goToHome().destination)
                .assemble()
        return ExampleDestination(step: starScreen, context: nil)
    }

}

struct AlternativeExampleWireframeImpl: ExampleWireframe {

    func goToStar() -> ExampleDestination<Any?> {
        //Star screen
        let starScreen = StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .add(ExampleGenericContextTask())
                .add(LoginInterceptor())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(goToCircle().destination)
                .assemble()
        return ExampleDestination(step: starScreen, context: nil)
    }

}

// NB: Keeping the screen configurations in the Dictionary has no practical value, demo only.
class ExampleConfiguration {

    static var wireframe: ExampleWireframe = ExampleWireframeImpl()

}
