//
// Created by Eugene Kazaev on 25/07/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import XCTest
@testable import RouteComposer

class ActionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNilAction() {
        var wasInCompletion = false
        GeneralAction.NilAction().perform(with: UIViewController(), on: UIViewController(), animated: true, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testPresentModally() {
        class PresentingModallyController: UIViewController {
            override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
                completion?()
            }
        }

        class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

        }

        var wasInCompletion = false
        var wasInPopoverConfig = false
        let viewController = UIViewController()
        let transitionDelegate = TransitionDelegate()
        GeneralAction.PresentModally(presentationStyle: .popover,
                transitionStyle: .crossDissolve,
                transitioningDelegate: transitionDelegate,
                preferredContentSize: CGSize(width: 100, height: 100),
                popoverConfiguration: { _ in
            wasInPopoverConfig = true
        }).perform(with: viewController, on: PresentingModallyController(), animated: true, completion: { result in
            wasInCompletion = true
            XCTAssertEqual(viewController.modalPresentationStyle, UIModalPresentationStyle.popover)
            XCTAssertEqual(viewController.modalTransitionStyle, UIModalTransitionStyle.crossDissolve)
            XCTAssertEqual(viewController.preferredContentSize.width, 100)
            XCTAssertEqual(viewController.preferredContentSize.height, 100)
            XCTAssertTrue(viewController.transitioningDelegate === transitionDelegate)
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertTrue(wasInPopoverConfig)

        let presentedViewController = RouterTests.TestModalPresentableController()
        presentedViewController.fakePresentedViewController = UIViewController()
        wasInCompletion = false
        GeneralAction.PresentModally().perform(with: UIViewController(), on: presentedViewController, animated: true, completion: { result in
            wasInCompletion = true
            if case .continueRouting = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testNavReplacingLast() {
        var viewControllerStack: [UIViewController] = []
        NavigationControllerFactory.PushReplacingLast().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        NavigationControllerFactory.PushReplacingLast().perform(embedding: UINavigationController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))
    }

    func testNavPushAsRoot() {
        var viewControllerStack: [UIViewController] = []
        NavigationControllerFactory.PushAsRoot().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        NavigationControllerFactory.PushAsRoot().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))

        var wasInCompletion = false
        let navigationController = UINavigationController(rootViewController: UIViewController())
        let newRootController = UIViewController()
        NavigationControllerFactory.PushAsRoot().perform(with: newRootController, on: navigationController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers[0] === newRootController)
    }

    func testNavPushToNavigation() {
        var viewControllerStack: [UIViewController] = []
        NavigationControllerFactory.PushToNavigation().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        NavigationControllerFactory.PushToNavigation().perform(embedding: UINavigationController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.last!.isKind(of: UINavigationController.self))
        XCTAssert(viewControllerStack.first!.isKind(of: UIViewController.self))

        var wasInCompletion = false
        let navigationController = UINavigationController(rootViewController: UIViewController())
        let viewController = UIViewController()
        NavigationControllerFactory.PushToNavigation().perform(with: viewController, on: navigationController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers.removeLast() === viewController)
    }

    func testTabAddTab() {
        var viewControllerStack: [UIViewController] = []
        TabBarControllerFactory.AddTab().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        TabBarControllerFactory.AddTab().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.first!.isKind(of: UIViewController.self))
        XCTAssert(viewControllerStack.last!.isKind(of: UINavigationController.self))

        var wasInCompletion = false
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UIViewController()]
        let viewController = UIViewController()
        TabBarControllerFactory.AddTab().perform(with: viewController, on: tabBarController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(tabBarController.viewControllers?.count, 2)
        XCTAssertTrue(tabBarController.viewControllers?.removeLast() === viewController)
    }

    func testTabAddTabAt() {
        var viewControllerStack: [UIViewController] = []
        TabBarControllerFactory.AddTab(at: 1).perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        TabBarControllerFactory.AddTab(at: 0).perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))
        XCTAssert(viewControllerStack.last!.isKind(of: UIViewController.self))

        var wasInCompletion = false
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UIViewController()]
        let viewController = UIViewController()
        TabBarControllerFactory.AddTab(at: 0).perform(with: viewController, on: tabBarController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(tabBarController.viewControllers?.count, 2)
        XCTAssertTrue(tabBarController.viewControllers?.removeFirst() === viewController)
    }

    func testTabAddTabReplacing() {
        var viewControllerStack: [UIViewController] = []
        TabBarControllerFactory.AddTab(at: 1, replacing: true).perform(embedding: UIViewController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        TabBarControllerFactory.AddTab(at: 0, replacing: true).perform(embedding: UINavigationController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))

        var wasInCompletion = false
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UIViewController()]
        let viewController = UIViewController()
        TabBarControllerFactory.AddTab(at: 0, replacing: true).perform(with: viewController, on: tabBarController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(tabBarController.viewControllers?.count, 1)
        XCTAssertTrue(tabBarController.viewControllers?.removeFirst() === viewController)
    }

}
