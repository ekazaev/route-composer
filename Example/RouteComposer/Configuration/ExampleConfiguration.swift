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
        return DestinationAssembly(from: GeneralStep.root())
                .using(GeneralAction.replaceRoot())
                .present(SingleStep(finder: HomeFinder(), factory: StoryboardFactory(storyboardName: "TabBar")))
                .assemble()
    }

    var circleScreen: DestinationStep<CircleViewController, Any?> {
        return ContainerDestinationAssembly(from: homeScreen)
                .inside()
                .present(SingleStep(finder: ClassFinder<CircleViewController, Any?>(), factory: NilFactory())
                        .adding(ExampleGenericContextTask<CircleViewController, Any?>()))
                .assemble()
    }

    var squareScreen: DestinationStep<SquareViewController, Any?> {
        return ContainerDestinationAssembly(from: homeScreen)
                .inside()
                .present(SingleStep(finder: ClassFinder<SquareViewController, Any?>(), factory: NilFactory())
                        .adding(ExampleGenericContextTask<SquareViewController, Any?>()))
                .assemble()
    }

    var colorScreen: DestinationStep<ColorViewController, String> {
        return DestinationAssembly<String>(from: GeneralStep.current())
                .using(GeneralAction.presentModally())
                .present(SingleContainerStep(finder: NilFinder<ExampleNavigationController, String>(), factory: ExampleNavigationFactory<String>()))
                .using(ExampleNavigationController.pushToNavigation())
                .present(SingleStep(finder: ColorViewControllerFinder(), factory: ColorViewControllerFactory())
                        .adding(ExampleGenericContextTask<ColorViewController, String>()))
                .assemble()
    }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, String> {
        return ContainerDestinationAssembly<UINavigationController, String>(from: colorScreen.expectingContainer())
                .using(UINavigationController.pushToNavigation())
                .present(TabBarControllerStep())
                .using(UITabBarController.addTab())
                .present(SingleStep(
                        finder: ClassFinder<RoutingRuleSupportViewController, String>(options: .currentAllStack),
                        factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "RoutingRuleSupportViewController"))
                        .adding(ExampleGenericContextTask<RoutingRuleSupportViewController, String>()))
                .assemble()
    }

    var emptyScreen: DestinationStep<EmptyViewController, Any?> {
        return ContainerDestinationAssembly<UINavigationController, Any?>(from: circleScreen.expectingContainer())
                .using(UINavigationController.pushToNavigation())
                .present(SingleStep(
                        finder: ClassFinder<EmptyViewController, Any?>(),
                        factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "EmptyViewController"))
                        .adding(LoginInterceptor<Any?>())
                        .adding(ExampleGenericContextTask<EmptyViewController, Any?>()))
                .assemble()
    }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, String> {
        return DestinationAssembly(from: routingSupportScreen)
                .using(GeneralAction.presentModally(transitioningDelegate: transitionController))
                .present(NavigationControllerStep())
                .using(UINavigationController.pushToNavigation())
                .present(SingleStep(
                        finder: ClassFinder<SecondModalLevelViewController, String>(),
                        factory: StoryboardFactory(storyboardName: "TabBar", viewControllerID: "SecondModalLevelViewController"))
                        .adding(ExampleGenericContextTask<SecondModalLevelViewController, String>()))
                .assemble()
    }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> {
        return DestinationAssembly(from: GeneralStep.root())
                .using(GeneralAction.replaceRoot())
                .present(SingleStep(
                        finder: ClassFinder<PromptViewController, Any?>(),
                        factory: StoryboardFactory(storyboardName: "PromptScreen"))
                        .adding(ExampleGenericContextTask<PromptViewController, Any?>()))
                .assemble()
    }

}

struct ExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        return ContainerDestinationAssembly(from: homeScreen)
                .using(UITabBarController.addTab())
                .present(SingleStep(
                        finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                        factory: XibFactory())
                        .adding(ExampleGenericContextTask<StarViewController, Any?>())
                        .adding(LoginInterceptor<Any?>()))
                .assemble()
    }

}

struct AlternativeExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        return ContainerDestinationAssembly<UINavigationController, Any?>(from: circleScreen.expectingContainer())
            .using(UINavigationController.pushToNavigation())
            .present(SingleStep(
                    finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
                    factory: XibFactory())
                    .adding(ExampleGenericContextTask<StarViewController, Any?>())
                    .adding(LoginInterceptor()))
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
