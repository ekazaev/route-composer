import UIKit
import XCTest
@testable import RouteComposer

class ContainerTests: XCTestCase {

    func testChildViewControllersBuild() {
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.PushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.PushToNavigation()))!))
        guard let childrenControllers = try? ChildCoordinator(childFactories: children).build(with: nil) else {
            XCTAssert(false, "Unable to build children view controllers")
            return
        }
        XCTAssertEqual(childrenControllers.count, 2)
    }

    func testNavigationControllerContainer() {
        let container = NavigationControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.PushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.PushToNavigation()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 2)
    }

    func testNavigationControllerContainer2() {
        let container = NavigationControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.PushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.PushReplacingLast()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 1)
    }

    func testTabBarControllerContainer() {
        let container = TabBarControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.AddTab()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.AddTab()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UITabBarController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 2)
    }

    func testSplitControllerContainer() {
        let container = SplitControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(SplitControllerFactory.PushToMaster()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(SplitControllerFactory.PushToDetails()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UISplitViewController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 2)
    }

}
