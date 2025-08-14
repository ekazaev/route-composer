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
        StepAssembly(
            // As both factory and finder are generic, You have to provide with at least one instance
            // the type of the view controller and the context to be used. You do not need to do so if you are using at
            // least one custom factory of finder that have set typealias for ViewController and Context.
            finder: ClassFinder<UITabBarController, Any?>(options: .current, startingPoint: .root),
            factory: StoryboardFactory(name: "TabBar"))
            .using(CATransaction.wrap(GeneralAction.replaceRoot(animationOptions: .transitionFlipFromLeft)))
            // `CATransaction.wrap(...)` is here just for the testing purposes and not needed in the real app
            .from(GeneralStep.root())
            .assemble()
    }

    var circleScreen: DestinationStep<CircleViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<CircleViewController, Any?>(),
            factory: NilFactory())
            .adding(ExampleGenericContextTask<CircleViewController, Any?>())
            .from(homeScreen)
            .assemble()
    }

    var squareScreen: DestinationStep<SquareViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<SquareViewController, Any?>(),
            factory: NilFactory())
            .adding(ExampleGenericContextTask<SquareViewController, Any?>())
            .from(homeScreen)
            .assemble()
    }

    var colorScreen: DestinationStep<ColorViewController, String> {
        StepAssembly(
            finder: ColorViewControllerFinder(),
            factory: ColorViewControllerFactory())
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
            .from(GeneralStep.current())
            .assemble()
    }

    var routingSupportScreen: DestinationStep<RoutingRuleSupportViewController, String> {
        StepAssembly(
            finder: ClassFinder<RoutingRuleSupportViewController, String>(options: .currentAllStack),
            factory: StoryboardFactory(name: "TabBar", identifier: "RoutingRuleSupportViewController"))
            .adding(ExampleGenericContextTask<RoutingRuleSupportViewController, String>())
            .using(UITabBarController.add())
            .from(TabBarControllerStep())
            .using(UINavigationController.push())
            .from(colorScreen.expectingContainer())
            .assemble()
    }

    var figuresScreen: DestinationStep<FiguresViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<FiguresViewController, Any?>(),
            factory: StoryboardFactory(name: "TabBar", identifier: "FiguresViewController"))
            .adding(LoginInterceptor<Any?>())
            .adding(ExampleGenericContextTask<FiguresViewController, Any?>())
            .using(CATransaction.wrap(UINavigationController.push())) // `CATransaction.wrap(...)` here is for test purposes only
            .from(circleScreen.expectingContainer())
            .assemble()
    }

    var secondModalScreen: DestinationStep<SecondModalLevelViewController, String> {
        StepAssembly(
            finder: ClassFinder<SecondModalLevelViewController, String>(),
            factory: StoryboardFactory(name: "TabBar", identifier: "SecondModalLevelViewController"))
            .adding(ExampleGenericContextTask<SecondModalLevelViewController, String>())
            .using(UINavigationController.push())
            .from(NavigationControllerStep())
            .using( // `topmostParent` and `overCurrentContext` are set for the test purposes only
                .present(startingFrom: .topmostParent,
                                             presentationStyle: .overCurrentContext,
                                             transitioningDelegate: transitionController))
            .from(routingSupportScreen)
            .assemble()
    }

    var welcomeScreen: DestinationStep<PromptViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<PromptViewController, Any?>(),
            factory: StoryboardFactory(name: "PromptScreen"))
            .adding(ExampleGenericContextTask<PromptViewController, Any?>())
            .using(.replaceRoot)
            .from(GeneralStep.root())
            .assemble()
    }

    var figuresAndProductScreen: DestinationStep<ProductViewController, ProductContext> {
        StepAssembly(
            finder: ClassWithContextFinder<ProductViewController, ProductContext>(),
            factory: StoryboardFactory(name: "TabBar", identifier: "ProductViewController"))
            .adding(ContextSettingTask())
            .using(UINavigationController.push())
            .assemble(from: figuresScreen.expectingContainer())
    }

    var swiftUIScreen: DestinationStep<UIViewController, String> {
        guard #available(iOS 13.0, *) else {
            return starScreen.unsafelyRewrapped()
        }
        return StepAssembly(
            finder: UIHostingControllerWithContextFinder<SwiftUIContentView>(),
            factory: UIHostingControllerWithContextFactory())
            .adding(ExampleGenericContextTask<UIHostingController<SwiftUIContentView>, String>())
            .adding(ContextSettingTask())
            .using(UINavigationController.push())
            .from(circleScreen.expectingContainer())
            .assemble().unsafelyRewrapped()
    }

}

struct ExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
            factory: ClassFactory())
            .adding(ExampleGenericContextTask<StarViewController, Any?>())
            .adding(LoginInterceptor<Any?>())
            .using(UITabBarController.add())
            .from(homeScreen)
            .assemble()
    }

}

struct AlternativeExampleConfiguration: ExampleScreenConfiguration {

    var starScreen: DestinationStep<StarViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<StarViewController, Any?>(options: .currentAllStack),
            factory: ClassFactory())
            .adding(ExampleGenericContextTask<StarViewController, Any?>())
            .adding(LoginInterceptor())
            .using(UINavigationController.push())
            .from(circleScreen.expectingContainer())
            .assemble()
    }

}

enum ConfigurationHolder {

    // Declared as static to avoid dependency injection in the Example app. So this variable is available everywhere.
    @MainActor
    static var configuration: ExampleScreenConfiguration = ExampleConfiguration()

}
