//
// RouteComposer
// AllRoutesInAppUITests.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import XCTest

class AllRoutesInAppUITests: XCTestCase {

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

    func testAllRoutesInHome() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Blue color"].tap()
        XCTAssertTrue(app.otherElements["colorViewController"].exists)
        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Routing control"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        let switcher = app.switches["dissmissalSwitchControl"]
        switcher.tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Yellow color"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Moscow*"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        switcher.tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Yellow color"].tap()
        XCTAssertTrue(app.otherElements["colorViewController"].exists)

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Routing control"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Moscow*"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].waitForExistence(timeout: 1))

        app.textFields["loginTextField"].tap()
        app.textFields["loginTextField"].typeText("abc")

        app.textFields["passwordTextField"].tap()
        app.textFields["passwordTextField"].typeText("abc")

        app.buttons["Login"].tap()
        XCTAssertTrue(app.otherElements["cityDetailsViewController+2"].waitForExistence(timeout: 20))

        app.buttons["Go to Cities"].tap()
        XCTAssertTrue(app.otherElements["citiesSplitViewController"].waitForExistence(timeout: 1))

        app.tables.cells.element(boundBy: 5).tap()
        XCTAssertTrue(app.otherElements["cityDetailsViewController+6"].exists)

        app.buttons["Go to Cities"].tap()
        XCTAssertTrue(app.otherElements["citiesSplitViewController"].waitForExistence(timeout: 1))

        app.buttons["Square"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Figures in Circle Tab*"].tap()
        XCTAssertTrue(app.otherElements["figuresViewController"].exists)

        app.buttons["Go to Figures"].tap()
        XCTAssertTrue(app.otherElements["figuresViewController"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Figures + Product 03 in Circle Tab*"].tap()
        XCTAssertTrue(app.otherElements["productViewController+03"].exists)

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.otherElements["figuresViewController"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Second modal"].tap()
        XCTAssertTrue(app.otherElements["secondLevelViewController"].waitForExistence(timeout: 3))

        app.buttons["Go to Red Color"].tap()
        XCTAssertTrue(app.otherElements["colorViewController"].exists)

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["secondLevelViewController"].exists)

        app.buttons["Go to Home"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].waitForExistence(timeout: 3))

        app.buttons["Go to Product 00"].tap()
        XCTAssertTrue(app.otherElements["productViewController+00"].exists)

        app.buttons["Go to Product 01"].tap()
        XCTAssertTrue(app.otherElements["productViewController+01"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Star Screen*"].tap()
        XCTAssertTrue(app.otherElements["starViewController"].waitForExistence(timeout: 7))

        app.buttons["Go to Product 02"].tap()
        XCTAssertTrue(app.otherElements["productViewController+02"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].waitForExistence(timeout: 3))

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Star Screen*"].tap()
        XCTAssertTrue(app.otherElements["starViewController"].exists)

        app.buttons["Dismiss Star Tab*"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Split*"].tap()
        XCTAssertTrue(app.otherElements["citiesSplitViewController"].exists)

        app.buttons["Square"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Login"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].exists)

        app.buttons["Close"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.terminate()
    }

}

#endif
