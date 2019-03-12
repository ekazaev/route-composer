//
//  SingleNavigationTest.swift
//  RouteComposer_Tests
//
//  Created by ekazaev on 12/03/2019.
//  Copyright © 2019 HBC Digital. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import RouteComposer

class SingleNavigationTest: XCTestCase {

    let router = SingleNavigationRouter(router: DefaultRouter(), lock: SingleNavigationLock())

    // Fakes modal presentation action using `TestModalPresentableController`
    struct FakeTimedPresentModallyAction: Action {
        // We can not present modally on the view controllers that are not in the window hierarchy - so we will just fake this action
        func perform(with viewController: UIViewController, on existingController: RouterTests.TestModalPresentableController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
            let deadline = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                existingController.fakePresentedViewController = viewController
                completion(.continueRouting)
            }
        }
        
    }
    
    func testSimultaniusNavigation() {
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
            XCTAssertNotNil(currentViewController.presentedViewController)
            XCTAssert(currentViewController.presentedViewController is UINavigationController)
            if let navigationController = currentViewController.presentedViewController as? UINavigationController {
                XCTAssertEqual(navigationController.viewControllers.count, 1)
                XCTAssert(navigationController.viewControllers[0] is RouterTests.TestViewController)
            }
            expectation.fulfill()
        }))
        
        XCTAssertThrowsError(try router.navigate(to: screenConfig, with: nil, animated: false, completion: { result in
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
}
