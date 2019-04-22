//
// Created by Eugene Kazaev on 11/09/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import RouteComposer

class RouterTests: XCTestCase {

    let router = DefaultRouter()

    // To fake modal presentation
    class TestModalPresentableController: UIViewController {

        var fakePresentedViewController: UIViewController?

        var fakePresentingViewController: UIViewController?

        override var presentedViewController: UIViewController? {
            return fakePresentedViewController
        }

        override var presentingViewController: UIViewController? {
            return fakePresentingViewController
        }
    }

    // Fakes current view controller as we do not have an access to the key UIWindow
    class TestCurrentViewControllerStep<VC: UIViewController>: RoutingStep, PerformableStep {

        let currentViewController: VC

        init(currentViewController: VC) {
            self.currentViewController = currentViewController
        }

        func perform<Context>(with context: Context) -> PerformableStepResult {
            return .success(currentViewController)
        }

    }

    // ViewController that can not be dismissed
    class TestRoutingControllingViewController: UIViewController, RoutingInterceptable {
        let canBeDismissed: Bool = false
    }

    // View Controller to present
    class TestViewController: UIViewController {

    }

    // Factory that produces TestViewController
    struct TestViewControllerFactory: Factory {

        typealias ViewController = TestViewController

        typealias Context = Any?

        func build(with context: Any?) throws -> TestViewController {
            return TestViewController()
        }

    }

    // Factory that suppose to produce `TestViewController` but fails
    struct TestViewControllerBrokenFactory: Factory {

        func build(with context: Any?) throws -> TestViewController {
            throw RoutingError.generic(.init("Some error occurred"))
        }

    }

    // Fake finder that always finds a view controller in the stack
    struct FakeClassFinder<VC: UIViewController, C>: Finder {

        let currentViewController: VC

        init(currentViewController: VC) {
            self.currentViewController = currentViewController
        }

        func findViewController(with context: C) throws -> VC? {
            return currentViewController
        }
    }

    // Fakes modal presentation action using `TestModalPresentableController`
    struct FakePresentModallyAction: Action {
        // We can not present modally on the view controllers that are not in the window hierarchy - so we will just fake this action
        func perform(with viewController: UIViewController, on existingController: TestModalPresentableController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
            existingController.fakePresentedViewController = viewController
            completion(.continueRouting)
        }

    }

    override func setUp() {
        super.setUp()
    }

    func testNavigateTo() {
        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerFactory())
                .adding(InlinePostTask({ (_: TestViewController, _: Any?, viewControllers: [UIViewController]) in
                    XCTAssertEqual(viewControllers.count, 3)
                }))
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(FakePresentModallyAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult!
        try? router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is TestViewController)
            }
        })
        XCTAssertTrue(routingResult.isSuccessful)
    }

    func testNavigateToNavigationPresented() {
        let currentViewController = TestModalPresentableController()
        let presentNavigationController = UINavigationController()
        currentViewController.fakePresentedViewController = presentNavigationController

        struct FakeClassFinder<VC: UIViewController, C>: Finder {

            let currentViewController: VC

            init(currentViewController: VC) {
                self.currentViewController = currentViewController
            }

            func findViewController(with context: C) -> VC? {
                return currentViewController
            }
        }

        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerFactory())
                .using(UINavigationController.push())
                .from(SingleContainerStep(finder: FakeClassFinder(currentViewController: presentNavigationController), factory: NavigationControllerFactory()))
                .using(FakePresentModallyAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult!
        try? router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is TestViewController)
            }
        })
        XCTAssertTrue(routingResult.isSuccessful)
    }

    func testNavigateToAlreadyInStack() {
        let currentViewController = TestModalPresentableController()
        let testViewController = TestViewController()
        let presentNavigationController = UINavigationController(rootViewController: testViewController)
        currentViewController.fakePresentedViewController = presentNavigationController

        let screenConfig = StepAssembly(finder: FakeClassFinder(currentViewController: testViewController), factory: TestViewControllerBrokenFactory())
                .using(UINavigationController.push())
                .from(SingleContainerStep(finder: NilFinder(), factory: NavigationControllerFactory<Any?>()))
                .using(FakePresentModallyAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult!
        try? router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is TestViewController)
            }
        })
        XCTAssertTrue(routingResult.isSuccessful)
    }

    func testNavigateToActionProblem() {
        struct TestPresentModallyBrokenAction: Action {

            func perform(with viewController: UIViewController,
                         on existingController: TestModalPresentableController,
                         animated: Bool,
                         completion: @escaping (ActionResult) -> Void) {
                completion(.failure(RoutingError.generic(.init("Some error occurred"))))
            }

        }

        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerFactory())
                .using(TestPresentModallyBrokenAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult!
        try? router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNil(currentViewController.presentedViewController)
        })
        XCTAssertFalse(routingResult.isSuccessful)
    }

    func testNavigateToFactoryProblem() {
        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerBrokenFactory())
                .using(FakePresentModallyAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult!
        try? router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNil(currentViewController.presentedViewController)
        })
        XCTAssertFalse(routingResult.isSuccessful)
    }

    func testNavigateToWithRoutingControllingInStack() {
        let currentViewController = TestModalPresentableController()
        let testViewController = TestRoutingControllingViewController()
        let screenConfig = StepAssembly(finder: FakeClassFinder(currentViewController: testViewController), factory: NilFactory<TestRoutingControllingViewController, Any?>())
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(FakePresentModallyAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        XCTAssertThrowsError(try router.navigate(to: screenConfig, with: nil, animated: false, completion: { _ in
            XCTAssert(false, "Should not be called")
        }))
    }

    func testPrepareFunctionThrows() {
        struct ThrowsContextTask<VC: UIViewController, C>: ContextTask {

            func prepare(with context: C) throws {
                throw RoutingError.generic(.init("Should be handler synchronously"))
            }

            func apply(on viewController: VC, with context: C) throws {
                throw RoutingError.generic(.init("Should be handler synchronously"))
            }
        }

        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerBrokenFactory())
                .adding(ThrowsContextTask<TestViewController, Any?>())
                .using(FakePresentModallyAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        XCTAssertThrowsError(try router.navigate(to: screenConfig, with: nil, animated: false, completion: { _ in
        }))
    }

    func testNavigateToWithTasks() {
        let currentViewController = TestModalPresentableController()
        var contextInterceptorPrepared = 0
        var contextInterceptorRun = 0
        var contextTaskRun = 0
        var contextPostTaskRun = 0
        var globalInterceptorPrepared = 0
        var globalInterceptorRun = 0
        var globalTaskRun = 0
        var globalPostTaskRun = 0
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerFactory())
                .adding(InlineInterceptor(prepare: { (_: Any?) throws in
                    contextInterceptorPrepared += 1
                }, { (_: Any?) in
                    contextInterceptorRun += 1
                }))
                .adding(InlineContextTask({ (_: TestViewController, _: Any?) in
                    contextTaskRun += 1
                }))
                .adding(InlinePostTask({ (_: TestViewController, _: Any?, viewControllers: [UIViewController]) in
                    contextPostTaskRun += 1
                    XCTAssertEqual(viewControllers.count, 3)
                }))
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(FakePresentModallyAction())
                .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()
        var router = self.router
        router.add(InlineInterceptor(prepare: { (_: Any?) throws in
            globalInterceptorPrepared += 1
        }, { (_: Any?, completion: @escaping (InterceptorResult) -> Void) in
            globalInterceptorRun += 1
            completion(.continueRouting)
        }))
        router.add(InlineContextTask({ (_: UIViewController, _: Any?) in
            globalTaskRun += 1
        }))
        router.add(InlinePostTask({ (_: UIViewController, _: Any?, viewControllers: [UIViewController]) in
            globalPostTaskRun += 1
            XCTAssertEqual(viewControllers.count, 3)
        }))
        var routingResult: RoutingResult!
        try? router.navigate(to: screenConfig, animated: false, completion: { result in
            routingResult = result
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is TestViewController)
            }
        })
        XCTAssertEqual(contextInterceptorPrepared, 1)
        XCTAssertEqual(contextInterceptorRun, 1)
        XCTAssertEqual(contextTaskRun, 1)
        XCTAssertEqual(contextPostTaskRun, 1)
        XCTAssertEqual(globalInterceptorPrepared, 1)
        XCTAssertEqual(globalInterceptorRun, 1)

        // Should be 3 called 3 times - 1 time for each view controller.
        XCTAssertEqual(globalTaskRun, 3)
        XCTAssertEqual(globalPostTaskRun, 3)

        XCTAssertTrue(routingResult.isSuccessful)
    }

    func testAnyOrVoidMethods() {
        let router: Router = DefaultRouter()
        let screenConfig = StepAssembly(finder: NilFinder<UIViewController, Void>(), factory: NilFactory())
                .from(GeneralStep.custom(using: NilFinder<UIViewController, Void>()))
                .assemble()
        XCTAssertThrowsError(try router.navigate(to: screenConfig, animated: false, completion: nil))
    }

}
