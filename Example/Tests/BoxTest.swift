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
        XCTAssertNotNil(FactoryBox.box(for: factory))
    }
    
    func testFactoryContainerBox() {
        let factory = EmptyContainer()
        XCTAssertNotNil(FactoryBox.box(for: factory))
    }
    
    func testContainerBox() {
        let factory = EmptyContainer()
        XCTAssertNotNil(ContainerFactoryBox.box(for: factory))
    }
    
    func testNilFactoryBox() {
        let factory = NilFactory<UIViewController, Any?>()
        XCTAssertNil(FactoryBox.box(for: factory))
    }
    
    func testNilInAssembly() {
        let routingStep = StepAssembly(finder: NilFinder<UIViewController, Any?>(), factory: NilFactory<UIViewController, Any?>()).assemble(from: CurrentViewControllerStep())
        guard let s = routingStep as? BaseStep<FactoryBox<NilFactory<UIViewController, Any?>>> else {
            XCTAssert(false, "Internal inconsistency")
            return
        }
        XCTAssertNil(s.factory)
        XCTAssertNil(s.finder)
    }

    func testNilInCompleteFactoryAssembly() {
        let f = CompleteFactoryAssembly(factory: TabBarControllerFactory(action:GeneralAction.PresentModally()))
                .with(NilFactory<UIViewController, Any?>(action: NavigationControllerFactory.PushToNavigation()))
                .with(NilFactory<UIViewController, Any?>(action: NavigationControllerFactory.PushToNavigation()))
                .assemble()
        XCTAssertEqual(f.childFactories.count, 0)
    }

}