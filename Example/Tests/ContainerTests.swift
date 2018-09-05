import UIKit
import XCTest
@testable import RouteComposer

class ContainerTests: XCTestCase {

    func testChildViewControllersBuild() {
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        let container = EmptyContainer()
        guard let childrenControllers = try? container.buildChildrenViewControllers(from: children, with: nil) else {
            XCTAssert(false, "Unable to build children view controllers")
            return
        }
        XCTAssertEqual(childrenControllers.count, 2)
    }

    func testNavigationControllerContainer() {
        let container = NavigationControllerFactory()
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        guard let containerViewController = try? container.build(with: nil, integrating: (try? container.buildChildrenViewControllers(from: children, with: nil)) ?? []) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 2)
    }

    func testNavigationControllerContainer2() {
        let container = NavigationControllerFactory()
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushReplacingLast())!))
        guard let containerViewController = try? container.build(with: nil, integrating: (try? container.buildChildrenViewControllers(from: children, with: nil)) ?? []) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 1)
    }

    func testTabBarControllerContainer() {
        let container = TabBarControllerFactory()
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: TabBarControllerFactory.AddTab())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: TabBarControllerFactory.AddTab())!))
        guard let containerViewController = try? container.build(with: nil, integrating: (try? container.buildChildrenViewControllers(from: children, with: nil)) ?? []) else {
            XCTAssert(false, "Unable to build UITabBarController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 2)
    }

    func testSplitControllerContainer() {
        let container = SplitControllerFactory()
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: SplitControllerFactory.PushToMaster())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: SplitControllerFactory.PushToDetails())!))
        guard let containerViewController = try? container.build(with: nil, integrating: (try? container.buildChildrenViewControllers(from: children, with: nil)) ?? []) else {
            XCTAssert(false, "Unable to build UISplitViewController")
            return
        }
        XCTAssertEqual(containerViewController.childViewControllers.count, 2)
    }

}
