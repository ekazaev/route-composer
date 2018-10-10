//
//  RouteComposerExampleUITests.swift
//  RouteComposer_ExampleUITests
//
//  Created by Eugene Kazaev on 22/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

class RouteComposerExampleUITests: XCTestCase {

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
        app.buttons["Go to welcome"].tap()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.terminate()
    }

    func testAllRoutesInHome() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to blue color modal"].tap()
        XCTAssertTrue(app.otherElements["colorViewController"].exists)
        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to routing control modal"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        let switcher = app.switches["dissmissalSwitchControl"]
        switcher.tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to yellow color"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to Moscow*"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        switcher.tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        app.buttons["Go to yellow color"].tap()
        XCTAssertTrue(app.otherElements["colorViewController"].exists)

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to routing control modal"].tap()
        XCTAssertTrue(app.otherElements["routingRuleViewController"].exists)

        sleep(1) // Just for better demo
        app.buttons["Go to Moscow*"].tap()
        XCTAssertTrue(app.otherElements["loginViewController"].exists)

        app.textFields["loginTextField"].tap()
        app.textFields["loginTextField"].typeText("abc")

        app.textFields["passwordTextField"].tap()
        app.textFields["passwordTextField"].typeText("abc")

        app.buttons["Login"].tap()
        sleep(3)
        // We have to wait for login service to succeed
        // Apple uses same technique http://cleanswifter.com/asynchronous-xcode-ui-testing/
        XCTAssertTrue(app.otherElements["cityDetailsViewController+2"].exists)

        app.buttons["Back programmaticaly"].tap()
        sleep(1)
        XCTAssertTrue(app.otherElements["citiesSplitViewController"].exists)

        self.app.tables.cells.element(boundBy: 5).tap()
        XCTAssertTrue(app.otherElements["cityDetailsViewController+6"].exists)

        app.buttons["Back programmaticaly"].tap()
        sleep(1)
        XCTAssertTrue(app.otherElements["citiesSplitViewController"].exists)

        app.buttons["Square"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go push to Circle Tab*"].tap()
        XCTAssertTrue(app.otherElements["emptyViewController"].exists)

        app.buttons["Go to Self!"].tap()
        XCTAssertTrue(app.otherElements["emptyViewController"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to second modal level"].tap()
        sleep(3)
        XCTAssertTrue(app.otherElements["secondLevelViewController"].exists)

        app.buttons["Go to Red Color"].tap()
        XCTAssertTrue(app.otherElements["colorViewController"].exists)

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["secondLevelViewController"].exists)

        app.buttons["Go to Home"].tap()
        sleep(3)
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to product 00"].tap()
        XCTAssertTrue(app.otherElements["productViewController+00"].exists)

        app.buttons["Go to Product 01"].tap()
        XCTAssertTrue(app.otherElements["productViewController+01"].exists)

        app.buttons["Go to Circle Tab"].tap()
        XCTAssertTrue(app.otherElements["circleViewController"].exists)

        app.buttons["Go to Square Tab"].tap()
        XCTAssertTrue(app.otherElements["squareViewController"].exists)

        app.buttons["Go to Star Screen*"].tap()
        XCTAssertTrue(app.otherElements["starViewController"].exists)

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
        sleep(3)

        XCTAssertTrue(app.tables["collectionsViewController"].exists)

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.terminate()
    }

    func testDenieLoginScreenAndReturnHome() {
        app.launch()
        XCTAssertTrue(app.otherElements["promptViewController"].exists)
        app.buttons["Continue"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to second modal level"].tap()
        sleep(3)
        XCTAssertTrue(app.otherElements["secondLevelViewController"].exists)

        app.buttons["Go to Minsk*"].tap()
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
        sleep(1)

        self.app.tables.cells.element(boundBy: 2).tap()
        XCTAssertTrue(app.otherElements["imagestarViewController"].exists)
        sleep(1)

        app.buttons["Dismiss"].tap()
        XCTAssertTrue(app.tables["imagesViewController"].exists)

        app.buttons["Done"].tap()
        XCTAssertTrue(app.otherElements["homeViewController"].exists)

        app.buttons["Go to Images (No Library)"].tap()
        XCTAssertTrue(app.tables["imagesViewController"].exists)
        sleep(1)

        self.app.tables.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.otherElements["imagesecondViewController"].exists)
        sleep(1)

        app.buttons["Dismiss"].tap()
        XCTAssertTrue(app.tables["imagesViewController"].exists)

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
        sleep(3)
        XCTAssertTrue(app.otherElements["starViewController"].exists)

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

}
