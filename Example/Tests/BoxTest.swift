//
// Created by Eugene Kazaev on 25/07/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import XCTest
@testable import RouteComposer

class BoxTests: XCTestCase {

    func testFactoryBox() {
        let factory = EmptyFactory()
        XCTAssertNotNil(FactoryBox(factory, action: ActionBox(ViewControllerActions.NilAction())))
    }

    func testContainerBox() {
        let factory = EmptyContainer()
        XCTAssertNotNil(ContainerFactoryBox(factory, action: ActionBox(ViewControllerActions.NilAction())))
    }

    func testNilFactoryBox() {
        let factory = NilFactory<UIViewController, Any?>()
        XCTAssertNil(FactoryBox(factory, action: ActionBox(ViewControllerActions.NilAction())))
    }

    func testContainerBoxChildrenScrape() {
        let factory = EmptyContainer()
        var box = ContainerFactoryBox(factory, action: ActionBox(ViewControllerActions.NilAction()))
        XCTAssertNotNil(box)
        var children: [AnyFactory] = []
        children.append(FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!)
        children.append(FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!)
        children.append(FactoryBox(EmptyFactory(), action: ActionBox(ViewControllerActions.NilAction()))!)

        let resultChildren = try? box?.scrapeChildren(from: children)
        XCTAssertEqual(resultChildren??.count, 1)
        XCTAssertEqual(box?.children.count, 2)
    }

    func testNilInAssembly() {
        let routingStep = StepAssembly(finder: NilFinder<UIViewController, Any?>(),
                factory: NilFactory<UIViewController, Any?>())
                .using(ViewControllerActions.NilAction())
                .from(GeneralStep.current())
                .assemble()
        let step = routingStep.previousStep as? BaseStep
        XCTAssertNotNil(step)
        XCTAssertNil(step?.factory)
        XCTAssertNil(step?.finder)
    }

    func testNilInCompleteFactoryAssembly() {
        let factory = CompleteFactoryAssembly(factory: TabBarControllerFactory<Any?>())
                .with(NilFactory<UIViewController, Any?>(), using: UITabBarController.add())
                .with(NilFactory<UIViewController, Any?>(), using: UITabBarController.add())
                .assemble()
        XCTAssertEqual(factory.childFactories.count, 0)
    }

    func testActionBox() {

        class TestAction: Action {

            func perform(with viewController: UIViewController, on existingController: UINavigationController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
                existingController.viewControllers = [viewController]
            }

        }
        let action = TestAction()
        let actionBox = ActionBox(action)
        let navigationController = UINavigationController()
        actionBox.perform(with: UIViewController(), on: navigationController, animated: true) { result in
            guard case .continueRouting = result else {
                XCTAssert(false)
                return
            }
        }
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    func testContainerActionBox() {

        class TestContainerAction: ContainerAction {

            func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
                childViewControllers.append(viewController)
            }

            func perform(with viewController: UIViewController, on existingController: UINavigationController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
                existingController.viewControllers = [viewController]
            }

        }
        let action = TestContainerAction()
        let actionBox = ContainerActionBox(action)
        let navigationController = UINavigationController()
        actionBox.perform(with: UIViewController(), on: navigationController, animated: true) { result in
            guard case .continueRouting = result else {
                XCTAssert(false)
                return
            }
        }
        XCTAssertEqual(navigationController.children.count, 1)

        try? actionBox.perform(embedding: UIViewController(), in: &navigationController.viewControllers)
        XCTAssertEqual(navigationController.children.count, 2)
    }

    func testBaseEntitiesCollector() {
        let collector = BaseEntitiesCollector<FactoryBox<ClassNameFactory>, ActionBox>(finder: ClassFinder<UIViewController, Any?>(),
                factory: ClassNameFactory<UIViewController, Any?>(), action: GeneralAction.replaceRoot())
        XCTAssertNotNil(collector.finder)
        XCTAssertNotNil(collector.factory)
        XCTAssertTrue(collector.finder is FinderBox<ClassFinder<UIViewController, Any?>>)
        XCTAssertTrue(collector.factory is FactoryBox<ClassNameFactory<UIViewController, Any?>>)
        XCTAssertTrue(collector.factory?.action is ActionBox<ViewControllerActions.ReplaceRootAction>)
    }

    func testNilBaseEntitiesCollector() {
        let collector = BaseEntitiesCollector<FactoryBox<NilFactory>, ActionBox>(finder: NilFinder<UIViewController, Any?>(),
                factory: NilFactory(), action: ViewControllerActions.NilAction())
        XCTAssertNil(collector.finder)
        XCTAssertNil(collector.factory)
    }

    func testNilFactoryBaseEntitiesCollector() {
        let collector = BaseEntitiesCollector<FactoryBox<NilFactory>, ActionBox>(finder: ClassFinder<UIViewController, Any?>(),
                factory: NilFactory(), action: ViewControllerActions.NilAction())
        XCTAssertNotNil(collector.finder)
        XCTAssertNotNil(collector.factory)
        XCTAssertTrue(collector.factory is FactoryBox<FinderFactory<ClassFinder<UIViewController, Any?>>>)
        XCTAssertTrue(collector.factory?.action is ActionBox<ViewControllerActions.NilAction>)
    }

}
