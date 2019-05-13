//
// Created by Eugene Kazaev on 25/07/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
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
        XCTAssertEqual(resultChildren?.count, 1)
        XCTAssertEqual(box?.children.count, 2)
    }

    func testContainerBoxChildrenScrapeSameAction() {
        let factory = EmptyContainer()
        var box = ContainerFactoryBox(factory, action: ActionBox(ViewControllerActions.NilAction()))
        XCTAssertNotNil(box)
        var children: [AnyFactory] = []
        children.append(FactoryBox(ClassNameFactory<UIViewController, Any?>(), action: ContainerActionBox(UINavigationController.push()))!)
        children.append(FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!)
        children.append(ContainerFactoryBox(NavigationControllerFactory<Any?>(), action: ActionBox(ViewControllerActions.PresentModallyAction()))!)
        children.append(FactoryBox(EmptyFactory(), action: ContainerActionBox(UINavigationController.push()))!)
        children.append(FactoryBox(ClassNameFactory<UIViewController, Any?>(), action: ContainerActionBox(UINavigationController.push()))!)

        let resultChildren = try? box?.scrapeChildren(from: children)
        XCTAssertEqual(resultChildren?.count, 3)
        XCTAssertEqual(box?.children.count, 2)
        XCTAssertTrue(resultChildren?.first! is ContainerFactoryBox<NavigationControllerFactory<Any?>>)
        XCTAssertTrue(box?.children.first!.factory is FactoryBox<ClassNameFactory<UIViewController, Any?>>)
        XCTAssertTrue(resultChildren?.last! is FactoryBox<ClassNameFactory<UIViewController, Any?>>)
    }

    func testNilInAssembly() {
        let routingStep = StepAssembly(finder: NilFinder<UIViewController, Any?>(),
                factory: NilFactory<UIViewController, Any?>())
                .using(ViewControllerActions.NilAction())
                .from(GeneralStep.current())
                .assemble()
        let step = routingStep.getPreviousStep(with: nil as Any?) as? BaseStep
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
        let postponedIntegrationHandler = DefaultRouter.DefaultPostponedIntegrationHandler(logger: nil, containerAdapterProvider: DefaultContainerAdapterProvider())
        try? actionBox.perform(with: UIViewController(), on: navigationController, with: postponedIntegrationHandler, nextAction: nil, animated: true) { result in
            guard case .continueRouting = result else {
                XCTAssert(false)
                return
            }
        }
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertNil(postponedIntegrationHandler.containerViewController)
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
        let postponedIntegrationHandler = DefaultRouter.DefaultPostponedIntegrationHandler(logger: nil, containerAdapterProvider: DefaultContainerAdapterProvider())
        let embeddingController = UIViewController()
        try? actionBox.perform(with: embeddingController, on: navigationController, with: postponedIntegrationHandler, nextAction: nil, animated: true) { result in
            guard case .continueRouting = result else {
                XCTAssert(false)
                return
            }
        }
        XCTAssertEqual(navigationController.children.count, 1)

        let anotherEmbeddingController = UIViewController()
        try? actionBox.perform(with: anotherEmbeddingController,
                on: navigationController,
                with: postponedIntegrationHandler,
                nextAction: ContainerActionBox(action),
                animated: true) { result in
            guard case .continueRouting = result else {
                XCTAssert(false)
                return
            }
        }
        XCTAssertEqual(navigationController.children.count, 1)
        XCTAssertEqual(postponedIntegrationHandler.containerViewController as? UINavigationController, navigationController)
        XCTAssertEqual(postponedIntegrationHandler.postponedViewControllers.count, 2)
        XCTAssertEqual(postponedIntegrationHandler.postponedViewControllers.first, embeddingController)
        XCTAssertEqual(postponedIntegrationHandler.postponedViewControllers.last, anotherEmbeddingController)

        try? postponedIntegrationHandler.purge(animated: false, completion: {
            XCTAssertEqual(navigationController.viewControllers.count, 2)

            try? actionBox.perform(embedding: UIViewController(), in: &navigationController.viewControllers)
            XCTAssertEqual(navigationController.viewControllers.count, 3)
        })
    }

    func testActionIsEmbeddable() {
        let action = ActionBox(GeneralAction.presentModally())

        XCTAssertFalse(action.isEmbeddable(to: UINavigationController.self))
        XCTAssertFalse(action.isEmbeddable(to: UITabBarController.self))
        XCTAssertFalse(action.isEmbeddable(to: UISplitViewController.self))
    }

    func testContainerActionIsEmbeddable() {
        let action = ContainerActionBox(UINavigationController.push())

        XCTAssertTrue(action.isEmbeddable(to: UINavigationController.self))
        XCTAssertFalse(action.isEmbeddable(to: UITabBarController.self))
        XCTAssertFalse(action.isEmbeddable(to: UISplitViewController.self))
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
