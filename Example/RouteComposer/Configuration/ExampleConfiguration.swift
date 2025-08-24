//
// RouteComposer
// ExampleConfiguration.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
#if canImport(SwiftUI)
import SwiftUI
#endif

@MainActor
let transitionController = BlurredBackgroundTransitionController()

@MainActor
protocol ExampleScreenConfiguration {

    var homeScreen: DestinationStep<UITabBarController, Any?> { get }

    var circleScreen: DestinationStep<CircleViewController, Any?> { get }

    var squareScreen: DestinationStep<SquareViewController, Any?> { get }

    var colorScreen: DestinationStep<ColorViewController, String> { get }

    var starScreen: DestinationStep<StarViewController, Any?> { get }

    var swiftUIScreen: DestinationStep<UIViewController, String> { get }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, String> { get }

    var figuresScreen: DestinationStep<FiguresViewController, Any?> { get }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, String> { get }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> { get }

    var figuresAndProductScreen: DestinationStep<ProductViewController, ProductContext> { get }

}

extension ExampleScreenConfiguration {

    var homeScreen: DestinationStep<UITabBarController, Any?> {
        StepAssembler<UITabBarController, Any?>()
            .finder(.classFinder(options: .current, startingPoint: .root))
            .factory(.storyboardFactory(name: "TabBar"))
            .using(CATransaction.wrap(GeneralAction.replaceRoot(animationOptions: .transitionFlipFromLeft)))
            // `CATransaction.wrap(...)` is here just for the testing purposes and not needed in the real app
            .from(.root)
            .assemble()
    }

    var circleScreen: DestinationStep<CircleViewController, Any?> {
        StepAssembler<CircleViewController, Any?>()
            .finder(.classFinder)
            .factory(.nilFactory)
            .adding(ExampleGenericContextTask<CircleViewController, Any?>())
            .from(homeScreen)
            .assemble()
    }

    var squareScreen: DestinationStep<SquareViewController, Any?> {
        StepAssembler<SquareViewController, Any?>()
            .finder(.classFinder)
            .factory(.nilFactory)
            .adding(ExampleGenericContextTask<SquareViewController, Any?>())
            .from(homeScreen)
            .assemble()
    }

    var colorScreen: DestinationStep<ColorViewController, String> {
        StepAssembler<ColorViewController, String>()
            .finder(ColorViewControllerFinder())
            .factory(ColorViewControllerFactory())
            .adding(DismissalMethodProvidingContextTask<ColorViewController, String>(dismissalBlock: { viewController, context, animated, completion in
                // Demonstrates ability to provide a dismissal method in the configuration using `DismissalMethodProvidingContextTask`
                UIViewController.router.commitNavigation(to: GeneralStep.custom(using: PresentingFinder(startingPoint: .custom(viewController))),
                                                         with: context,
                                                         animated: animated,
                                                         completion: completion)
                // You can just call `viewController.dismiss(animated: true) if needed.`
            }))
            .adding(ExampleGenericContextTask<ColorViewController, String>())
            .using(ExampleNavigationController.push())
            .from(SingleContainerStep(finder: NilFinder(), factory: NavigationControllerFactory<ExampleNavigationController, String>()))
            .using(.present)
            .from(.current)
            .assemble()
    }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, String> {
        StepAssembler<RoutingRuleSupportViewController, String>()
            .finder(.classFinder(options: .currentAllStack))
            .factory(.storyboardFactory(name: "TabBar", identifier: "RoutingRuleSupportViewController"))
            .adding(ExampleGenericContextTask<RoutingRuleSupportViewController, String>())
            .using(.addTab)
            .from(.tabBarController)
            .using(.push)
            .from(colorScreen.expectingContainer())
            .assemble()
    }

    var figuresScreen: DestinationStep<FiguresViewController, Any?> {
        StepAssembler<FiguresViewController, Any?>()
            .finder(.classFinder)
            .factory(.storyboardFactory(name: "TabBar", identifier: "FiguresViewController"))
            .adding(LoginInterceptor<Any?>())
            .adding(ExampleGenericContextTask<FiguresViewController, Any?>())
            .using(CATransaction.wrap(UINavigationController.push())) // `CATransaction.wrap(...)` here is for test purposes only
            .from(circleScreen.expectingContainer())
            .assemble()
    }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, String> {
        StepAssembler<SecondModalLevelViewController, String>()
            .finder(.classFinder)
            .factory(.storyboardFactory(name: "TabBar", identifier: "SecondModalLevelViewController"))
            .adding(ExampleGenericContextTask<SecondModalLevelViewController, String>())
            .using(.push)
            .from(.navigationController)
            .using( // `topmostParent` and `overCurrentContext` are set for the test purposes only
                .present(startingFrom: .topmostParent,
                                             presentationStyle: .overCurrentContext,
                                             transitioningDelegate: transitionController))
            .from(routingSupportScreen)
            .assemble()
    }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> {
          StepAssembler<PromptViewController, Any?>()
            .finder(.classFinder)
            .factory(.storyboardFactory(name: "PromptScreen"))
            .adding(ExampleGenericContextTask<PromptViewController, Any?>())
            .using(.replaceRoot)
            .from(.root)
            .assemble()
    }

    var figuresAndProductScreen: DestinationStep<ProductViewController, ProductContext> {
        StepAssembler<ProductViewController, ProductContext>()
            .finder(.classWithContextFinder)
            .factory(.storyboardFactory(name: "TabBar", identifier: "ProductViewController"))
            .adding(ContextSettingTask())
            .using(.push)
            .assemble(from: figuresScreen.expectingContainer())
    }

    var swiftUIScreen: DestinationStep<UIViewController, String> {
        guard #available(iOS 13.0, *) else {
            return starScreen.unsafelyRewrapped()
        }

        return StepAssembler<UIHostingController<SwiftUIContentView>, String>()
            .finder(.hostingControllerWithContextFinder)
            .factory(.hostingControllerWithContextFactory)
            .adding(ExampleGenericContextTask<UIHostingController<SwiftUIContentView>, String>())
            .adding(ContextSettingTask())
            .using(.push)
            .from(circleScreen.expectingContainer())
            .assemble().unsafelyRewrapped()
    }

}

struct ExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        StepAssembler<StarViewController, Any?>()
            .finder(.classFinder(options: .current))
            .factory(.classFactory)
            .adding(ExampleGenericContextTask<StarViewController, Any?>())
            .adding(LoginInterceptor<Any?>())
            .using(.addTab)
            .from(homeScreen)
            .assemble()
    }

}

struct AlternativeExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        StepAssembler<StarViewController, Any?>()
            .finder(.classFinder(options: .currentAllStack))
            .factory(.classFactory)
            .adding(ExampleGenericContextTask<StarViewController, Any?>())
            .adding(LoginInterceptor())
            .using(.push)
            .from(circleScreen.expectingContainer())
            .assemble()
    }

}

enum ConfigurationHolder {

    // Declared as static to avoid dependency injection in the Example app. So this variable is available everywhere.
    @MainActor
    static var configuration: ExampleScreenConfiguration = ExampleConfiguration()

}
