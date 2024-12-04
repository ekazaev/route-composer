//
// RouteComposer
// ShortUITests.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import XCTest

class ShortUITests: XCTestCase {

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

    func testPromptScreenAndBack() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)
        app.buttons["Go to Welcome"].tap()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.terminate()
    }

    func testGoToSquareFromModalInTab() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Routing control"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

    }

    func testCollectionsAndReturnHome() {
        app.launch()

        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Collections*"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].exists)

        app.textFields["loginTextField"].tap()
        app.textFields["loginTextField"].typeText("abc")

        app.textFields["passwordTextField"].tap()
        app.textFields["passwordTextField"].typeText("abc")

        app.buttons["Login"].tap()

        XCTAssertTrue(app.tables["collectionsViewController"].waitForExistence(timeout: 5))

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.terminate()
    }

    func testCancelLoginScreenAndReturnHome() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Second modal"].tap()
        XCTAssertTrue(app.otherElements["secondLevelViewController"].waitForExistence(timeout: 3))

        app.buttons["Go to Berlin*"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].exists)

        app.buttons["Close"].tap()
        XCTAssertTrue(app.otherElements["secondLevelViewController"].exists)

        app.buttons["Go to Home"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.terminate()

    }

    func testImagesModule() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)

        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Images"].tap()
        XCTAssertTrue(app.tables["imagesViewController"].exists)

        app.tables.cells.element(boundBy: 2).tap()
        XCTAssertTrue(app.otherElements["imagestarViewController"].waitForExistence(timeout: 1))

        app.buttons["Dismiss"].tap()
        XCTAssertTrue(app.tables["imagesViewController"].waitForExistence(timeout: 1))

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Images (No Library)"].tap()
        XCTAssertTrue(app.tables["imagesViewController"].exists)

        app.tables.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.otherElements["imagesecondViewController"].waitForExistence(timeout: 1))

        app.buttons["Dismiss"].tap()
        XCTAssertTrue(app.tables["imagesViewController"].waitForExistence(timeout: 1))

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.terminate()

    }

    func testAlternativeStarRoute() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)

        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        var switcher = app.switches["routeSwitchControl"]
        switcher.tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Star Screen*"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].exists)

        app.textFields["loginTextField"].tap()
        app.textFields["loginTextField"].typeText("abc")

        app.textFields["passwordTextField"].tap()
        app.textFields["passwordTextField"].typeText("abc")

        app.buttons["Login"].tap()
        XCTAssertTrue(app.otherElements["starViewController"].waitForExistence(timeout: 4))

        app.buttons["Go to Product 02"].tap()
        XCTAssertTrue(app.otherElements["productViewController+02"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Star Screen*"].tap()
        XCTAssertTrue(app.otherElements["starViewController"].exists)

        app.buttons["Dismiss Star Tab*"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        switcher = app.switches["routeSwitchControl"]
        switcher.tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Star Screen*"].tap()
        XCTAssertTrue(app.otherElements["starViewController"].exists)

        app.buttons["Dismiss Star Tab*"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.terminate()

    }

    func testLastProductRoute() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)

        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Split*"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].exists)

        app.textFields["loginTextField"].tap()
        app.textFields["loginTextField"].typeText("abc")
        app.textFields["passwordTextField"].tap()
        app.textFields["passwordTextField"].typeText("abc")

        app.buttons["Login"].tap()

        XCTAssertTrue(app.otherElements["citiesSplitViewController"].waitForExistence(timeout: 3))

        app.buttons["Product"].tap()
        XCTAssertTrue(app.otherElements["productViewController+123"].waitForExistence(timeout: 3))
    }

    func testUnexpectedAnimation() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Routing control"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to New York*"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].waitForExistence(timeout: 3))

        app.textFields["loginTextField"].tap()
        app.textFields["loginTextField"].typeText("abc")

        app.textFields["passwordTextField"].tap()
        app.textFields["passwordTextField"].typeText("abc")

        app.buttons["Login"].tap()
        XCTAssertTrue(app.otherElements["cityDetailsViewController+2"].waitForExistence(timeout: 10))
    }

    func testGoProductFromCircle() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Product 00"].tap()
        XCTAssertTrue(app.otherElements["productViewController+00"].exists)

        app.buttons["Go to next Product from Circle"].tap()
        XCTAssertTrue(app.otherElements["productViewController+01"].waitForExistence(timeout: 20))

        app.buttons["Go to next Product from Circle"].tap()
        XCTAssertTrue(app.otherElements["productViewController+02"].waitForExistence(timeout: 20))

        app.buttons.matching(identifier: "Go to Product 01").element(boundBy: 0).tap()
        XCTAssertTrue(app.otherElements["productViewController+01"].waitForExistence(timeout: 20))

        app.buttons["Go to next Product from Circle"].tap()
        XCTAssertTrue(app.otherElements["productViewController+02"].waitForExistence(timeout: 20))

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].waitForExistence(timeout: 20))
    }

    func testGoToHome() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Product 00"].tap()
        XCTAssertTrue(app.otherElements["productViewController+00"].exists)

        app.buttons["Go to Home"].tap()
        XCTAssertTrue(app.otherElements["myHomeViewController"].waitForExistence(timeout: 3))
    }

    func testGoToSettings() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Product 00"].tap()
        XCTAssertTrue(app.otherElements["productViewController+00"].exists)

        app.buttons["Go to Settings"].tap()
        XCTAssertTrue(app.otherElements["settingsViewController"].waitForExistence(timeout: 3))
    }

}
