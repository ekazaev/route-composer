//
// Created by Eugene Kazaev on 12/09/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import RouteComposer

class AssemblyTest: XCTestCase {

    func testStepAssembly() {
        let lastStepAssembly = StepAssembly(finder: ClassFinder<UIViewController, Any?>(), factory: XibFactory(nibName: "AnyNibName"))
                .using(GeneralAction.nilAction())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 2)

        var currentStep: RoutingStep? = lastStepAssembly.assemble(from: GeneralStep.current())
        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.previousStep
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 5)
    }

    func testContainerStepAssembly() {
        let lastStepAssembly = ContainerStepAssembly(finder: ClassFinder(), factory: NavigationControllerFactory())
                .using(GeneralAction.nilAction())
                .from(TabBarControllerStep())
                .using(GeneralAction.presentModally())
                .from(GeneralStep.root())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 3)

        var currentStep: RoutingStep? = lastStepAssembly.assemble()
        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.previousStep
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 5)
    }

    func testChainAssembly() {
        let destinationStep = ChainAssembly.from(NavigationControllerStep())
                .using(GeneralAction.presentModally())
                .from(GeneralStep.root())
                .assemble()
        var currentStep: RoutingStep? = ChainAssembly.from(
                        destinationStep)
                .assemble()

        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.previousStep
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 5)
    }

    func testCompleteFactoryAssembly() {
        let container = CompleteFactoryAssembly(factory: TabBarControllerFactory())
                .with(ClassNameFactory<UIViewController, Any?>())
                .with(ClassNameFactory<UIViewController, Any?>(), using: TabBarControllerFactory.addTab())
                .with(CompleteFactoryAssembly(factory: TabBarControllerFactory())
                        .with(ClassNameFactory<UIViewController, Any?>()
                        ).assemble(),
                        using: TabBarControllerFactory.addTab(at: 1, replacing: true))
                .assemble()
        XCTAssertEqual(container.childFactories.count, 3)
        let tabBarController = try? container.build()
        XCTAssertEqual(tabBarController?.viewControllers?.count, 2)
    }

    func testSwitchAssembly() {
        let step = SwitchAssembly<Any?>()
                .addCase(when: ClassFinder<UINavigationController, Any?>())
                .addCase(when: ClassFinder<UITabBarController, Any?>(), do: GeneralStep.root())
                .addCase({ (_: Any?) in
                    return GeneralStep.current()
                })
                .assemble(default: {
                    return GeneralStep.root()
                }).previousStep as? SwitcherStep<Any?>

        XCTAssertNotNil(step)
        XCTAssertEqual(step?.resolvers.count, 4)
    }

    func testStepWithActionAssembly() {
        let assembly = StepWithActionAssembly<ClassFinder<RouterTests.TestViewController, Any?>, ClassNameFactory<RouterTests.TestViewController, Any?>>()
                .add(InlineInterceptor({ (_: Any?) in
                }))
                .add(InlineContextTask({ (_: RouterTests.TestViewController, _: Any?) in
                }))
                .add(InlinePostTask({ (_: RouterTests.TestViewController, _: Any?, _: [UIViewController]) in
                }))
        XCTAssertNotNil(assembly.taskCollector.interceptor())
        XCTAssertNotNil(assembly.taskCollector.contextTask())
        XCTAssertNotNil(assembly.taskCollector.postTask())
    }
}
