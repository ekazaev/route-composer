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

        context = RoutingError.Context("Test description")
        error = RoutingError.initialController(.notFound, context)
        XCTAssertEqual(error.description, "Initial Controller Error (Initial controller not found): Test description")

        context = RoutingError.Context("Test description")
        error = RoutingError.initialController(.deallocated, context)
        XCTAssertEqual(error.description, "Initial Controller Error (Initial controller deallocated): Test description")
    }

    func testContextDescription() {
        var context = RoutingError.Context("Test description")
        XCTAssertEqual(context.description, "Test description")

        context = RoutingError.Context("")
        XCTAssertEqual(context.description, "No valuable information provided")

        context = RoutingError.Context("", underlyingError: RoutingError.generic(.init("Test")))
        XCTAssertEqual(context.description, "Generic Error: Test")
    }

    func testErrorValues() {
        let context = RoutingError.Context("Test description")
        let error = RoutingError.generic(context)
        XCTAssertThrowsError(try RoutingResult.failure(error).value.get())
        XCTAssertNoThrow(try RoutingResult.success.value.get())

        XCTAssertThrowsError(try ActionResult.failure(error).value.get())
        XCTAssertNoThrow(try ActionResult.continueRouting.value.get())

        XCTAssertThrowsError(try InterceptorResult.failure(error).value.get())
        XCTAssertNoThrow(try InterceptorResult.continueRouting.value.get())
    }

    func testGetError() {
        let context = RoutingError.Context("Test description")
        let error = RoutingError.generic(context)
        XCTAssertEqual((try? RoutingResult.failure(error).getError() as? RoutingError)?.description, error.description)
        XCTAssertThrowsError(try RoutingResult.success.getError())

        XCTAssertEqual((try? ActionResult.failure(error).getError() as? RoutingError)?.description, error.description)
        XCTAssertThrowsError(try ActionResult.continueRouting.getError())

        XCTAssertEqual((try? InterceptorResult.failure(error).getError() as? RoutingError)?.description, error.description)
        XCTAssertThrowsError(try InterceptorResult.continueRouting.getError())
    }

}
