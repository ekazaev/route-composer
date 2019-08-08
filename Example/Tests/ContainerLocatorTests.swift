//
//  ContainerProviderTests.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 12/05/2019.
//  Copyright © 2019 HBC Digital. All rights reserved.
//

import XCTest
import UIKit
@testable import RouteComposer

class ContainerLocatorTests: XCTestCase {

    class TestContainerController: UIViewController, CustomContainerViewController {

        lazy var adapter: ContainerAdapter = TestContainerAdapter(with: self)

        let canBeDismissed: Bool = true

    }

    struct TestContainerAdapter<VC: ContainerViewController>: ConcreteContainerAdapter {

        init(with viewController: VC) {
        }

        let containedViewControllers: [UIViewController] = []

        let visibleViewControllers: [UIViewController] = []

        func makeVisible(_ viewController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
            completion(.success)
        }

        func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
            completion(.success)
        }

    }

    func testDefaultAdaptersResults() {
        let locator = DefaultContainerAdapterLocator()
        XCTAssertTrue(((try? locator.getAdapter(for: UINavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? locator.getAdapter(for: UITabBarController())) as? TabBarControllerAdapter<UITabBarController>) != nil)
        XCTAssertTrue(((try? locator.getAdapter(for: UISplitViewController())) as? SplitControllerAdapter<UISplitViewController>) != nil)
        XCTAssertTrue(((try? locator.getAdapter(for: ExtensionsTest.FakePresentingNavigationController())) as? NavigationControllerAdapter<UINavigationController>) != nil)
        XCTAssertTrue(((try? locator.getAdapter(for: TestContainerController())) as? TestContainerAdapter<TestContainerController>) != nil)
    }

    func testNavigationViewControllerAdapterDeallocation() {
        var navigationAdapter: NavigationControllerAdapter<UINavigationController>!
        autoreleasepool {
            var navigationController: UINavigationController? = UINavigationController()
            navigationAdapter = NavigationControllerAdapter(with: navigationController!)
            navigationController = nil
        }
        navigationAdapter.makeVisible(UIViewController(), animated: true) { result in
            XCTAssertFalse(result.isSuccessful)
        }
        navigationAdapter.setContainedViewControllers([], animated: true) { result in
            XCTAssertFalse(result.isSuccessful)
        }
    }

    func testSplitViewControllerAdapterDeallocation() {
        var splitAdapter: SplitControllerAdapter<UISplitViewController>!
        autoreleasepool {
            var splitController: UISplitViewController? = UISplitViewController()
            splitAdapter = SplitControllerAdapter(with: splitController!)
            splitController = nil
        }
        splitAdapter.makeVisible(UIViewController(), animated: true) { result in
            XCTAssertFalse(result.isSuccessful)
        }
        splitAdapter.setContainedViewControllers([], animated: true) { result in
            XCTAssertFalse(result.isSuccessful)
        }
    }

    func testTabViewControllerAdapterDeallocation() {
        var tabAdapter: TabBarControllerAdapter<UITabBarController>!
        autoreleasepool {
            var tabController: UITabBarController? = UITabBarController()
            tabAdapter = TabBarControllerAdapter(with: tabController!)
            tabController = nil
        }
        tabAdapter.makeVisible(UIViewController(), animated: true) { result in
            XCTAssertFalse(result.isSuccessful)
        }
        tabAdapter.setContainedViewControllers([], animated: true) { result in
            XCTAssertFalse(result.isSuccessful)
        }
        XCTAssertTrue(tabAdapter.visibleViewControllers.isEmpty)
        XCTAssertTrue(tabAdapter.containedViewControllers.isEmpty)
    }

    func testNavigationControllerAdepter() {
        let navigationAdapter = NavigationControllerAdapter<UINavigationController>(with: UINavigationController())
        XCTAssertEqual(navigationAdapter.visibleViewControllers.count, 0)
    }

    func testTabViewControllerAdapterSetContainedViewControllers() {
        let tabBarController = UITabBarController()
        let tabAdapter = TabBarControllerAdapter<UITabBarController>(with: tabBarController)
        var wasInCompletion = false
        tabAdapter.setContainedViewControllers([UIViewController(), UINavigationController()], animated: false, completion: { result in
            wasInCompletion = true
            XCTAssertTrue(result.isSuccessful)
            XCTAssertEqual(tabAdapter.containedViewControllers.count, 2)
            XCTAssertTrue(tabAdapter.containedViewControllers.last is UINavigationController)
        })
        XCTAssertTrue(wasInCompletion)
        wasInCompletion = false
        tabAdapter.makeVisible(UIViewController(), animated: false, completion: { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testNavigationViewControllerWrongControllerToMakeVisible() {
        let navigationController = UINavigationController(rootViewController: UIViewController())
        let navigationAdapter = NavigationControllerAdapter(with: navigationController)
        var wasInCompletion = false
        navigationAdapter.makeVisible(UIViewController(), animated: true) { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        }
        XCTAssertTrue(wasInCompletion)
    }

    func testContainerAdapterContainsAndVisible() {
        let navigationController = UINavigationController()
        let tabBarController = UITabBarController()
        let viewController = UIViewController()
        navigationController.setViewControllers([tabBarController, viewController], animated: false)
        let navigationAdapter = NavigationControllerAdapter(with: navigationController)
        XCTAssertTrue(navigationAdapter.contains(tabBarController))
        XCTAssertTrue(navigationAdapter.contains(viewController))
        XCTAssertFalse(navigationAdapter.contains(UIViewController()))
        XCTAssertFalse(navigationAdapter.contains(navigationController))
        XCTAssertFalse(navigationAdapter.isVisible(tabBarController))
        XCTAssertTrue(navigationAdapter.isVisible(viewController))
        XCTAssertFalse(navigationAdapter.isVisible(UIViewController()))
        XCTAssertFalse(navigationAdapter.isVisible(navigationController))
    }

}
