//
// RouteComposer
// DestinationStepTests.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

@testable import RouteComposer
import UIKit
import XCTest

//class DestinationStepTests: XCTestCase {
//
//    struct TestFinder<VC: UIViewController, C>: Finder {
//
//        func findViewController(with context: C) throws -> VC? {
//            nil
//        }
//
//    }
//
//    func testExpectingContainer() {
//        let nonContainerStepInsideContainer = StepAssembly(finder: TestFinder<UIViewController, Any?>(), factory: NilFactory())
//            .using(UINavigationController.push())
//            .from(NavigationControllerStep())
//            .using(GeneralAction.presentModally())
//            .assemble(from: GeneralStep.current())
//
//        let step: DestinationStep<UINavigationController, Any?> = nonContainerStepInsideContainer.expectingContainer()
//
//        // Will work as this step can accept anything(Any?)
//        let _: DestinationStep<UINavigationController, String> = nonContainerStepInsideContainer.expectingContainer()
//        let _: DestinationStep<UINavigationController, Void> = nonContainerStepInsideContainer.expectingContainer()
//
//        // Will compile but will not work in runtime.
//        let _: DestinationStep<UITabBarController, Any?> = nonContainerStepInsideContainer.expectingContainer()
//
//        XCTAssertNoThrow(try (step.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertNoThrow(try (step.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertNoThrow(try (step.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: ()))
//    }
//
//    func testExpectingContainerStronglyTyped() {
//        let nonContainerStepInsideContainer = StepAssembly(finder: TestFinder<UIViewController, String>(), factory: NilFactory())
//            .using(UINavigationController.push())
//            .from(NavigationControllerStep())
//            .using(GeneralAction.presentModally())
//            .assemble(from: GeneralStep.current())
//
//        let step: DestinationStep<UINavigationController, String> = nonContainerStepInsideContainer.expectingContainer()
//        // Will not work as this step can not accept Int
//        // let _: DestinationStep<UINavigationController, Int> = nonContainerStepInsideContainer.asContainerWitness()
//
//        // Will compile but will not work in runtime.
//        let _: DestinationStep<UITabBarController, String> = nonContainerStepInsideContainer.expectingContainer()
//
//        XCTAssertNoThrow(try (step.getPreviousStep(with: "") as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertThrowsError(try (step.getPreviousStep(with: "") as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertThrowsError(try (step.getPreviousStep(with: "") as? PerformableStep)?.perform(with: ()))
//    }
//
//    func testAdaptingContext() {
//        let nonContainerStepInsideContainer = StepAssembly(finder: TestFinder<UINavigationController, Any?>(), factory: ClassFactory())
//            .using(GeneralAction.presentModally())
//            .assemble(from: GeneralStep.current())
//
//        let step1: DestinationStep<UINavigationController, String> = nonContainerStepInsideContainer.adaptingContext()
//        let step2: DestinationStep<UINavigationController, Void> = nonContainerStepInsideContainer.adaptingContext()
//        XCTAssertNoThrow(try (step1.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertNoThrow(try (step2.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertNoThrow(try (step1.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertNoThrow(try (step2.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertNoThrow(try (step1.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: ()))
//        XCTAssertNoThrow(try (step2.getPreviousStep(with: nil as Any?) as? PerformableStep)?.perform(with: ()))
//    }
//
//    func testSingleStepExpectingContainer() {
//        let nonContainerStepInsideContainer = SingleStep(finder: TestFinder<UIViewController, Any?>(), factory: NilFactory())
//
//        let step: ActionToStepIntegrator<UINavigationController, Any?> = nonContainerStepInsideContainer.expectingContainer()
//
//        // Will work as this step can accept anything(Any?)
//        let _: ActionToStepIntegrator<UINavigationController, String> = nonContainerStepInsideContainer.expectingContainer()
//        let _: ActionToStepIntegrator<UINavigationController, Void> = nonContainerStepInsideContainer.expectingContainer()
//
//        // Will compile but will not work in runtime.
//        let _: ActionToStepIntegrator<UITabBarController, Any?> = nonContainerStepInsideContainer.expectingContainer()
//
//        XCTAssertNoThrow(try (step.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertNoThrow(try (step.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertNoThrow(try (step.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: ()))
//    }
//
//    func testSingleStepExpectingContainerStronglyTyped() {
//        let nonContainerStepInsideContainer = SingleStep(finder: TestFinder<UIViewController, String>(), factory: NilFactory())
//
//        let step: ActionToStepIntegrator<UINavigationController, String> = nonContainerStepInsideContainer.expectingContainer()
//
//        // Will work as this step can accept anything(Any?)
//        let _: ActionToStepIntegrator<UINavigationController, String> = nonContainerStepInsideContainer.expectingContainer()
//
//        // Will not work as this step can not accept Int
//        // let _: ActionToStepIntegrator<UINavigationController, Int> = nonContainerStepInsideContainer.expectingContainer()
//
//        // Will compile but will not work in runtime.
//        let _: ActionToStepIntegrator<UITabBarController, String> = nonContainerStepInsideContainer.expectingContainer()
//
//        XCTAssertThrowsError(try (step.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertNoThrow(try (step.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertThrowsError(try (step.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: ()))
//    }
//
//    func testSingleStepUnsafelyRewrapped() {
//        let nonContainerStepInsideContainer = SingleStep(finder: TestFinder<UIViewController, String>(), factory: NilFactory())
//        let newStep: ActionToStepIntegrator<UINavigationController, Int> = nonContainerStepInsideContainer.unsafelyRewrapped()
//        XCTAssertThrowsError(try (newStep.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: 123))
//    }
//
//    func testSingleStepEmbeddable() {
//        let nonContainerStepInsideContainer = SingleStep(finder: TestFinder<UIViewController, String>(), factory: NilFactory())
//        let newStep = nonContainerStepInsideContainer.embeddableRoutingStep(with: UINavigationController.push()) as? PerformableStep
//        XCTAssertThrowsError(try (newStep?.perform(with: 123)))
//        XCTAssertNoThrow(try? (newStep?.perform(with: "string")))
//    }
//
//    func testSingleAdaptingContext() {
//        let nonContainerStepInsideContainer = SingleStep(finder: TestFinder<UINavigationController, Any?>(), factory: NilFactory())
//
//        let step1: ActionToStepIntegrator<UINavigationController, String> = nonContainerStepInsideContainer.adaptingContext()
//        let step2: ActionToStepIntegrator<UINavigationController, Void> = nonContainerStepInsideContainer.adaptingContext()
//        XCTAssertNoThrow(try (step1.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertNoThrow(try (step2.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: nil as Any?))
//        XCTAssertNoThrow(try (step1.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertNoThrow(try (step2.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: "nil"))
//        XCTAssertNoThrow(try (step1.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: ()))
//        XCTAssertNoThrow(try (step2.routingStep(with: ViewControllerActions.NilAction()) as? PerformableStep)?.perform(with: ()))
//    }
//
//    func testGeneralStepCurrentOnNoTopMostController() {
//        var window: UIWindow? = UIWindow()
//        let step = GeneralStep.CurrentViewControllerStep(windowProvider: CustomWindowProvider(window: window!))
//        window = nil
//        XCTAssertThrowsError(try step.perform(with: "Any context"))
//    }
//
//}
