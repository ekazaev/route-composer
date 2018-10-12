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
                finder: HomeFinder(),
                factory: StoryboardFactory(storyboardName: "TabBar"))
                .using(GeneralAction.replaceRoot())
                .from(GeneralStep.root())
                .assemble()
    }

    var circleScreen: DestinationStep<CircleViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<CircleViewController, Any?>(),
                factory: NilFactory())
                .add(ExampleGenericContextTask<CircleViewController, Any?>())
                .from(homeScreen)
                .assemble()
    }

    var squareScreen: DestinationStep<SquareViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<SquareViewController, Any?>(),
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
                .using(ExampleNavigationController.pushToNavigation())
                .from(SingleContainerStep(finder: NilFinder(), factory: ExampleNavigationFactory<String>()))
                .using(GeneralAction.presentModally())
                .from(GeneralStep.current())
                .assemble()
    }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, String> {
        return StepAssembly(
                finder: ClassFinder<RoutingRuleSupportViewController, String>(options: .currentAllStack),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                .add(ExampleGenericContextTask<RoutingRuleSupportViewController, String>())
                .using(UITabBarController.addTab())
                .from(TabBarControllerStep())
                .using(UINavigationController.pushToNavigation())
                .from(colorScreen.expectingContainer())
                .assemble()
    }

    var emptyScreen: DestinationStep<EmptyViewController, Any?> {
        return StepAssembly(
                finder: ClassFinder<EmptyViewController, Any?>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                .add(LoginInterceptor<Any?>())
                .add(ExampleGenericContextTask<EmptyViewController, Any?>())
                .using(UINavigationController.pushToNavigation())
                .from(circleScreen.expectingContainer())
                .assemble()
    }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, String> {
        return StepAssembly(
                finder: ClassFinder<SecondModalLevelViewController, String>(),
                factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                .add(ExampleGenericContextTask<SecondModalLevelViewController, String>())
                .using(UINavigationController.pushToNavigation())
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
                .using(UITabBarController.addTab())
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
                .using(UINavigationController.pushToNavigation())
                .from(circleScreen.expectingContainer())
                .assemble()
    }

}

class ConfigurationHolder {

    // Declared as static to avoid dependency injection in the Example app. So this variable is available everywhere.
    static var configuration: ExampleScreenConfiguration = ExampleConfiguration()

}

// We may have 2 UITabBarControllers in the stack (see routingSupportScreen config). We can distinguish them only by their position.
// We call `home` only the one that is the window's root controller
private struct HomeFinder: StackIteratingFinder {

    let options: SearchOptions = .currentAndDown

    func isTarget(_ viewController: UITabBarController, with context: Any?) -> Bool {
        return UIWindow.key?.rootViewController == viewController
    }

}
