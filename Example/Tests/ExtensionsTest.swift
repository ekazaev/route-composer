//
// Created by Eugene Kazaev on 11/09/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import RouteComposer

class ExtensionsTest: XCTestCase {

    class InvisibleViewController: UIViewController {

    }

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
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .presented
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .presenting
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = [.presented, .current]
        XCTAssertNotNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = [.presenting, .current]
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = [.visible, .presented]
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = [.contained, .presented]
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .currentAllStack
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))

        searchOption = .currentVisibleOnly
        XCTAssertNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController1, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController2, options: searchOption, using: { $0 is RouterTests.TestModalPresentableController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNil(UIViewController.findViewController(in: viewController3, options: searchOption, using: { $0 is InvisibleViewController }))
        XCTAssertNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is UINavigationController }))
        XCTAssertNotNil(UIViewController.findViewController(in: testViewController, options: searchOption, using: { $0 is RouterTests.TestViewController }))
        XCTAssertNotNil(UIViewController.findViewController(in: invisibleController, options: searchOption, using: { $0 is InvisibleViewController }))
    }

    func testTabBarControllerExtension() {
        let viewController1 = UIViewController()
        let viewController2 = UINavigationController()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [viewController1, viewController2]
        XCTAssertEqual(tabBarController.containedViewControllers.count, 2)
        XCTAssertEqual(tabBarController.visibleViewControllers.count, 1)
        XCTAssertEqual(tabBarController.visibleViewControllers[0], viewController1)
        tabBarController.makeVisible(viewController2, animated: false)
        XCTAssertEqual(tabBarController.visibleViewControllers[0], viewController2)
    }

    func testNavigationControllerExtension() {
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController1, viewController2]
        XCTAssertEqual(navigationController.containedViewControllers.count, 2)
        XCTAssertEqual(navigationController.visibleViewControllers.count, 1)
        XCTAssertEqual(navigationController.visibleViewControllers[0], viewController2)
        navigationController.makeVisible(viewController1, animated: false)
        XCTAssertEqual(navigationController.visibleViewControllers[0], viewController1)
    }

    func testSplitControllerExtension() {
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()
        let splitController = UISplitViewController()
        splitController.preferredDisplayMode = .primaryHidden
        splitController.viewControllers = [viewController1, viewController2]
        XCTAssertEqual(splitController.containedViewControllers.count, 2)
        XCTAssertEqual(splitController.visibleViewControllers.count, splitController.isCollapsed ? 1 : 2)
        XCTAssertEqual(splitController.visibleViewControllers[0], splitController.isCollapsed ? viewController2 : viewController1)
    }

    func testArrayExtension() {
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

    func testArrayExtensionUniqueElements() {
        let viewController1 = UIViewController()
        let viewController2 = RouterTests.TestRoutingControllingViewController()
        let array = [viewController1, viewController2, viewController1]
        XCTAssertEqual(array.uniqueElements().count, 2)
        XCTAssertEqual(array.uniqueElements()[0], viewController1)
        XCTAssertEqual(array.uniqueElements()[1], viewController2)
    }

    func testAllParents() {
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
    
}
