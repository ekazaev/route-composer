//
// RouteComposer
// AssemblyTest.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
@testable import RouteComposer
import UIKit
import XCTest

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
        let lastStepAssembly = StepAssembly(finder: ClassFinder(), factory: NavigationControllerFactory<UINavigationController, Any?>())
            .using(UITabBarController.add())
            .from(TabBarControllerStep())
            .using(GeneralAction.presentModally())
            .from(GeneralStep.root())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 3)

        let currentStep: RoutingStep? = lastStepAssembly.assemble()
        let chainedStepCount = countSteps(currentStep: currentStep)
        XCTAssertEqual(chainedStepCount, 5)
    }

    func testContainerStepAssemblyNilFactory() {
        var lastStepAssembly = StepAssembly(finder: ClassFinder(), factory: NilContainerFactory<UINavigationController, Any?>())
            .from(TabBarControllerStep())
            .using(GeneralAction.presentModally())
            .from(GeneralStep.root())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 3)

        var chainedStepCount = countSteps(currentStep: lastStepAssembly.assemble())
        XCTAssertEqual(chainedStepCount, 5)

        lastStepAssembly = StepAssembly(finder: ClassFinder(), factory: NilContainerFactory<UINavigationController, Any?>())
            .from(GeneralStep.root())
        XCTAssertEqual(lastStepAssembly.previousSteps.count, 2)

        chainedStepCount = countSteps(currentStep: lastStepAssembly.assemble())
        XCTAssertEqual(chainedStepCount, 4)
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
        var bool = false
        let step = SwitchAssembly<UINavigationController, String>()
            .addCase(from: ClassFinder<UINavigationController, String>())
            .addCase(when: bool,
                     from: StepAssembly(finder: ClassFinder(), factory: NilFactory())
                         .from(GeneralStep.current())
                         .assemble())
            .addCase(when: { $0 == "test" },
                     from: StepAssembly(finder: ClassFinder(), factory: NilFactory())
                         .from(GeneralStep.current())
                         .assemble())
            .addCase(expecting: ClassFinder<RouterTests.TestViewController, String>())
            .addCase(when: ClassFinder<UITabBarController, String>(),
                     from: StepAssembly(finder: NilFinder(), factory: NavigationControllerFactory())
                         .using(GeneralAction.presentModally())
                         .from(GeneralStep.current())
                         .assemble())
            .addCase { (_: Any?) in
                StepAssembly(finder: ClassFinder(), factory: NilFactory())
                    .from(GeneralStep.current())
                    .assemble()
            }
            .assemble(default: {
                StepAssembly(finder: NilFinder(), factory: NavigationControllerFactory())
                    .using(UITabBarController.add())
                    .from(TabBarControllerStep())
                    .using(GeneralAction.presentModally())
                    .from(GeneralStep.current())
                    .assemble()
            }).getPreviousStep(with: "context") as? SwitcherStep

        XCTAssertNotNil(step)
        XCTAssertEqual(step?.resolvers.count, 7)
        var result = step?.resolvers[1].resolve(with: "test")
        XCTAssertNil(result)
        bool = true
        result = step?.resolvers[1].resolve(with: "test")
        XCTAssertNotNil(result)
        result = step?.resolvers[2].resolve(with: "test")
        XCTAssertNotNil(result)
        result = step?.resolvers[2].resolve(with: "test1")
        XCTAssertNil(result)
    }

    func testSwitchAssemblyAssemble() {
        let step = SwitchAssembly<UIViewController, Any?>().assemble()
        XCTAssertEqual((step.destinationStep as? SwitcherStep)?.resolvers.count, 0)
    }

    func testSwitchAssemblyResolversWithWrongContext() {
        let viewController = UIViewController()
        let step = SwitchAssembly<UIViewController, String>()
            .addCase(when: InstanceFinder(instance: viewController), from: SwitchAssembly<UIViewController, String>().assemble())
            .assemble(default: {
                SwitchAssembly<UIViewController, String>().assemble()
            })
        XCTAssertEqual((step.destinationStep as? SwitcherStep)?.resolvers.count, 2)
        XCTAssertNotNil((step.destinationStep as? SwitcherStep)?.resolvers.first?.resolve(with: "10"))
        XCTAssertNotNil((step.destinationStep as? SwitcherStep)?.resolvers.last?.resolve(with: "10"))
        XCTAssertNil((step.destinationStep as? SwitcherStep)?.resolvers.first?.resolve(with: 10))
        XCTAssertNil((step.destinationStep as? SwitcherStep)?.resolvers.last?.resolve(with: 10))
    }

    func testActionToStepIntegratorWithTasks() {
        let assembly = ActionToStepIntegrator<RouterTests.TestViewController, Any?>()
            .adding(InlineInterceptor { (_: Any?) in
            })
            .adding(InlineContextTask { (_: RouterTests.TestViewController, _: Any?) in
            })
            .adding(InlinePostTask { (_: RouterTests.TestViewController, _: Any?, _: [UIViewController]) in
            })
        XCTAssertNotNil(assembly.taskCollector.interceptor)
        XCTAssertNotNil(assembly.taskCollector.contextTask)
        XCTAssertNotNil(assembly.taskCollector.postTask)
    }

    func testActionToStepIntegrator() {
        let integrator = ActionToStepIntegrator<UIViewController, Any>()
        XCTAssertNil(integrator.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNil(integrator.embeddableRoutingStep(with: UINavigationController.push()))
    }

    func testSingleStepUnsafeWrapper() {
        let step: ActionToStepIntegrator<UIViewController, Any?> =
            SingleStep(finder: NilFinder<UIViewController, String>(), factory: NilFactory()).unsafelyRewrapped()
        XCTAssertNotNil(step.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNotNil(step.embeddableRoutingStep(with: UINavigationController.push()))

        let stepAdaptingContext: ActionToStepIntegrator<UIViewController, String> =
            SingleStep(finder: NilFinder<UIViewController, Any?>(), factory: NilFactory()).adaptingContext()
        XCTAssertNotNil(stepAdaptingContext.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNotNil(stepAdaptingContext.embeddableRoutingStep(with: UINavigationController.push()))
    }

    func testSingleContainerStepUnsafeWrapper() {
        let step: ActionToStepIntegrator<UIViewController, Any?> =
            SingleContainerStep(finder: NilFinder<UINavigationController, String>(), factory: NilContainerFactory()).unsafelyRewrapped()
        XCTAssertNotNil(step.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNotNil(step.embeddableRoutingStep(with: UINavigationController.push()))

        let stepAdaptingContext: ActionToStepIntegrator<UINavigationController, String> =
            SingleContainerStep(finder: NilFinder<UINavigationController, Any?>(), factory: NilContainerFactory()).adaptingContext()
        XCTAssertNotNil(stepAdaptingContext.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNotNil(stepAdaptingContext.embeddableRoutingStep(with: UINavigationController.push()))

        let stepExpectingContainer: ActionToStepIntegrator<UINavigationController, Any?> =
            SingleContainerStep(finder: NilFinder<UINavigationController, Any?>(), factory: NilContainerFactory()).expectingContainer()
        XCTAssertNotNil(stepExpectingContainer.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNotNil(stepExpectingContainer.embeddableRoutingStep(with: UINavigationController.push()))

        let stepExpectingContainerTyped: ActionToStepIntegrator<UINavigationController, String> =
            SingleContainerStep(finder: NilFinder<UINavigationController, String>(), factory: NilContainerFactory()).expectingContainer()
        XCTAssertNotNil(stepExpectingContainerTyped.routingStep(with: ViewControllerActions.NilAction()))
        XCTAssertNotNil(stepExpectingContainerTyped.embeddableRoutingStep(with: UINavigationController.push()))
    }

    private func countSteps(currentStep: RoutingStep?) -> Int {
        var currentStep = currentStep
        var chainedStepCount = 0
        while currentStep != nil {
            chainedStepCount += 1
            if let chainableStep = currentStep as? ChainableStep {
                currentStep = chainableStep.getPreviousStep(with: nil as Any?)
            } else {
                currentStep = nil
            }
        }
        return chainedStepCount
    }

}
