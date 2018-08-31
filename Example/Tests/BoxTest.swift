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
        XCTAssertNotNil(FactoryBox.box(for: factory, action: GeneralAction.NilAction()))
    }

    func testContainerBox() {
        let factory = EmptyContainer()
        XCTAssertNotNil(ContainerFactoryBox.box(for: factory, action: GeneralAction.NilAction()))
    }

    func testNilFactoryBox() {
        let factory = NilFactory<UIViewController, Any?>()
        XCTAssertNil(FactoryBox.box(for: factory, action: GeneralAction.NilAction()))
    }

    func testNilInAssembly() {
        let routingStep = StepAssembly(finder: NilFinder<UIViewController, Any?>(),
                factory: NilFactory<UIViewController, Any?>())
                .using(GeneralAction.NilAction()).from(CurrentViewControllerStep())
                .assemble()
        guard let step = routingStep as? BaseStep<FactoryBox<NilFactory<UIViewController, Any?>>> else {
            XCTAssert(false, "Internal inconsistency")
            return
        }
        XCTAssertNil(step.factory)
        XCTAssertNil(step.finder)
    }

    func testNilInCompleteFactoryAssembly() {
        let factory = CompleteFactoryAssembly(factory: TabBarControllerFactory())
                .with(NilFactory<UIViewController, Any?>(), using: NavigationControllerFactory.PushToNavigation())
                .with(NilFactory<UIViewController, Any?>(), using: NavigationControllerFactory.PushToNavigation())
                .assemble()
        XCTAssertEqual(factory.childFactories.count, 0)
    }

}
