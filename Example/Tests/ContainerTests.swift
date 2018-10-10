import UIKit
import XCTest
@testable import RouteComposer

class ContainerTests: XCTestCase {

    func testChildViewControllersBuild() {
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.pushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.pushToNavigation()))!))
        guard let childrenControllers = try? ChildCoordinator(childFactories: children).build(with: nil) else {
            XCTAssert(false, "Unable to build children view controllers")
            return
        }
        XCTAssertEqual(childrenControllers.count, 2)
    }

    func testNavigationControllerContainer() {
        let container = NavigationControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.pushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.pushToNavigation()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testNavigationControllerContainer2() {
        let container = NavigationControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.pushToNavigation()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(NavigationControllerFactory.pushReplacingLast()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 1)
    }

    func testTabBarControllerContainer() {
        let container = TabBarControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.addTab()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.addTab()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UITabBarController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testSplitControllerContainer() {
        let container = SplitControllerFactory()
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(SplitControllerFactory.setAsMaster()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(SplitControllerFactory.pushToDetails()))!))
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UISplitViewController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testCompleteFactory() {
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.addTab()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.addTab()))!))
        let factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        let viewController = try? factory.build(with: nil)
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewController?.viewControllers?.count, 2)
    }

    func testCompleteFactorySmartActions() {
        var children: [DelayedIntegrationFactory<Any?>] = []
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.addTab()))!))
        children.append(DelayedIntegrationFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: ContainerActionBox(TabBarControllerFactory.addTab(at: 0, replacing: true)))!))
        let factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        let viewController = try? factory.build(with: nil)
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewController?.viewControllers?.count, 1)
    }

}
