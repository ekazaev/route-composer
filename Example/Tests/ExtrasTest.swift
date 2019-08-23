//
//  ExtrasTest.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 12/03/2019.
//

import UIKit
import Foundation
import XCTest
@testable import RouteComposer

class ExtrasTest: XCTestCase {

    let router = SingleNavigationRouter(router: DefaultRouter(), lock: SingleNavigationLock())

    // Fakes modal presentation action using `TestModalPresentableController`
    struct FakeTimedPresentModallyAction: Action {
        // We can not present modally on the view controllers that are not in the window hierarchy - so we will just fake this action
        func perform(with viewController: UIViewController,
                     on existingController: RouterTests.TestModalPresentableController,
                     animated: Bool,
                     completion: @escaping (RoutingResult) -> Void) {
            let deadline = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                existingController.fakePresentedViewController = viewController
                completion(.success)
            }
        }
    }

    class ContentAcceptingViewController: UIViewController, ContextAccepting {

        var context: String?

        func setup(with context: String) throws {
            self.context = context
        }

        class func checkCompatibility(with context: String) throws {
            if context.isEmpty {
                throw RoutingError.generic(.init("Context is empty"))
            }
        }

    }

    func testContextAccepting() {
        class ContentAcceptingViewController: UIViewController, ContextAccepting {
            func setup(with context: String) throws {
            }
        }

        XCTAssertNoThrow(try ContentAcceptingViewController.checkCompatibility(with: ""))
    }

    func testSingleNavigationRouterSimultaneousNavigation() {
        let currentViewController = RouterTests.TestModalPresentableController()
        let screenConfig = StepAssembly(finder: ClassFinder(), factory: RouterTests.TestViewControllerFactory())
                .adding(InlinePostTask({ (_: RouterTests.TestViewController, _: Any?, viewControllers: [UIViewController]) in
                    XCTAssertEqual(viewControllers.count, 3)
                }))
                .using(UINavigationController.push())
                .from(NavigationControllerStep())
                .using(FakeTimedPresentModallyAction())
                .from(DestinationStep<RouterTests.TestModalPresentableController, Any?>(RouterTests.TestCurrentViewControllerStep(currentViewController: currentViewController)))
                .assemble()

        let expectation = XCTestExpectation(description: "Navigation to finish")
        var globalInterceptorPrepared = 0
        var globalInterceptorRun = 0
        var globalTaskRun = 0
        var globalPostTaskRun = 0
        var router = self.router
        router.add(InlineInterceptor(prepare: { (_: Any?) throws in
            globalInterceptorPrepared += 1
        }, { (_: Any?, completion: @escaping (RoutingResult) -> Void) in
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
        XCTAssertNoThrow(try router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
            XCTAssertTrue(result.isSuccessful)
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is RouterTests.TestViewController)
            }
            expectation.fulfill()
        }))

        XCTAssertThrowsError(try router.navigate(to: screenConfig, with: nil, animated: false, completion: { _ in
            XCTAssertFalse(true, "Should not be called")
        }))

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(globalInterceptorPrepared, 1)
        XCTAssertEqual(globalInterceptorRun, 1)
        XCTAssertEqual(globalTaskRun, 3)
        XCTAssertEqual(globalPostTaskRun, 3)
    }

    func testSingleNavigationRouterThrowingException() {
        class FaultyTestRouter: Router {
            func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                                     with context: Context,
                                                                     animated: Bool,
                                                                     completion: ((RoutingResult) -> Void)?) throws {
                throw RoutingError.generic(.init("Test"))
            }
        }

        let window = UIWindow()
        let windowProvider = CustomWindowProvider(window: window)
        let lock = SingleNavigationLock()
        let router = SingleNavigationRouter(router: FaultyTestRouter(), lock: lock)
        var wasInCompletion = false
        XCTAssertThrowsError(try router.navigate(to: GeneralStep.current(windowProvider: windowProvider),
                with: "test",
                animated: false,
                completion: { _ in
                    wasInCompletion = true
                }))
        XCTAssertFalse(wasInCompletion)
        XCTAssertFalse(lock.isNavigationInProgress)
    }

    func testSingleNavigationLock() {
        let lock = SingleNavigationLock()
        XCTAssertFalse(lock.isNavigationInProgress)
        lock.startNavigation()
        XCTAssertTrue(lock.isNavigationInProgress)
        lock.stopNavigation()
        XCTAssertFalse(lock.isNavigationInProgress)
    }

    func testContextSettingTask() {
        let viewController = ContentAcceptingViewController()
        let contextTask = ContextSettingTask<ContentAcceptingViewController>()

        XCTAssertThrowsError(try contextTask.prepare(with: ""))
        XCTAssertNoThrow(try contextTask.prepare(with: "non empty string"))
        XCTAssertNoThrow(try contextTask.perform(on: viewController, with: "context"))
        XCTAssertEqual(viewController.context, "context")
    }

    func testDismissalMethodProvidingContextTask() {
        class DismissingViewController<C>: UIViewController, Dismissible {
            var dismissalBlock: ((C, Bool, ((RoutingResult) -> Void)?) -> Void)?
        }

        let viewControllerVoid = DismissingViewController<Void>()
        var wasInCompletion = false
        try? DismissalMethodProvidingContextTask<DismissingViewController, Any?>(dismissalBlock: { (_: Void, animated, _) in
            XCTAssertEqual(animated, true)
            wasInCompletion = true
        }).perform(on: viewControllerVoid, with: nil)
        viewControllerVoid.dismissViewController(animated: true)
        XCTAssertEqual(wasInCompletion, true)

        let viewControllerAny = DismissingViewController<Any?>()
        wasInCompletion = false
        try? DismissalMethodProvidingContextTask<DismissingViewController, Any?>(dismissalBlock: { (_: Any?, animated, _) in
            XCTAssertEqual(animated, true)
            wasInCompletion = true
        }).perform(on: viewControllerAny, with: nil)
        viewControllerAny.dismissViewController(animated: true)
        XCTAssertEqual(wasInCompletion, true)

    }

    func testDismissibleWithRuntimeStorage() {
        class DismissingViewController: UIViewController, DismissibleWithRuntimeStorage {
            typealias DismissalTargetContext = Void
        }

        let viewController = DismissingViewController()
        var wasInCompletion = false
        viewController.dismissalBlock = { context, animated, completion in
            wasInCompletion = true
        }
        XCTAssertNotNil(viewController.dismissalBlock)
        viewController.dismissalBlock?((), true, nil)
        XCTAssertEqual(wasInCompletion, true)
    }

    func testNavigationDelayingInterceptorPerform() {
        class DismissingViewController: UIViewController {
            override var isBeingDismissed: Bool {
                return true
            }
        }

        let window = UIWindow()
        window.rootViewController = DismissingViewController()
        let interceptor = NavigationDelayingInterceptor(windowProvider: CustomWindowProvider(window: window), strategy: .abort)

        var wasInCompletion = false
        interceptor.perform(with: nil, completion: { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testNavigationDetailsFinder() {
        let emptyFinder = DetailsNavigationFinder<Any?>(options: SearchOptions.current)
        XCTAssertNil(try emptyFinder.findViewController())

        let splitViewController = UISplitViewController()
        let finder = DetailsNavigationFinder<Any?>(options: SearchOptions.current, startingPoint: DefaultStackIterator.StartingPoint.custom(splitViewController))
        splitViewController.viewControllers = [UINavigationController()]
        XCTAssertNil(try finder.findViewController())

        let navigationController = UINavigationController()
        splitViewController.viewControllers = [UINavigationController(), navigationController]
        XCTAssertEqual(try finder.findViewController(), navigationController)

        class SpecialSplitNavigationController: UINavigationController {
            let nestedNavigaionController: UINavigationController

            init(nestedNavigaionController: UINavigationController) {
                self.nestedNavigaionController = nestedNavigaionController
                super.init(nibName: nil, bundle: nil)
            }

            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            override var viewControllers: [UIViewController] {
                get {
                    return [nestedNavigaionController]
                }
                set {
                    super.viewControllers = newValue
                }
            }
        }

        let secondNavigationController = SpecialSplitNavigationController(nestedNavigaionController: navigationController)
        splitViewController.viewControllers = [secondNavigationController]
        XCTAssertEqual(try finder.findViewController(), navigationController)
    }

    func testRouterNavigationToDestination() {
        class TestRouter: Router {
            func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                                     with context: Context,
                                                                     animated: Bool,
                                                                     completion: ((RoutingResult) -> Void)?) throws {
                XCTAssertTrue(animated)
                XCTAssertNotNil(completion)
                completion?(.success)
            }
        }

        class FaultyTestRouter: Router {
            func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                                     with context: Context,
                                                                     animated: Bool,
                                                                     completion: ((RoutingResult) -> Void)?) throws {
                XCTAssertFalse(animated)
                XCTAssertNotNil(completion)
                throw RoutingError.generic(.init("Test"))
            }
        }

        let testRouter = TestRouter()
        let window = UIWindow()
        let windowProvider = CustomWindowProvider(window: window)
        let destination = Destination(to: GeneralStep.current(windowProvider: windowProvider), with: "test")
        var wasInCompletion = false
        try? testRouter.navigate(to: destination, animated: true, completion: { result in
            wasInCompletion = true
            XCTAssertTrue(result.isSuccessful)
        })
        XCTAssertEqual(wasInCompletion, true)

        wasInCompletion = false
        testRouter.commitNavigation(to: destination, animated: true, completion: { result in
            wasInCompletion = true
            XCTAssertTrue(result.isSuccessful)
        })
        XCTAssertEqual(wasInCompletion, true)

        let faultyRouter = FaultyTestRouter()
        wasInCompletion = false
        try? faultyRouter.navigate(to: destination, animated: false, completion: { _ in
            wasInCompletion = true
        })
        XCTAssertEqual(wasInCompletion, false)

        wasInCompletion = false
        faultyRouter.commitNavigation(to: destination, animated: false, completion: { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        })
        XCTAssertEqual(wasInCompletion, true)
    }

    func testCATransactionalContainerActionPerformEmbedding() {
        let action = CATransaction.wrap(UINavigationController.pushReplacingLast())
        var viewControllers = [UIViewController()]
        let tabBarController = UITabBarController()
        try? action.perform(embedding: tabBarController, in: &viewControllers)
        XCTAssertEqual(viewControllers.count, 1)
        XCTAssertEqual(viewControllers.last, tabBarController)
    }

    func testCATransactionalContainerActionPerform() {
        let action = CATransaction.wrap(UINavigationController.push())
        let navigationController = UINavigationController()
        let newViewController = UIViewController()
        var wasInCompletion = false
        action.perform(with: newViewController, on: navigationController, animated: false, completion: { result in
            wasInCompletion = true
            XCTAssertTrue(result.isSuccessful)
        })
        XCTAssertEqual(wasInCompletion, true)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.last, newViewController)
    }

    func testCATransactionalActionPerform() {
        let window = UIWindow()
        window.rootViewController = UINavigationController()
        let windowProvider = CustomWindowProvider(window: window)
        let action = CATransaction.wrap(GeneralAction.replaceRoot(windowProvider: windowProvider))
        var wasInCompletion = false
        let newViewController = UIViewController()
        action.perform(with: newViewController, on: window.rootViewController!, animated: false, completion: { result in
            wasInCompletion = true
            XCTAssertTrue(result.isSuccessful)
        })
        XCTAssertEqual(wasInCompletion, true)
        XCTAssertEqual(window.rootViewController, newViewController)
    }

}
