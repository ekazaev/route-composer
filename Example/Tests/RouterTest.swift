//
// RouteComposer
// RouterTest.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
@testable import RouteComposer
import UIKit
import XCTest

private protocol TestProtocol {}

private struct TestImplementation: TestProtocol {}

@MainActor
class RouterTests: XCTestCase {

    let router = DefaultRouter()

    class TestPostRoutingTask<VC: UIViewController, C>: PostRoutingTask {

        var wasInPerform = false

        func perform(on viewController: VC, with context: C, routingStack: [UIViewController]) {
            wasInPerform = true
        }

    }

    // To fake modal presentation
    class TestModalPresentableController: UIViewController {

        var fakePresentedViewController: UIViewController?

        var fakePresentingViewController: UIViewController?

        override var presentedViewController: UIViewController? {
            fakePresentedViewController
        }

        override var presentingViewController: UIViewController? {
            fakePresentingViewController
        }
    }

    // Fakes current view controller as we do not have an access to the key UIWindow
    class TestCurrentViewControllerStep<VC: UIViewController>: RoutingStep, PerformableStep {

        let currentViewController: VC

        init(currentViewController: VC) {
            self.currentViewController = currentViewController
        }

        func perform(with context: AnyContext) -> PerformableStepResult {
            .success(currentViewController)
        }

    }

    // ViewController that can not be dismissed
    class TestRoutingControllingViewController: UIViewController, RoutingInterceptable {
        let canBeDismissed: Bool = false
    }

    // View Controller to present
    class TestViewController: UIViewController {}

    // Factory that produces TestViewController
    struct TestViewControllerFactory<C>: Factory {

        typealias ViewController = TestViewController

        typealias Context = C

        func build(with context: C) throws -> TestViewController {
            TestViewController()
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
            currentViewController
        }
    }

    // Fakes modal presentation action using `TestModalPresentableController`
    struct FakePresentModallyAction: Action {
        // We can not present modally on the view controllers that are not in the window hierarchy - so we will just fake this action
        func perform(with viewController: UIViewController, on existingController: TestModalPresentableController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
            existingController.fakePresentedViewController = viewController
            completion(.success)
        }

    }

    override func setUp() {
        super.setUp()
    }

    func testNavigateTo() {
        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: NilFinder(), factory: TestViewControllerFactory())
            .adding(InlinePostTask { (_: TestViewController, _: Any?, viewControllers: [UIViewController]) in
                XCTAssertEqual(viewControllers.count, 3)
            })
            .using(.push)
            .from(NavigationControllerStep())
            .using(FakePresentModallyAction())
            .from(DestinationStep<TestModalPresentableController, Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
            .assemble()

        var routingResult: RoutingResult!
        let destination = Destination(to: screenConfig).unwrapped()
        try? router.navigate(to: destination.step, with: destination.context, animated: false, completion: { result in
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
                currentViewController
            }
        }

        let screenConfig = StepAssembly(finder: NilFinder(), factory: TestViewControllerFactory())
            .using(.push)
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
            .using(.push)
            .from(SingleContainerStep(finder: NilFinder(), factory: NavigationControllerFactory<UINavigationController, Any?>()))
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

    func testNavigateToActionWithIssue() {
        struct TestPresentModallyBrokenAction: Action {

            func perform(with viewController: UIViewController,
                         on existingController: TestModalPresentableController,
                         animated: Bool,
                         completion: @escaping (RoutingResult) -> Void) {
                completion(.failure(RoutingError.generic(.init("Some error occurred"))))
            }

        }

        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: NilFinder(), factory: TestViewControllerFactory())
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

    func testNavigateToFactoryWithIssue() {
        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: NilFinder(), factory: TestViewControllerBrokenFactory())
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
            .using(.push)
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

            func perform(on viewController: VC, with context: C) throws {
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
        let screenConfig = StepAssembly(finder: NilFinder(), factory: TestViewControllerFactory<TestProtocol>())
            .adding(InlineInterceptor(prepare: { (_: TestProtocol) throws in
                contextInterceptorPrepared += 1
            }, { (_: TestProtocol) in
                contextInterceptorRun += 1
            }))
            .adding(InlineContextTask { (_: TestViewController, _: TestProtocol) in
                contextTaskRun += 1
            })
            .adding(InlinePostTask { (_: TestViewController, _: TestProtocol, viewControllers: [UIViewController]) in
                contextPostTaskRun += 1
                XCTAssertEqual(viewControllers.count, 3)
            })
            .using(.push)
            .from(NavigationControllerStep())
            .using(FakePresentModallyAction())
            .from(DestinationStep<TestModalPresentableController, TestProtocol>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
            .assemble()
        var router = router
        router.add(InlineInterceptor(prepare: { (_: Any?) throws in
            globalInterceptorPrepared += 1
        }, { (_: Any?, completion: @escaping (RoutingResult) -> Void) in
            globalInterceptorRun += 1
            completion(.success)
        }))
        router.add(InlineContextTask { (_: UIViewController, _: Any?) in
            globalTaskRun += 1
        })
        router.add(InlinePostTask { (_: UIViewController, _: Any?, viewControllers: [UIViewController]) in
            globalPostTaskRun += 1
            XCTAssertEqual(viewControllers.count, 3)
        })
        var routingResult: RoutingResult!
        try? router.navigate(to: screenConfig, with: TestImplementation(), animated: false, completion: { result in
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

    func testNavigateToWithDeallocatedViewController() {
        let expectation = XCTestExpectation(description: "Animated root view controller replacement")
        let router: Router = DefaultRouter()
        var viewController: UIViewController? = UINavigationController()
        let screenConfigVoid = StepAssembly(finder: NilFinder<UIViewController, Void>(), factory: NilFactory())
            .adding(InlineInterceptor { (_: Void, completion: @escaping (RoutingResult) -> Void) in
                viewController = nil
                let deadline = DispatchTime.now() + .milliseconds(100)
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    completion(.success)
                }

            })
            .from(GeneralStep.custom(using: InstanceFinder(instance: viewController!)))
            .assemble()
        var wasInCompletion = false
        try? router.navigate(to: screenConfigVoid, animated: false, completion: { result in
            expectation.fulfill()
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        })
        wait(for: [expectation], timeout: 0.3)
        XCTAssertTrue(wasInCompletion)
    }

    func testNavigateToWithViewControllerNotFound() {
        struct NoneStep: RoutingStep, PerformableStep {

            func perform(with context: AnyContext) throws -> PerformableStepResult {
                .none
            }
        }

        let router: Router = DefaultRouter()
        let screenConfigVoid = StepAssembly(finder: NilFinder<UIViewController, Void>(), factory: NilFactory())
            .from(DestinationStep(NoneStep()))
            .assemble()
        XCTAssertThrowsError(try router.navigate(to: screenConfigVoid, animated: false, completion: nil))
    }

    func testRouterWithAnyOrVoidContext() {
        let router: Router = DefaultRouter()
        let screenConfigVoid = StepAssembly(finder: NilFinder<UIViewController, Void>(), factory: NilFactory())
            .from(GeneralStep.custom(using: NilFinder<UIViewController, Void>()))
            .assemble()
        XCTAssertThrowsError(try router.navigate(to: screenConfigVoid, animated: false, completion: nil))
        var wasInCompletion = false
        router.commitNavigation(to: screenConfigVoid, animated: false) { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        }
        XCTAssertTrue(wasInCompletion)

        let screenConfigAny = StepAssembly(finder: NilFinder<UIViewController, Any?>(), factory: NilFactory())
            .from(GeneralStep.custom(using: NilFinder<UIViewController, Any?>()))
            .assemble()
        XCTAssertThrowsError(try router.navigate(to: screenConfigAny, animated: false, completion: nil))
        wasInCompletion = false
        router.commitNavigation(to: screenConfigAny, animated: false) { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        }
        XCTAssertTrue(wasInCompletion)

        let screenConfigString = StepAssembly(finder: NilFinder<UIViewController, String>(), factory: NilFactory())
            .from(GeneralStep.custom(using: NilFinder<UIViewController, String>()))
            .assemble()
        XCTAssertThrowsError(try router.navigate(to: screenConfigAny, animated: false, completion: nil))
        wasInCompletion = false
        router.commitNavigation(to: screenConfigString, with: "test", animated: false) { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        }
        XCTAssertTrue(wasInCompletion)
    }

    func testPostponedTaskRunner() {
        let postTask = TestPostRoutingTask<UIViewController, TestProtocol>()
        let viewController = UIViewController()
        let runner = DefaultRouter.PostponedTaskRunner()
        runner.add(postTasks: [PostRoutingTaskBox(postTask)], to: viewController, context: AnyContextBox(TestImplementation()))
        XCTAssertNoThrow(try runner.perform())
        XCTAssertTrue(postTask.wasInPerform)

        let postTask1 = TestPostRoutingTask<UIViewController, TestProtocol>()
        runner.add(postTasks: [PostRoutingTaskBox(postTask1)], to: viewController, context: AnyContextBox(nil as TestProtocol?))
        XCTAssertThrowsError(try runner.perform())
        XCTAssertFalse(postTask1.wasInPerform)
    }

}
