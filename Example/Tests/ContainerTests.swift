import UIKit
import XCTest
@testable import RouteComposer

class ContainerTests: XCTestCase {

    func testChildViewControllersBuild() {
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!))
        try? prepare(children: &children)
        guard let childrenControllers = try? ChildCoordinator(childFactories: children).build(with: nil) else {
            XCTAssert(false, "Unable to build children view controllers")
            return
        }
        XCTAssertEqual(childrenControllers.count, 2)
    }

    func testNavigationControllerContainer() {
        let container = NavigationControllerFactory<Any?>()
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!))
        try? prepare(children: &children)
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testNavigationControllerContainer2() {
        let container = NavigationControllerFactory<Any?>()
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.pushReplacingLast()))!))
        try? prepare(children: &children)
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UINavigationController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 1)
    }

    func testTabBarControllerContainer() {
        let container = TabBarControllerFactory<Any?>()
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add()))!))
        try? prepare(children: &children)
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UITabBarController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testSplitControllerContainer() {
        let container = SplitControllerFactory<Any?>()
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UISplitViewController.setAsMaster()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UISplitViewController.pushToDetails()))!))
        try? prepare(children: &children)
        guard let containerViewController = try? container.build(with: nil, integrating: ChildCoordinator(childFactories: children)) else {
            XCTAssert(false, "Unable to build UISplitViewController")
            return
        }
        XCTAssertEqual(containerViewController.children.count, 2)
    }

    func testCompleteFactory() {
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add()))!))
        try? prepare(children: &children)
        let factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        let viewController = try? factory.build(with: nil)
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewController?.viewControllers?.count, 2)
    }

    func testCompleteFactoryPrepareMethod() {

        class EmptyFactory: Factory {

            var prepareCount = 0

            init() {
            }

            func prepare(with context: Any?) throws {
                prepareCount += 1
            }

            func build(with context: Any?) throws -> UIViewController {
                return UIViewController()
            }

        }

        let childFactory1 = EmptyFactory()
        let childFactory2 = EmptyFactory()
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(childFactory1, action: ContainerActionBox(UITabBarController.add()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(childFactory2, action: ContainerActionBox(UITabBarController.add()))!))
        var factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        try? factory.prepare(with: nil)
        let viewController = try? factory.build(with: nil)
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewController?.viewControllers?.count, 2)
        XCTAssertEqual(childFactory1.prepareCount, 1)
        XCTAssertEqual(childFactory2.prepareCount, 1)
    }

    func testBuildPreparedFactory() {
        var prepareCount = 0
        var buildCount = 0

        class TestFactory: ContainerFactory {
            typealias ViewController = UINavigationController

            typealias Context = Any?

            var prepareBlock: () -> Void

            var buildBlock: () -> Void

            init(prepareBlock: @escaping () -> Void, buildBlock: @escaping () -> Void) {
                self.buildBlock = buildBlock
                self.prepareBlock = prepareBlock
            }

            func prepare(with context: Any?) throws {
                prepareBlock()
            }

            func build(with context: Any?, integrating coordinator: ChildCoordinator<Any?>) throws -> UINavigationController {
                buildBlock()
                return UINavigationController()
            }

        }
        let factory = TestFactory(prepareBlock: { prepareCount += 1 }, buildBlock: { buildCount += 1 })
        XCTAssertNoThrow(try factory.buildPrepared(with: nil))
        XCTAssertEqual(prepareCount, 1)
        XCTAssertEqual(buildCount, 1)

        XCTAssertNoThrow(try factory.buildPrepared())
        XCTAssertEqual(prepareCount, 2)
        XCTAssertEqual(buildCount, 2)
    }

    func testCompleteFactorySmartActions() {
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add(at: 0, replacing: true)))!))
        try? prepare(children: &children)
        let factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        let viewController = try? factory.build(with: nil)
        XCTAssertNotNil(viewController)
        XCTAssertEqual(viewController?.viewControllers?.count, 1)
    }

    func testCompleteFactoryDescription() {
        var children: [PostponedIntegrationFactory<Any?>] = []
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add()))!))
        children.append(PostponedIntegrationFactory<Any?>(for: FactoryBox(EmptyFactory(), action: ContainerActionBox(UITabBarController.add()))!))
        try? prepare(children: &children)
        let factory = CompleteFactory(factory: TabBarControllerFactory(), childFactories: children)
        XCTAssertEqual(factory.description, "TabBarControllerFactory<Optional<Any>>(delegate: nil, configuration: nil)")
    }

    private func prepare(children: inout [PostponedIntegrationFactory<Any?>]) throws {
        children = try children.map({
            var factory = $0
            try factory.prepare(with: nil)
            return factory
        })
    }

}
