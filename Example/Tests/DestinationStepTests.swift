//
// Created by Eugene Kazaev on 2018-10-12.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import XCTest
@testable import RouteComposer

class DestinationStepTests: XCTestCase {

    struct TestFinder<VC: UIViewController, C>: Finder {

        func findViewController(with context: C) -> VC? {
            return nil
        }

    }

    func testUniversalExpectingContainer() {
        let nonContainerStepInsideContainer = StepAssembly(finder: TestFinder<UIViewController, Any?>(), factory: NilFactory())
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally())
                .assemble(from: GeneralStep.current())

        let step: DestinationStep<UINavigationController, Any?> = nonContainerStepInsideContainer.expectingContainer()

        //Will work as this step can accept anything(Any?)
        let _: DestinationStep<UINavigationController, String> = nonContainerStepInsideContainer.expectingContainer()
        let _: DestinationStep<UINavigationController, Void> = nonContainerStepInsideContainer.expectingContainer()

        // Will compile but will not work in runtime.
        let _: DestinationStep<UITabBarController, Any?> = nonContainerStepInsideContainer.expectingContainer()

        XCTAssertNoThrow(try (step.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: nil))
        XCTAssertNoThrow(try (step.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: "nil"))
        XCTAssertNoThrow(try (step.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: ()))
    }

    func testStronglyTypedExpectingContainer() {
        let nonContainerStepInsideContainer = StepAssembly(finder: TestFinder<UIViewController, String>(), factory: NilFactory())
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally())
                .assemble(from: GeneralStep.current())

        let step: DestinationStep<UINavigationController, String> = nonContainerStepInsideContainer.expectingContainer()
        //Will not work as this step can not accept Int
        //let _: DestinationStep<UINavigationController, Int> = nonContainerStepInsideContainer.asContainerWitness()

        // Will compile but will not work in runtime.
        let _: DestinationStep<UITabBarController, String> = nonContainerStepInsideContainer.expectingContainer()

        XCTAssertNoThrow(try (step.getPreviousStep(with: "") as? PerformableStep)?.perform(with: "nil"))
        XCTAssertThrowsError(try (step.getPreviousStep(with: "") as? PerformableStep)?.perform(with: nil))
        XCTAssertThrowsError(try (step.getPreviousStep(with: "") as? PerformableStep)?.perform(with: ()))
    }

    func testAdaptingContext() {
        let nonContainerStepInsideContainer = StepAssembly(finder: TestFinder<UINavigationController, Any?>(), factory: XibFactory())
                .using(GeneralAction.presentModally())
                .assemble(from: GeneralStep.current())

        let step1: DestinationStep<UINavigationController, String> = nonContainerStepInsideContainer.adaptingContext()
        let step2: DestinationStep<UINavigationController, Void> = nonContainerStepInsideContainer.adaptingContext()
        XCTAssertNoThrow(try (step1.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: nil))
        XCTAssertNoThrow(try (step2.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: nil))
        XCTAssertNoThrow(try (step1.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: "nil"))
        XCTAssertNoThrow(try (step2.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: "nil"))
        XCTAssertNoThrow(try (step1.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: ()))
        XCTAssertNoThrow(try (step2.getPreviousStep(with: nil) as? PerformableStep)?.perform(with: ()))
    }

}
