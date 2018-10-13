import UIKit
import XCTest
@testable import RouteComposer

class ContainerTests: XCTestCase {

    func testChildViewControllersBuild() {
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UINavigationController.pushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UINavigationController.pushToNavigation()))!))
        guard let childrenControllers = try? ChildCoordinator(childFactories: children).build(with: nil) else {
            XCTAssert(false, "Unable to build children view controllers")
            return
        }
        XCTAssertEqual(childrenControllers.count, 2)
    }

    func testNavigationControllerContainer() {
        let container = NavigationControllerFactory<Any?>()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UINavigationController.pushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UINavigationController.pushToNavigation()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testNavigationControllerContainer2() {
        let container = NavigationControllerFactory<Any?>()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UINavigationController.pushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UINavigationController.pushReplacingLast()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 1)
    }

    func testTabBarControllerContainer() {
        let container = TabBarControllerFactory<Any?>()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UITabBarController.addTab()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UITabBarController.addTab()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UITabBarController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testSplitControllerContainer() {
        let container = SplitControllerFactory<Any?>()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UISplitViewController.setAsMaster()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UISplitViewController.pushToDetails()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UISplitViewController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testCompleteFactory() {
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UITabBarController.addTab()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UITabBarController.addTab()))!))
        let factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        let viewController = try? factory.build(with: nil)
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewController?.viewControllers?.count, 2)
    }

    func testCompleteFactorySmartActions() {
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UITabBarController.addTab()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(UITabBarController.addTab(at: 0, replacing: true)))!))
        let factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        let viewController = try? factory.build(with: nil)
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewController?.viewControllers?.count, 1)
    }

}
