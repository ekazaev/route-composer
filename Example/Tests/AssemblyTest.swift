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
                .using(GeneralAction.NilAction())
                .from(NavigationControllerStep())
                .using(GeneralAction.PresentModally())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 2)

        var currentStep: RoutingStep? = lastStepAssembly.assemble(from: CurrentViewControllerStep())
        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.previousStep
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 3)
    }

    func testContainerStepAssembly() {
        let lastStepAssembly = ContainerStepAssembly(finder: ClassFinder(), factory: NavigationControllerFactory())
                .using(GeneralAction.NilAction())
                .from(TabBarControllerStep())
                .using(GeneralAction.PresentModally())
                .from(CurrentViewControllerStep())
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
        XCTAssertEqual(chainedStepCount, 3)
    }

    func testChainAssembly() {
        var currentStep: RoutingStep? = ChainAssembly(from:ChainAssembly(from: NavigationControllerStep())
                .using(GeneralAction.PresentModally())
                .from(RootViewControllerStep())
                .assemble()).assemble()

        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.previousStep
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 2)
    }

    func testCompleteFactoryAssembly() {
        let container = CompleteFactoryAssembly(factory: TabBarControllerFactory())
                .with(ClassNameFactory<UIViewController, Any?>())
                .with(ClassNameFactory<UIViewController, Any?>(), using: TabBarControllerFactory.AddTab())
                .with(CompleteFactoryAssembly(factory: TabBarControllerFactory())
                        .with(ClassNameFactory<UIViewController, Any?>()
                        ).assemble(),
                        using: TabBarControllerFactory.AddTab(at: 1, replacing: true))
                .assemble()
        XCTAssertEqual(container.childFactories.count, 3)
        let tabBarController = try? container.build()
        XCTAssertEqual(tabBarController?.viewControllers?.count, 2)
    }

    func testSwitchAssembly() {
        class TestResolver: StepCaseResolver {
            func resolve<D: RoutingDestination>(for destination: D) -> RoutingStep? {
                return RootViewControllerStep()
            }
        }
        let step = SwitchAssembly()
                .addCase(when: ClassFinder<UINavigationController, Any?>())
                .addCase(when: ClassFinder<UITabBarController, Any?>(), do: RootViewControllerStep())
                .addCase({ (_: RouterTests.TestDestination) in
                    return CurrentViewControllerStep()
                })
                .addCase(TestResolver())
                .assemble(default: {
                    return RootViewControllerStep()
                }) as? SwitcherStep

        XCTAssertNotNil(step)
        XCTAssertEqual(step?.resolvers.count, 5)
    }

    func testStepWithActionAssembly() {
        let assembly = StepWithActionAssembly<ClassFinder<RouterTests.TestViewController, Any?>, ClassNameFactory<RouterTests.TestViewController, Any?>>()
                .add(InlineInterceptor({ (_: RouterTests.TestDestination) in
                }))
                .add(InlineContextTask({ (_: RouterTests.TestViewController, _: Any?) in
                }))
                .add(InlinePostTask({ (_: RouterTests.TestViewController, _: RouterTests.TestDestination, _: [UIViewController]) in
                }))
        XCTAssertNotNil(assembly.taskCollector.interceptor())
        XCTAssertNotNil(assembly.taskCollector.contextTask())
        XCTAssertNotNil(assembly.taskCollector.postTask())
    }
}
