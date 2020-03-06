//
// RouteComposer
// ExtensionsTest.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
@testable import RouteComposer
import UIKit
import XCTest

class ExtensionsTest: XCTestCase {

    class InvisibleViewController: UIViewController {}

    class FakePresentingNavigationController: UINavigationController {

        var fakePresentingViewController: UIViewController?

        override var presentingViewController: UIViewController? {
            return fakePresentingViewController
        }

    }

    func testTopMostViewControllerSingle() {
        let window = UIWindow()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = navigationController
        XCTAssertEqual(window.topmostViewController, navigationController)
    }

    func testTopMostViewControllerMultiple() {
        let window = UIWindow()
        let viewController1 = RouterTests.TestModalPresentableController()
        let viewController2 = RouterTests.TestModalPresentableController()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        viewController1.fakePresentedViewController = viewController2
        viewController2.fakePresentingViewController = viewController1
        viewController2.fakePresentedViewController = navigationController
        window.rootViewController = viewController1
        XCTAssertEqual(window.topmostViewController, navigationController)
    }

    func testAllPresentedViewController() {
        let viewController1 = RouterTests.TestModalPresentableController()
        let viewController2 = RouterTests.TestModalPresentableController()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        viewController1.fakePresentedViewController = viewController2
        viewController2.fakePresentedViewController = navigationController
        XCTAssertEqual(viewController1.allPresentedViewControllers.count, 2)
        XCTAssertEqual(viewController2.allPresentedViewControllers.count, 1)
        XCTAssertEqual(navigationController.allPresentedViewControllers.count, 0)
    }

    func testFindViewControllerParent() {
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()

        tabBarController.viewControllers = [navigationController]
        navigationController.viewControllers = [viewController1]
        viewController1.addChild(viewController2)
        viewController2.addChild(UISplitViewController())

        XCTAssertEqual(try? UIViewController.findViewController(in: viewController2, options: [.parent], using: { _ in true }), viewController1)
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: [.current, .parent], using: { $0 is UISplitViewController }))
        XCTAssertEqual(try? UIViewController.findViewController(in: viewController2, options: [.current, .parent], using: { $0 is UINavigationController }), navigationController)
        XCTAssertEqual(try? UIViewController.findViewController(in: viewController2, options: [.current, .parent], using: { $0 is UITabBarController }), tabBarController)
    }

    func testFindViewController() {
        let viewController1 = RouterTests.TestModalPresentableController()
        let viewController2 = RouterTests.TestModalPresentableController()
        let testViewController = RouterTests.TestViewController()
        let invisibleController = InvisibleViewController()
        let viewController3 = FakePresentingNavigationController()
        viewController1.fakePresentedViewController = viewController2
        viewController2.fakePresentingViewController = viewController1
        viewController2.fakePresentedViewController = viewController3
        viewController3.fakePresentingViewController = viewController2
        viewController3.viewControllers = [invisibleController, testViewController]

        var searchOption = SearchOptions.current
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .presented
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .presenting
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))
    }

    func testFindViewControllerIsBeingDismissed() {
        class FakeBeingDismissedController: UIViewController {
            var isBeingDismissedValue = true
            var isBeingDismissedWasCalled = false
            override var isBeingDismissed: Bool {
                isBeingDismissedWasCalled = true
                return isBeingDismissedValue
            }
        }

        let viewController = FakeBeingDismissedController()
        let viewController2 = FakePresentingNavigationController()
        viewController2.fakePresentingViewController = viewController

        XCTAssertNil(try? UIViewController.findViewController(in: viewController, options: .current, using: { $0 is FakeBeingDismissedController }))
        XCTAssertTrue(viewController.isBeingDismissedWasCalled)

        viewController.isBeingDismissedWasCalled = false
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: [.current, .presenting], using: { $0 is FakeBeingDismissedController }))
        XCTAssertTrue(viewController.isBeingDismissedWasCalled)

        viewController.isBeingDismissedWasCalled = false
        viewController.isBeingDismissedValue = false
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController2, options: [.current, .presenting], using: { $0 is FakeBeingDismissedController }))
        XCTAssertTrue(viewController.isBeingDismissedWasCalled)
    }

    func testFindViewControllerWithCombinedOptions() {
        let viewController1 = RouterTests.TestModalPresentableController()
        let viewController2 = RouterTests.TestModalPresentableController()
        let testViewController = RouterTests.TestViewController()
        let invisibleController = InvisibleViewController()
        let viewController3 = FakePresentingNavigationController()
        viewController1.fakePresentedViewController = viewController2
        viewController2.fakePresentingViewController = viewController1
        viewController2.fakePresentedViewController = viewController3
        viewController3.fakePresentingViewController = viewController2
        viewController3.viewControllers = [invisibleController, testViewController]

        var searchOption: SearchOptions = [.presented, .current]
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = [.presenting, .current]
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = [.visible, .presented]
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = [.contained, .presented]
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .currentAllStack
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .currentVisibleOnly
        XCTAssertNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(try? UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))
    }

    func testArrayNonDismissibleViewController() {
        let array1 = [UIViewController(), RouterTests.TestRoutingControllingViewController()]
        let array2 = [UIViewController(), UINavigationController(rootViewController: RouterTests.TestRoutingControllingViewController())]
        let array3 = [UIViewController(), UIViewController()]
        XCTAssertFalse(array1.canBeDismissed)
        XCTAssertFalse(array2.canBeDismissed)
        XCTAssertTrue(array3.canBeDismissed)

        XCTAssert(array1.nonDismissibleViewController is RouterTests.TestRoutingControllingViewController)
        XCTAssert(array2.nonDismissibleViewController is UINavigationController)
        XCTAssert(array3.nonDismissibleViewController == nil)
    }

    func testArrayUniqueElements() {
        let viewController1 = UIViewController()
        let viewController2 = RouterTests.TestRoutingControllingViewController()
        let array = [viewController1, viewController2, viewController1]
        XCTAssertEqual(array.uniqueElements().count, 2)
        XCTAssertEqual(array.uniqueElements()[0], viewController1)
        XCTAssertEqual(array.uniqueElements()[1], viewController2)
    }

    func testArrayIsEqual() {
        let viewController1 = UIViewController()
        let viewController2 = RouterTests.TestRoutingControllingViewController()
        let array = [viewController1, viewController2, viewController1]
        XCTAssertFalse(array.isEqual(to: []))
        XCTAssertFalse(array.isEqual(to: [viewController2, viewController1]))
        XCTAssertFalse(array.isEqual(to: [viewController2, UIViewController()]))
        XCTAssertFalse(array.isEqual(to: [viewController1, viewController1, viewController2]))
        XCTAssertTrue(array.isEqual(to: [viewController1, viewController2, viewController1]))
    }

    func testViewControllerAllParents() {
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()
        let viewController3 = UIViewController()
        viewController1.addChild(viewController2)
        viewController2.addChild(viewController3)

        XCTAssertEqual(viewController3.allParents.count, 2)
        XCTAssertEqual(viewController3.allParents[0], viewController2)
        XCTAssertEqual(viewController3.allParents[1], viewController1)
        XCTAssertEqual(viewController2.allParents.count, 1)
        XCTAssertEqual(viewController2.allParents[0], viewController1)
        XCTAssertEqual(viewController1.allParents.count, 0)
    }

    func testRoutingInterceptorExecute() {

        class TestInterceptor<C>: RoutingInterceptor {

            typealias Context = C

            var prepareCallsCount = 0

            var performCallsCount = 0

            var throwInPrepare: Bool

            init(throwInPrepare: Bool = false) {
                self.throwInPrepare = throwInPrepare
            }

            func prepare(with context: Context) throws {
                prepareCallsCount += 1
                if throwInPrepare {
                    throw RoutingError.generic(.init("Test"))
                }
            }

            func perform(with context: Context, completion: @escaping (RoutingResult) -> Void) {
                performCallsCount += 1
                completion(.success)
            }
        }

        var interceptor1 = TestInterceptor<String>()
        var wasInCompletion = false
        XCTAssertNoThrow(try interceptor1.execute(with: "test", completion: { _ in
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(interceptor1.prepareCallsCount, 1)
        XCTAssertEqual(interceptor1.performCallsCount, 1)

        interceptor1 = TestInterceptor<String>()
        wasInCompletion = false
        XCTAssertNoThrow(interceptor1.commit(with: "test", completion: { _ in
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)

        var interceptor2 = TestInterceptor<Any?>()
        wasInCompletion = false
        XCTAssertNoThrow(try interceptor2.execute(completion: { _ in
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(interceptor2.prepareCallsCount, 1)
        XCTAssertEqual(interceptor2.performCallsCount, 1)

        interceptor2 = TestInterceptor<Any?>()
        wasInCompletion = false
        XCTAssertNoThrow(interceptor2.commit(completion: { _ in
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(interceptor2.prepareCallsCount, 1)
        XCTAssertEqual(interceptor2.performCallsCount, 1)

        var interceptor3 = TestInterceptor<Void>()
        wasInCompletion = false
        XCTAssertNoThrow(try interceptor3.execute(completion: { _ in
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(interceptor3.prepareCallsCount, 1)
        XCTAssertEqual(interceptor3.performCallsCount, 1)

        interceptor3 = TestInterceptor<Void>()
        wasInCompletion = false
        XCTAssertNoThrow(interceptor3.commit(completion: { _ in
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(interceptor3.prepareCallsCount, 1)
        XCTAssertEqual(interceptor3.performCallsCount, 1)

        interceptor3 = TestInterceptor<Void>(throwInPrepare: true)
        wasInCompletion = false
        XCTAssertNoThrow(interceptor3.commit(completion: { _ in
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(interceptor3.prepareCallsCount, 1)
        XCTAssertEqual(interceptor3.performCallsCount, 0)
    }

    func testContextTaskExecute() {
        class TestContextTask<VC: UIViewController, C>: ContextTask {

            typealias ViewController = VC
            typealias Context = C

            var prepareCallsCount = 0

            var performCallsCount = 0

            func prepare(with context: Context) throws {
                prepareCallsCount += 1
            }

            func perform(on viewController: ViewController, with context: C) throws {
                performCallsCount += 1
            }
        }

        let contextTask1 = TestContextTask<UIViewController, String>()
        XCTAssertNoThrow(try contextTask1.execute(on: UIViewController(), with: "Test"))
        XCTAssertEqual(contextTask1.prepareCallsCount, 1)
        XCTAssertEqual(contextTask1.performCallsCount, 1)

        let contextTask2 = TestContextTask<UIViewController, Any?>()
        XCTAssertNoThrow(try contextTask2.execute(on: UIViewController()))
        XCTAssertEqual(contextTask2.prepareCallsCount, 1)
        XCTAssertEqual(contextTask2.performCallsCount, 1)

        let contextTask3 = TestContextTask<UIViewController, Void>()
        XCTAssertNoThrow(try contextTask3.execute(on: UIViewController()))
        XCTAssertEqual(contextTask3.prepareCallsCount, 1)
        XCTAssertEqual(contextTask3.performCallsCount, 1)
    }

}

#endif
