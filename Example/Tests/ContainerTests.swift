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

    func testMergeRightAction() {
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: GeneralAction.NilAction())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: GeneralAction.NilAction())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushAsRoot())!))
        children.insert(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushReplacingLast())!), at: 0)

        var container = EmptyContainer()
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 2)
    }

    func testMergeWrongAction() {
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: GeneralAction.NilAction())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: GeneralAction.NilAction())!))
        var container = EmptyContainer()
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 2)
    }

    func testNavigationControllerContainer() {
        var container = NavigationControllerFactory()
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: NavigationControllerFactory.PushToNavigation())!))
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 0)
        guard let containerController = try? container.build(with: nil) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerController.viewControllers.count, 2)
    }

    func testTabBarControllerContainer() {
        var container = TabBarControllerFactory()
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: TabBarControllerFactory.AddTab())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: TabBarControllerFactory.AddTab())!))
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 0)
        guard let containerController = try? container.build(with: nil) else {
            XCTAssert(false, "Unable to build UITabBarController")
            return
        }
        XCTAssertEqual(containerController.viewControllers!.count, 2)
    }

    func testSplitControllerContainer() {
        var container = SplitControllerFactory()
        var children: [ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: SplitControllerFactory.PushToMaster())!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(), action: SplitControllerFactory.PushToDetails())!))
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 0)
        guard let containerController = try? container.build(with: nil) else {
            XCTAssert(false, "Unable to build UISplitViewController")
            return
        }
        XCTAssertEqual(containerController.viewControllers.count, 2)
    }

}
