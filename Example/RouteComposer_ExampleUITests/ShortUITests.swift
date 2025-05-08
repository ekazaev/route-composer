//
// RouteComposer
// ShortUITests.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import XCTest

@MainActor
class ShortUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPromptScreenAndBack() {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)
        app.buttons["Go to Welcome"].tap()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.terminate()
    }

    func testGoToSquareFromModalInTab() {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Product 00"].tap()
        XCTAssertTrue(app.otherElements["productViewController+00"].waitForExistence(timeout: 20))

        app.buttons["Go to next Product from Circle"].tap()
        XCTAssertTrue(app.otherElements["productViewController+01"].waitForExistence(timeout: 20))

        app.buttons["Go to next Product from Circle"].tap()
        XCTAssertTrue(app.otherElements["productViewController+02"].waitForExistence(timeout: 20))

        wait(2)

        app.buttons.matching(identifier: "Go to Product 01").element(boundBy: 0).tap()
        XCTAssertTrue(app.otherElements["productViewController+01"].waitForExistence(timeout: 20))

        app.buttons["Go to next Product from Circle"].tap()
        XCTAssertTrue(app.otherElements["productViewController+02"].waitForExistence(timeout: 20))

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].waitForExistence(timeout: 20))
    }

    func testGoToHome() {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
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

extension XCTestCase {
    func wait(_ timeout: TimeInterval) {
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 5)
    }
}
