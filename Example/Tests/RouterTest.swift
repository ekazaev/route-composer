//
// Created by Eugene Kazaev on 11/09/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
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
    class TestCurrentViewControllerStep: RoutingStepWithContext, PerformableStep {

        typealias Context = Any?

        let currentViewController: UIViewController

        init(currentViewController: UIViewController) {
            self.currentViewController = currentViewController
        }

        func perform(for context: Any?) -> StepResult {
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

        func build(with context: Any?) throws -> TestViewController {
            return TestViewController()
        }

    }

    // Factory that suppose to produce `TestViewController` but fails
    struct TestViewControllerBrokenFactory: Factory {

        func build(with context: Any?) throws -> TestViewController {
            throw RoutingError.message("Some error occurred")
        }

    }

    // Fake finder that always finds a view controller in the stack
    struct FakeClassFinder<VC: UIViewController, C>: Finder {

        let currentViewController: VC

        init(currentViewController: VC) {
            self.currentViewController = currentViewController
        }

        func findViewController(with context: C) -> VC? {
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
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(FakePresentModallyAction())
                .from(DestinationStep<Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult?
        router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is TestViewController)
            }
        })
        XCTAssertEqual(routingResult, RoutingResult.handled)
        XCTAssertEqual(routingResult?.isSuccessful, true)
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
                .using(NavigationControllerFactory.PushToNavigation())
                .from(SingleContainerStep(finder: FakeClassFinder(currentViewController: presentNavigationController), factory: NavigationControllerFactory()))
                .using(FakePresentModallyAction())
                .from(DestinationStep<Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult?
        router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is TestViewController)
            }
        })
        XCTAssertEqual(routingResult, RoutingResult.handled)
    }

    func testNavigateToAlreadyInStack() {
        let currentViewController = TestModalPresentableController()
        let testViewController = TestViewController()
        let presentNavigationController = UINavigationController(rootViewController: testViewController)
        currentViewController.fakePresentedViewController = presentNavigationController

        let screenConfig = StepAssembly(finder: FakeClassFinder(currentViewController: testViewController), factory: TestViewControllerBrokenFactory())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(SingleContainerStep(finder: NilFinder(), factory: NavigationControllerFactory()))
                .using(FakePresentModallyAction())
                .from(DestinationStep<Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult?
        router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is TestViewController)
            }
        })
        XCTAssertEqual(routingResult, RoutingResult.handled)
    }

    func testNavigateToActionProblem() {
        struct TestPresentModallyBrokenAction: Action {

            func perform(with viewController: UIViewController,
                         on existingController: TestModalPresentableController,
                         animated: Bool,
                         completion: @escaping (ActionResult) -> Void) {
                completion(.failure("Some error occurred"))
            }

        }

        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerFactory())
                .using(TestPresentModallyBrokenAction())
                .from(DestinationStep<Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult?
        router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNil(currentViewController.presentedViewController)
        })
        XCTAssertEqual(routingResult, RoutingResult.unhandled)
    }

    func testNavigateToFactoryProblem() {
        let currentViewController = TestModalPresentableController()
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: TestViewControllerBrokenFactory())
                .using(FakePresentModallyAction())
                .from(DestinationStep<Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        var routingResult: RoutingResult?
        router.navigate(to:  screenConfig, with: nil, animated: false, completion: { result in
            routingResult = result
            XCTAssertNil(currentViewController.presentedViewController)
        })
        XCTAssertEqual(routingResult, RoutingResult.unhandled)
    }

    func testNavigateToWithRoutingControllingInStack() {
        let currentViewController = TestModalPresentableController()
        let testViewController = TestRoutingControllingViewController()
        let screenConfig = StepAssembly(finder: FakeClassFinder(currentViewController: testViewController), factory: NilFactory<TestRoutingControllingViewController, Any?>())
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(FakePresentModallyAction())
                .from(DestinationStep<Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        let routingResult = router.navigate(to: screenConfig, with: nil, animated: false, completion: { _ in
            XCTAssert(false, "Should not be called")
        })
        XCTAssertEqual(routingResult, RoutingResult.unhandled)
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
                .add(InlineInterceptor(prepare: { (_: Any?) throws in
                    contextInterceptorPrepared += 1
                }, { (_: Any?) in
                    contextInterceptorRun += 1
                }))
                .add(InlineContextTask({ (_: TestViewController, _: Any?) in
                    contextTaskRun += 1
                }))
                .add(InlinePostTask({ (_: TestViewController, _: Any?, viewControllers: [UIViewController]) in
                    contextPostTaskRun += 1
                    XCTAssertEqual(viewControllers.count, 3)
                }))
                .using(NavigationControllerFactory.PushToNavigation())
                .from(NavigationControllerStep())
                .using(FakePresentModallyAction())
                .from(DestinationStep<Any?>(TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()
        var router = self.router
        router.add(InlineInterceptor(prepare: { (_: Any?) throws in
            globalInterceptorPrepared += 1
        }, { (_: Any?, completion: @escaping (InterceptorResult) -> Void) in
            globalInterceptorRun += 1
            completion(.success)
        }))
        router.add(InlineContextTask({ (_: UIViewController, _: Any?) in
            globalTaskRun += 1
        }))
        router.add(InlinePostTask({ (_: UIViewController, _: Any?, viewControllers: [UIViewController]) in
            globalPostTaskRun += 1
            XCTAssertEqual(viewControllers.count, 3)
        }))
        var routingResult: RoutingResult?
        router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
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

        XCTAssertEqual(routingResult, RoutingResult.handled)
    }

}
