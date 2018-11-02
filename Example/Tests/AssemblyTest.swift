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
                .using(UINavigationController.pushToNavigation())
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
        let lastStepAssembly = ContainerStepAssembly(finder: ClassFinder(), factory: NavigationControllerFactory<Any?>())
                .using(UITabBarController.addTab())
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
        let destinationStep = ChainAssembly.from(NavigationControllerStep<Any?>())
                .using(GeneralAction.presentModally())
                .from(GeneralStep.root())
                .assemble()
        var currentStep: RoutingStep? = destinationStep

        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.previousStep
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 4)
    }

    func testCompleteFactoryAssembly() {
        let container = CompleteFactoryAssembly(factory: TabBarControllerFactory<Any?>())
                .with(ClassNameFactory<UIViewController, Any?>())
                .with(ClassNameFactory<UIViewController, Any?>(), using: UITabBarController.addTab())
                .with(CompleteFactoryAssembly(factory: TabBarControllerFactory<Any?>())
                        .with(ClassNameFactory<UIViewController, Any?>()
                        ).assemble(),
                        using: UITabBarController.addTab(at: 1, replacing: true))
                .assemble()
        XCTAssertEqual(container.childFactories.count, 3)
        let tabBarController = try? container.build()
        XCTAssertEqual(tabBarController?.viewControllers?.count, 2)
    }

    func testSwitchAssembly() {
        let step = SwitchAssembly<UINavigationController, String>()
                .addCase(from: ClassFinder<UINavigationController, String>())
                .addCase(expecting: ClassFinder<RouterTests.TestViewController, String>())
                .addCase(when: ClassFinder<UITabBarController, String>(),
                        from: ContainerStepAssembly(finder: NilFinder(), factory: NavigationControllerFactory())
                                .using(GeneralAction.presentModally())
                                .from(GeneralStep.current())
                                .assemble())
                .addCase({ (_: Any?) in
                    return StepAssembly(finder: ClassFinder(), factory: NilFactory())
                            .from(GeneralStep.current())
                            .assemble()
                })
                .assemble(default: {
                    return ContainerStepAssembly(finder: NilFinder(), factory: NavigationControllerFactory())
                            .using(UITabBarController.addTab())
                            .from(TabBarControllerStep())
                            .using(GeneralAction.presentModally())
                            .from(GeneralStep.current())
                            .assemble()
                }).previousStep as? SwitcherStep

        XCTAssertNotNil(step)
        XCTAssertEqual(step?.resolvers.count, 5)
    }

    func testStepWithActionAssembly() {
        let assembly = ActionToStepIntegrator<ClassFinder<RouterTests.TestViewController, Any?>, ClassNameFactory<RouterTests.TestViewController, Any?>>()
                .adding(InlineInterceptor({ (_: Any?) in
                }))
                .adding(InlineContextTask({ (_: RouterTests.TestViewController, _: Any?) in
                }))
                .adding(InlinePostTask({ (_: RouterTests.TestViewController, _: Any?, _: [UIViewController]) in
                }))
        XCTAssertNotNil(assembly.taskCollector.getInterceptorsBoxed())
        XCTAssertNotNil(assembly.taskCollector.getContextTasksBoxed())
        XCTAssertNotNil(assembly.taskCollector.getPostTasksBoxed())
    }
}
