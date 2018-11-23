//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

let transitionController = BlurredBackgroundTransitionController()

protocol ExampleScreenConfiguration {

    var homeScreen: DestinationStep<UITabBarController, Any?> { get }

    var circleScreen: DestinationStep<CircleViewController, Any?> { get }

    var squareScreen: DestinationStep<SquareViewController, Any?> { get }

    var colorScreen: DestinationStep<ColorViewController, String> { get }

    var starScreen: DestinationStep<StarViewController, Any?> { get }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, String> { get }

    var emptyScreen: DestinationStep<EmptyViewController, Any?> { get }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, String> { get }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> { get }

}

extension ExampleScreenConfiguration {

    var homeScreen: DestinationStep<UITabBarController, Any?> {
        return StepAssembly(
                // As both factory and finder are generic, You have to provide with at least one instance
                // the type of the view controller and the context to be used. You do not need to do so if you are using at
                // least one custom factory of finder that have set typealias for ViewController and Context.
                // We may have 2 UITabBarControllers in the stack (see routingSupportScreen config). We can distinguish them only by their position.
                // We call `home` only the one that is the window's root controller
                finder: ClassFinder<UITabBarController, Any?>(options: .current, startingPoint: .root),
                factory: StoryboardFactory(storyboardName: "TabBar"))
                .using(GeneralAction.replaceRoot())
                .from(GeneralStep.root())
                .assemble()
    }

    var circleScreen: DestinationStep<CircleViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<CircleViewController, Any?>(),
                factory: NilFactory())
                .adding(ExampleGenericContextTask<CircleViewController, Any?>())
                .from(homeScreen)
                .assemble()
    }

    var squareScreen: DestinationStep<SquareViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<SquareViewController, Any?>(),
                factory: NilFactory())
                .adding(ExampleGenericContextTask<SquareViewController, Any?>())
                .from(homeScreen)
                .assemble()
    }

    var colorScreen: DestinationStep<ColorViewController, String> {
        return StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory())
                .adding(ExampleGenericContextTask<ColorViewController, String>())
                .using(ExampleNavigationController.push())
                .from(SingleContainerStep(finder: NilFinder(), factory: ExampleNavigationFactory<String>()))
                .using(GeneralAction.presentModally())
                .from(GeneralStep.current())
                .assemble()
    }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, String> {
        return StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, String>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                .adding(ExampleGenericContextTask<RoutingRuleSupportViewController, String>())
                .using(UITabBarController.add())
                .from(TabBarControllerStep())
                .using(UINavigationController.push())
                .from(colorScreen.expectingContainer())
                .assemble()
    }

    var emptyScreen: DestinationStep<EmptyViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                .adding(LoginInterceptor<Any?>())
                .adding(ExampleGenericContextTask<EmptyViewController, Any?>())
                .using(UINavigationController.push())
                .from(circleScreen.expectingContainer())
                .assemble()
    }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, String> {
        return StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, String>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                .adding(ExampleGenericContextTask<SecondModalLevelViewController, String>())
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally(transitioningDelegate: transitionController))
                .from(routingSupportScreen)
                .assemble()
    }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen"))
                .adding(ExampleGenericContextTask<PromptViewController, Any?>())
                .using(GeneralAction.replaceRoot())
                .from(GeneralStep.root())
                .assemble()
    }

}

struct ExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .adding(ExampleGenericContextTask<StarViewController, Any?>())
                .adding(LoginInterceptor<Any?>())
                .using(UITabBarController.add())
                .from(homeScreen)
                .assemble()
    }

}

struct AlternativeExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .adding(ExampleGenericContextTask<StarViewController, Any?>())
                .adding(LoginInterceptor())
                .using(UINavigationController.push())
                .from(circleScreen.expectingContainer())
                .assemble()
    }

}

class ConfigurationHolder {

    // Declared as static to avoid dependency injection in the Example app. So this variable is available everywhere.
    static var configuration: ExampleScreenConfiguration = ExampleConfiguration()

}
