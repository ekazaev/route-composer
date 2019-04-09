//
// Created by Eugene Kazaev on 2019-04-07.
// Copyright (c) 2019 HBC Digital. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import RouteComposer

class ErrorTests: XCTestCase {

    func testErrorDescription() {
        var context = RoutingError.Context("Test description")
        var error = RoutingError.generic(context)
        XCTAssertEqual(error.description, "Generic Error: Test description")

        context = RoutingError.Context("Test description")
        error = RoutingError.typeMismatch(String.self, context)
        XCTAssertEqual(error.description, "Type Mismatch Error: Test description")

        context = RoutingError.Context("Test description")
        error = RoutingError.compositionFailed(context)
        XCTAssertEqual(error.description, "Composition Failed Error: Test description")
    }

    func testContextDescription() {
        var context = RoutingError.Context("Test description")
        XCTAssertEqual(context.description, "Test description")

        context = RoutingError.Context("")
        XCTAssertEqual(context.description, "No valuable information provided")

        context = RoutingError.Context("", underlyingError: RoutingError.generic(.init("Test")))
        XCTAssertEqual(context.description, "Generic Error: Test")
    }

}