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

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, Any?> { get }

    var emptyScreen: DestinationStep<EmptyViewController, Any?> { get }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, Any?> { get }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> { get }

}

extension ExampleScreenConfiguration {

    var homeScreen: DestinationStep<UITabBarController, Any?> {
        return StepAssembly(
                // Because both factory and finder are Generic, You have to provide to at least one instance
                // what type of view controller and context to expect. You do not need to do so if you are using at
                // least one custom factory of finder that have set typealias for ViewController and Context.
                finder: ClassFinder<UITabBarController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar"))
                .using(GeneralAction.replaceRoot())
                .from(GeneralStep.root())
                .assemble()
    }

    var circleScreen: DestinationStep<CircleViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<CircleViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleGenericContextTask<CircleViewController, Any?>())
                .from(homeScreen)
                .assemble()
    }

    var squareScreen: DestinationStep<SquareViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<SquareViewController, Any?>(options: .currentAllStack),
                factory: NilFactory())
                .add(ExampleGenericContextTask<SquareViewController, Any?>())
                .from(homeScreen)
                .assemble()
    }

    var colorScreen: DestinationStep<ColorViewController, String> {
        return StepAssembly(
                finder: ColorViewControllerFinder(),
                factory: ColorViewControllerFactory())
                .add(ExampleGenericContextTask<ColorViewController, String>())
                .using(NavigationControllerFactory.pushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally())
                .from(GeneralStep.current())
                .assemble()
    }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, Any?>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                .add(ExampleGenericContextTask<RoutingRuleSupportViewController, Any?>())
                .using(NavigationControllerFactory.pushToNavigation())
                .within(colorScreen)
                .assemble()
    }

    var emptyScreen: DestinationStep<EmptyViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                .add(LoginInterceptor<Any?>())
                .add(ExampleGenericContextTask<EmptyViewController, Any?>())
                .using(NavigationControllerFactory.pushToNavigation())
                .within(circleScreen)
                .assemble()
    }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                .add(ExampleGenericContextTask<SecondModalLevelViewController, Any?>())
                .using(NavigationControllerFactory.pushToNavigation())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally(transitioningDelegate: transitionController))
                .from(routingSupportScreen)
                .assemble()
    }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<PromptViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "PromptScreen"))
                .add(ExampleGenericContextTask<PromptViewController, Any?>())
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
                .add(ExampleGenericContextTask<StarViewController, Any?>())
                .add(LoginInterceptor<Any?>())
                .using(TabBarControllerFactory.addTab())
                .from(homeScreen)
                .assemble()
    }

}

struct AlternativeExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                factory: XibFactory())
                .add(ExampleGenericContextTask<StarViewController, Any?>())
                .add(LoginInterceptor())
                .using(NavigationControllerFactory.pushToNavigation())
                .within(circleScreen)
                .assemble()
    }

}

class ConfigurationHolder {

    // Declared as static to avoid dependency injection in the Example app. So this variable is available everywhere.
    static var configuration: ExampleScreenConfiguration = ExampleConfiguration()

}
