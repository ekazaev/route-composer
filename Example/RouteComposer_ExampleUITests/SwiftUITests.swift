//
// RouteComposer
// SwiftUITests.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation

import XCTest

class SwiftUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests
        // before they run. The setUp method is a good place to do this.

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSwiftUIViewFromProduct() {
        if #available(iOS 13, *) {
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

}
