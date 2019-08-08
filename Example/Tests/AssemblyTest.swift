//
// Created by Eugene Kazaev on 12/09/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import RouteComposer

class AssemblyTest: XCTestCase {

    struct NilContainerFactory<VC: ContainerViewController, C>: ContainerFactory, NilEntity {

        typealias ViewController = VC

        public typealias Context = C

        func prepare(with context: Context) throws {
            fatalError("Should never be called")
        }

        func build(with context: Context, integrating coordinator: ChildCoordinator<Context>) throws -> ViewController {
            fatalError("Should never be called")
        }
    }

    class CompleteContextTask<VC: UIViewController, C>: ContextTask {

        typealias ViewController = VC

        typealias Context = C

        var isPrepared: Bool = false

        var isApplied = false

        func prepare(with context: C) throws {
            guard !isPrepared, !isApplied else {
                throw RoutingError.generic(.init("Has been prepared once"))
            }
            isPrepared = true
        }

        func perform(on viewController: ViewController, with context: Context) throws {
            guard isPrepared else {
                throw RoutingError.generic(.init("Hasn't been prepared"))
            }
            guard !isApplied else {
                throw RoutingError.generic(.init("Has been applied once"))
            }
            isApplied = true
        }

    }

    func testStepAssembly() {
        let lastStepAssembly = StepAssembly(finder: ClassFinder<UIViewController, Any?>(), factory: ClassFactory(nibName: "AnyNibName"))
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(GeneralAction.presentModally())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 2)

        var currentStep: RoutingStep? = lastStepAssembly.assemble(from: GeneralStep.current())
        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.getPreviousStep(with: nil as Any?)
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 5)
    }

    func testContainerStepAssembly() {
        let lastStepAssembly = ContainerStepAssembly(finder: ClassFinder(), factory: NavigationControllerFactory<UINavigationController, Any?>())
                .using(UITabBarController.add())
                .from(TabBarControllerStep())
                .using(GeneralAction.presentModally())
                .from(GeneralStep.root())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 3)

        var currentStep: RoutingStep? = lastStepAssembly.assemble()
        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.getPreviousStep(with: nil as Any?)
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 5)
    }

    func testChainAssembly() {
        let destinationStep = ChainAssembly.from(NavigationControllerStep<UINavigationController, Any?>())
                .using(GeneralAction.presentModally())
                .from(GeneralStep.root())
                .assemble()
        var currentStep: RoutingStep? = destinationStep

        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.getPreviousStep(with: nil as Any?)
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 4)
    }

    func testStepChainAssembly() {
        let destinationStep = StepAssembly(finder: NilFinder<UIViewController, Any?>(),
                factory: NilFactory<UIViewController, Any?>())
                .using(ViewControllerActions.NilAction())
                .from(NavigationControllerStep<UINavigationController, Any?>())
                .using(ViewControllerActions.NilAction())
                .from(GeneralStep.root())
                .assemble()
        var currentStep: RoutingStep? = destinationStep
        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.getPreviousStep(with: nil as Any?)
            } else {
                currentStep = nil
            }
        }
        XCTAssertEqual(chainedStepCount, 5)
    }

    func testCompleteFactoryAssembly() {
        let contextTask1 = CompleteContextTask<UIViewController, Any?>()
        let contextTask2 = CompleteContextTask<UIViewController, Any?>()
        let contextTask3 = CompleteContextTask<UITabBarController, Any?>()

        let container = CompleteFactoryAssembly(factory: TabBarControllerFactory<UITabBarController, Any?>())
                .with(ClassFactory<UIViewController, Any?>())
                .adding(contextTask1)
                .adding(contextTask2)
                .with(ClassFactory<UIViewController, Any?>(), using: UITabBarController.add())
                .with(CompleteFactoryAssembly(factory: TabBarControllerFactory<UITabBarController, Any?>())
                        .with(ClassFactory<UIViewController, Any?>()
                        ).assemble(),
                        using: UITabBarController.add(at: 1, replacing: true))
                .adding(contextTask3)
                .with(CompleteFactoryAssembly(factory: NavigationControllerFactory<UINavigationController, Any?>())
                        .with(CompleteFactoryAssembly(factory: TabBarControllerFactory<UITabBarController, Any?>())
                                .with(ClassFactory<UIViewController, Any?>()
                                ).assemble()
                        ).assemble())
                .assemble()
        XCTAssertEqual(container.childFactories.count, 4)
        let tabBarController = try? container.execute()
        XCTAssertEqual(tabBarController?.viewControllers?.count, 3)
        XCTAssertTrue(contextTask1.isPrepared)
        XCTAssertTrue(contextTask1.isApplied)
        XCTAssertTrue(contextTask2.isPrepared)
        XCTAssertTrue(contextTask2.isApplied)
        XCTAssertTrue(contextTask3.isPrepared)
        XCTAssertTrue(contextTask3.isApplied)
    }

    func testCompleteFactoryAssemblyWithNilFactory() {
        var container = CompleteFactoryAssembly(factory: TabBarControllerFactory<UITabBarController, Any?>()).assemble()
        XCTAssertEqual(container.childFactories.count, 0)

        container = CompleteFactoryAssembly(factory: TabBarControllerFactory<UITabBarController, Any?>())
                .with(NilContainerFactory<UINavigationController, Any?>())
                .adding(CompleteContextTask<UINavigationController, Any?>())
                .with(NilContainerFactory<UINavigationController, Any?>())
                .with(ClassFactory<UIViewController, Any?>())
                .assemble()
        XCTAssertEqual(container.childFactories.count, 1)
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
                            .using(UITabBarController.add())
                            .from(TabBarControllerStep())
                            .using(GeneralAction.presentModally())
                            .from(GeneralStep.current())
                            .assemble()
                }).getPreviousStep(with: "context") as? SwitcherStep

        XCTAssertNotNil(step)
        XCTAssertEqual(step?.resolvers.count, 5)
    }

    func testStepWithActionAssembly() {
        let assembly = ActionToStepIntegrator<RouterTests.TestViewController, Any?>()
                .adding(InlineInterceptor({ (_: Any?) in
                }))
                .adding(InlineContextTask({ (_: RouterTests.TestViewController, _: Any?) in
                }))
                .adding(InlinePostTask({ (_: RouterTests.TestViewController, _: Any?, _: [UIViewController]) in
                }))
        XCTAssertNotNil(assembly.taskCollector.interceptor)
        XCTAssertNotNil(assembly.taskCollector.contextTask)
        XCTAssertNotNil(assembly.taskCollector.postTask)
    }

    func testActionToStepIntegrator() {
        let integrator = ActionToStepIntegrator<UIViewController, Any>()
        XCTAssertNil(integrator.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNil(integrator.embeddableRoutingStep(with: UINavigationController.push()))
    }

}
