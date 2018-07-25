import UIKit
import XCTest
@testable import RouteComposer

class ContainerTests: XCTestCase {
    
    var children:[ChildFactory<Any?>]!
    
    override func setUp() {
        super.setUp()
        let factory = EmptyFactory()
        guard let anyFactory = FactoryBox.box(for: factory) else {
            XCTAssert(false, "Factory box is nil")
            return
        }
        children = [ChildFactory<Any?>(anyFactory), ChildFactory<Any?>(anyFactory)]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChildViewControllersBuild() {
        let container = EmptyContainer()
        guard let childrenControllers = try? container.buildChildrenViewControllers(from: children, with: nil) else {
            XCTAssert(false, "Unable to build children view controllers")
            return
        }
        XCTAssertEqual(childrenControllers.count, 2)
    }
    
    func testMergeRightAction() {
        var children = self.children!
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: NavigationControllerFactory.PushToNavigation()))!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: NavigationControllerFactory.PushAsRoot()))!))
        children.insert(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: NavigationControllerFactory.PushReplacingLast()))!), at: 0)
        
        var container = EmptyContainer()
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 2)
    }
    
    func testMergeWrongAction() {
        var container = EmptyContainer()
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 2)
    }
    
    func testNavigationControllerContainer() {
        var container = NavigationControllerFactory(action: GeneralAction.PresentModally())
        var children:[ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: NavigationControllerFactory.PushToNavigation()))!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: NavigationControllerFactory.PushToNavigation()))!))
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 0)
        guard let containerController = try? container.build(with: nil) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerController.viewControllers.count, 2)
    }
    
    func testTabBarControllerContainer() {
        var container = TabBarControllerFactory(action: GeneralAction.PresentModally())
        var children:[ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: TabBarControllerFactory.AddTab()))!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: TabBarControllerFactory.AddTab()))!))
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 0)
        guard let containerController = try? container.build(with: nil) else {
            XCTAssert(false, "Unable to build UITabBarController")
            return
        }
        XCTAssertEqual(containerController.viewControllers!.count, 2)
    }
    
    func testSplitControllerContainer() {
        var container = SplitControllerFactory(action: GeneralAction.PresentModally())
        var children:[ChildFactory<Any?>] = []
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: SplitControllerFactory.PushToMaster()))!))
        children.append(ChildFactory<Any?>(FactoryBox.box(for: EmptyFactory(action: SplitControllerFactory.PushToDetails()))!))
        let restChildren = container.merge(children)
        XCTAssertEqual(restChildren.count, 0)
        guard let containerController = try? container.build(with: nil) else {
            XCTAssert(false, "Unable to build UISplitViewController")
            return
        }
        XCTAssertEqual(containerController.viewControllers.count, 2)
    }
    
}
