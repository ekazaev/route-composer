//
// RouteComposer
// SwiftUITests.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import XCTest

@MainActor
class SwiftUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSwiftUIViewFromProduct() {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)
        app.buttons["Go to Product 00"].tap()
        XCTAssertTrue(app.otherElements["productViewController+00"].exists)
        app.buttons["Go to SwiftUI"].tap()
        XCTAssertTrue(app.buttons["SwiftUI+RouteComposer"].exists)
        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)
        app.terminate()
    }

}
