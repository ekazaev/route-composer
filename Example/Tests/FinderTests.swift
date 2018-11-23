//
// Created by Eugene Kazaev on 2018-11-07.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import RouteComposer

class FinderTest: XCTestCase {

    func testInstanceFinder() {
        let viewController = UIViewController()
        let finder = InstanceFinder<UIViewController, Any?>(instance: viewController)
        XCTAssertEqual(finder.instance, viewController)
        XCTAssertEqual(finder.findViewController(with: nil), viewController)
    }

    func testNilFinder() {
        let finder = NilFinder<UIViewController, Any?>()
        XCTAssertNil(finder.findViewController(with: nil))
    }

    func testDefaultIteratorDefaultValues() {
        let iterator = DefaultStackIterator()
        XCTAssertEqual(iterator.options, .fullStack)
        XCTAssertEqual(iterator.startingPoint, .topmost)
        XCTAssertEqual(iterator.startingViewController, UIApplication.shared.keyWindow?.topmostViewController)
    }

    func testDefaultIteratorNewValues() {
        let iterator = DefaultStackIterator(options: .current, startingPoint: .root)
        XCTAssertEqual(iterator.options, .current)
        XCTAssertEqual(iterator.startingPoint, .root)
        XCTAssertEqual(iterator.startingViewController, UIApplication.shared.keyWindow?.rootViewController)
    }

    func testSearchOptionsDescription() {
        let fullStack = SearchOptions.fullStack
        XCTAssertEqual(fullStack.description, "current, contained, presented, presenting")

        let currentVisibleOnly = SearchOptions.currentVisibleOnly
        XCTAssertEqual(currentVisibleOnly.description, "current, visible")

        let someOptions = [SearchOptions.current, .contained, .parent]
        XCTAssertEqual(someOptions.description, "[current, contained, parent]")
    }

}
