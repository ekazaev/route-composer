//
// Created by Eugene Kazaev on 25/07/2018.
//

@testable import RouteComposer

#if os(iOS)

import UIKit
import XCTest

class ActionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNilAction() {
        var wasInCompletion = false
        ViewControllerActions.NilAction().perform(with: UIViewController(), on: UIViewController(), animated: true, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testReplaceRootAction() {
        class TestWindow: UIWindow {
            var isKey: Bool = false

            override func makeKeyAndVisible() {
                isKey = true
            }

        }

        struct TestWindowProvider: WindowProvider {
            let window: UIWindow?

            init(window: UIWindow) {
                self.window = window
            }
        }

        let window = TestWindow()
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        let windowProvider = TestWindowProvider(window: window)
        let action = ViewControllerActions.ReplaceRootAction(windowProvider: windowProvider)
        let newRootViewController = UIViewController()
        var wasInCompletion = false
        action.perform(with: newRootViewController, on: rootViewController, animated: false) { _ in
            wasInCompletion = true
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertTrue(window.isKey)
        XCTAssertEqual(window.rootViewController, newRootViewController)

        wasInCompletion = false
        XCTAssertNoThrow(action.perform(with: newRootViewController, on: rootViewController, animated: false, completion: { result in
            guard case .failure(_) = result else {
                XCTAssertTrue(false)
                return
            }
            wasInCompletion = true
        }))
        XCTAssertTrue(wasInCompletion)
    }

    func testReplaceRootActionAnimated() {
        class TestWindow: UIWindow {
            var isKey: Bool = false

            override func makeKeyAndVisible() {
                isKey = true
            }

        }

        struct TestWindowProvider: WindowProvider {
            let window: UIWindow?

            init(window: UIWindow) {
                self.window = window
            }
        }

        let expectation = XCTestExpectation(description: "Animated root view controller replacement")
        let window = TestWindow()
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        let windowProvider = TestWindowProvider(window: window)
        let action = ViewControllerActions.ReplaceRootAction(windowProvider: windowProvider, animationOptions: .transitionCurlUp, duration: 0.3)
        let newRootViewController = UIViewController()
        var wasInCompletion = false
        action.perform(with: newRootViewController, on: rootViewController, animated: false) { _ in
            wasInCompletion = true
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.3)
        XCTAssertTrue(wasInCompletion)
        XCTAssertTrue(window.isKey)
        XCTAssertEqual(window.rootViewController, newRootViewController)
    }

    func testReplaceRootActionNoKeyWindow() {
        var window: UIWindow? = UIWindow()
        let action = ViewControllerActions.ReplaceRootAction(windowProvider: CustomWindowProvider(window: window!), animationOptions: .transitionCurlUp, duration: 0.3)
        window = nil
        let rootViewController = UIViewController()
        let newRootViewController = UIViewController()
        var wasInCompletion = false
        action.perform(with: newRootViewController, on: rootViewController, animated: false) { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        }
        XCTAssertTrue(wasInCompletion)
    }

    func testPresentModallyAction() {
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
        GeneralAction.presentModally(presentationStyle: .popover,
                transitionStyle: .crossDissolve,
                transitioningDelegate: transitionDelegate,
                preferredContentSize: CGSize(width: 100, height: 100),
                isModalInPresentation: true,
                popoverConfiguration: { _ in
                    wasInPopoverConfig = true
                }).perform(with: viewController, on: PresentingModallyController(), animated: true, completion: { result in
            wasInCompletion = true
            XCTAssertEqual(viewController.modalPresentationStyle, UIModalPresentationStyle.popover)
            XCTAssertEqual(viewController.modalTransitionStyle, UIModalTransitionStyle.crossDissolve)
            XCTAssertEqual(viewController.preferredContentSize.width, 100)
            XCTAssertEqual(viewController.preferredContentSize.height, 100)
            if #available(iOS 13, *) {
                XCTAssertEqual(viewController.isModalInPresentation, true)
            }
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
        GeneralAction.presentModally().perform(with: UIViewController(), on: presentedViewController, animated: true, completion: { result in
            wasInCompletion = true
            if case .success = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testPushReplacingLastAction() {
        var viewControllerStack: [UIViewController] = []
        UINavigationController.pushReplacingLast().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        UINavigationController.pushReplacingLast().perform(embedding: UINavigationController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))

        let testViewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: UIViewController())
        var wasInCompletion = false
        UINavigationController.pushReplacingLast().perform(with: testViewController, on: navigationController, animated: false, completion: { result in
            XCTAssert(result.isSuccessful)
            XCTAssertEqual(testViewController, navigationController.viewControllers.first)
            wasInCompletion = true
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testPushAsRootAction() {
        var viewControllerStack: [UIViewController] = []
        UINavigationController.pushAsRoot().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        UINavigationController.pushAsRoot().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))

        var wasInCompletion = false
        let navigationController = UINavigationController(rootViewController: UIViewController())
        let newRootController = UIViewController()
        UINavigationController.pushAsRoot().perform(with: newRootController, on: navigationController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers[0] === newRootController)
    }

    func testPushAction() {
        var viewControllerStack: [UIViewController] = []
        UINavigationController.push().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        UINavigationController.push().perform(embedding: UINavigationController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.last!.isKind(of: UINavigationController.self))
        XCTAssert(viewControllerStack.first!.isKind(of: UIViewController.self))

        var wasInCompletion = false
        let navigationController = UINavigationController(rootViewController: UIViewController())
        let viewController = UIViewController()
        UINavigationController.push().perform(with: viewController, on: navigationController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers.removeLast() === viewController)
    }

    func testAddTabAction() {
        var viewControllerStack: [UIViewController] = []
        UITabBarController.add().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        UITabBarController.add().perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.first!.isKind(of: UIViewController.self))
        XCTAssert(viewControllerStack.last!.isKind(of: UINavigationController.self))

        var wasInCompletion = false
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UIViewController()]
        let viewController = UIViewController()
        UITabBarController.add().perform(with: viewController, on: tabBarController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(tabBarController.viewControllers?.count, 2)
        XCTAssertTrue(tabBarController.viewControllers?.removeLast() === viewController)
    }

    func testAddTabActionAtIndex() {
        var viewControllerStack: [UIViewController] = []
        UITabBarController.add(at: 1).perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        UITabBarController.add(at: 0).perform(embedding: UINavigationController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))
        XCTAssert(viewControllerStack.last!.isKind(of: UIViewController.self))

        var wasInCompletion = false
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UIViewController()]
        let viewController = UIViewController()
        UITabBarController.add(at: 0).perform(with: viewController, on: tabBarController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(tabBarController.viewControllers?.count, 2)
        XCTAssertTrue(tabBarController.viewControllers?.removeFirst() === viewController)
    }

    func testAddTabActionReplacingAtIndex() {
        var viewControllerStack: [UIViewController] = []
        UITabBarController.add(at: 1, replacing: true).perform(embedding: UIViewController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        UITabBarController.add(at: 0, replacing: true).perform(embedding: UINavigationController(),
                in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)
        XCTAssert(viewControllerStack.first!.isKind(of: UINavigationController.self))

        var wasInCompletion = false
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UIViewController()]
        let viewController = UIViewController()
        UITabBarController.add(at: 0, replacing: true).perform(with: viewController, on: tabBarController, animated: false, completion: { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        })
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(tabBarController.viewControllers?.count, 1)
        XCTAssertTrue(tabBarController.viewControllers?.first === viewController)
    }

    func testSetAsMasterAction() {
        var viewControllerStack: [UIViewController] = []
        try? UISplitViewController.setAsMaster().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        try? UISplitViewController.setAsMaster().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 1)

        viewControllerStack.append(UIViewController())

        try? UISplitViewController.setAsMaster().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)

        var wasInCompletion = false
        let splitController = UISplitViewController()
        let viewController = UIViewController()
        UISplitViewController.setAsMaster().perform(with: viewController, on: splitController, animated: false) { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(splitController.viewControllers.count, 1)
        XCTAssertTrue(splitController.viewControllers.first === viewController)
    }

    func testPushToDetailsAction() {
        var viewControllerStack: [UIViewController] = []
        XCTAssertThrowsError(try UISplitViewController.pushToDetails().perform(embedding: UIViewController(), in: &viewControllerStack))

        viewControllerStack.append(UIViewController())

        try? UISplitViewController.pushToDetails().perform(embedding: UIViewController(), in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 2)

        let lastViewController = UIViewController()
        try? UISplitViewController.pushToDetails().perform(embedding: lastViewController, in: &viewControllerStack)
        XCTAssertEqual(viewControllerStack.count, 3)
        XCTAssertEqual(viewControllerStack.last, lastViewController)

        var wasInCompletion = false
        let splitController = UISplitViewController()
        let viewController = UIViewController()
        UISplitViewController.pushToDetails().perform(with: viewController, on: splitController, animated: false) { result in
            wasInCompletion = true
            if case .success = result {
                XCTAssert(false)
            }
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(splitController.viewControllers.count, 0)

        wasInCompletion = false
        splitController.viewControllers = [UIViewController()]
        UISplitViewController.pushToDetails().perform(with: viewController, on: splitController, animated: false) { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(splitController.viewControllers.count, 2)
        XCTAssertTrue(splitController.viewControllers.last === viewController)
    }

    func testPushOnToDetailsAction() {
        var viewControllerStack: [UIViewController] = []
        XCTAssertThrowsError(try UISplitViewController.pushOnToDetails().perform(embedding: UIViewController(), in: &viewControllerStack))

        viewControllerStack.append(UIViewController())
        XCTAssertThrowsError(try UISplitViewController.pushOnToDetails().perform(embedding: UIViewController(), in: &viewControllerStack))

        XCTAssertNoThrow(try UISplitViewController.pushOnToDetails().perform(embedding: UINavigationController(), in: &viewControllerStack))
        XCTAssertEqual(viewControllerStack.count, 2)

        XCTAssertThrowsError(try UISplitViewController.pushOnToDetails().perform(embedding: UINavigationController(), in: &viewControllerStack))
        XCTAssertEqual(viewControllerStack.count, 2)

        let lastViewController = UIViewController()
        XCTAssertNoThrow(try UISplitViewController.pushOnToDetails().perform(embedding: lastViewController, in: &viewControllerStack))
        XCTAssertEqual(viewControllerStack.count, 2)
        XCTAssertNotEqual(viewControllerStack.last, lastViewController)
        XCTAssertEqual((viewControllerStack.last as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((viewControllerStack.last as? UINavigationController)?.viewControllers.last, lastViewController)

        var wasInCompletion = false
        let splitController = UISplitViewController()
        var viewController = UIViewController()
        UISplitViewController.pushOnToDetails().perform(with: viewController, on: splitController, animated: false) { result in
            wasInCompletion = true
            if case .success = result {
                XCTAssert(false)
            }
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(splitController.viewControllers.count, 0)

        wasInCompletion = false
        splitController.viewControllers = [UIViewController()]
        UISplitViewController.pushOnToDetails().perform(with: viewController, on: splitController, animated: false) { result in
            wasInCompletion = true
            if case .success = result {
                XCTAssert(false)
            }
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(splitController.viewControllers.count, 1)

        wasInCompletion = false
        let navController: UINavigationController = UINavigationController()
        splitController.viewControllers = [UIViewController(), navController]
        UISplitViewController.pushOnToDetails().perform(with: viewController, on: splitController, animated: false) { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssertTrue(navController.viewControllers.last === viewController)

        viewController = UIViewController()
        UISplitViewController.pushOnToDetails().perform(with: viewController, on: splitController, animated: false) { result in
            wasInCompletion = true
            if case .failure(_) = result {
                XCTAssert(false)
            }
        }
        XCTAssertTrue(wasInCompletion)
        XCTAssertEqual(navController.viewControllers.count, 2)
        XCTAssertTrue(navController.viewControllers.last === viewController)
    }

    func testCustomWindowProvider() {
        let window = UIWindow()
        let customProvider = CustomWindowProvider(window: window)
        XCTAssertEqual(window, customProvider.window)
    }

}

#endif
