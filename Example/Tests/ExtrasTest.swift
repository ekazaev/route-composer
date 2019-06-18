//
//  ExtrasTest.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 12/03/2019.
//  Copyright © 2019 HBC Digital. All rights reserved.
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

    func testSimultaneousNavigation() {
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
        XCTAssertNoThrow(try contextTask.apply(on: viewController, with: "context"))
        XCTAssertEqual(viewController.context, "context")
    }

    func testDismissalMethodProvidingContextTask() {
        class DismissingViewController: UIViewController, Dismissible {
            var dismissalBlock: ((Void, Bool, ((RoutingResult) -> Void)?) -> Void)?
        }

        let viewController = DismissingViewController()
        var wasInCompletion = false
        try? DismissalMethodProvidingContextTask<DismissingViewController, Any?>(dismissalBlock: { (_: Void, animated, _) in
            XCTAssertEqual(animated, true)
            wasInCompletion = true
        }).apply(on: viewController, with: nil)
        viewController.dismissViewController(animated: true)
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

}
