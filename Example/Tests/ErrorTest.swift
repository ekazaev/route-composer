//
// RouteComposer
// ErrorTest.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
@testable import RouteComposer
import UIKit
import XCTest

extension RoutingError.Context: Equatable {

    public static func == (lhs: RoutingError.Context, rhs: RoutingError.Context) -> Bool {
        lhs.description == rhs.description && "\(String(describing: lhs.underlyingError))" == "\(String(describing: rhs.underlyingError))"
    }

}

class ErrorTests: XCTestCase {

    func testErrorDescription() {
        var context = RoutingError.Context("Test description")
        var error = RoutingError.generic(context)
        XCTAssertEqual(error.description, "Generic Error: Test description")

        context = RoutingError.Context("Test description")
        error = RoutingError.typeMismatch(type: Int.self, expectedType: String.self, context)
        XCTAssertEqual(error.description, "Type Mismatch Error: Type Int is not equal to the expected type String. Test description")

        context = RoutingError.Context("Test description")
        error = RoutingError.typeMismatch(type: Int?.self, expectedType: String.self, context)
        XCTAssertEqual(error.description, "Type Mismatch Error: Type Optional<Int> is not equal to the expected type String. Test description")

        context = RoutingError.Context("Test description",
                                       underlyingError: DecodingError.valueNotFound(String.self, .init(codingPath: [], debugDescription: "Second description")))
        error = RoutingError.typeMismatch(type: Int?.self, expectedType: String.self, context)
        XCTAssertEqual(error.description, "Type Mismatch Error: Type Optional<Int> is not equal to the expected type String. " +
            "Test description -> valueNotFound(Swift.String, Swift.DecodingError.Context(codingPath: [], debugDescription: \"Second description\", underlyingError: nil))")

        context = RoutingError.Context("Test description")
        error = RoutingError.compositionFailed(context)
        XCTAssertEqual(error.description, "Composition Failed Error: Test description")

        context = RoutingError.Context("Test description")
        error = RoutingError.initialController(.notFound, context)
        XCTAssertEqual(error.description, "Initial Controller Error: Initial controller not found. Test description")

        context = RoutingError.Context("Test description")
        error = RoutingError.initialController(.deallocated, context)
        XCTAssertEqual(error.description, "Initial Controller Error: Initial controller deallocated. Test description")
    }

    func testErrorContext() {
        let context = RoutingError.Context("Test description", underlyingError: DecodingError.valueNotFound(String.self,
                                                                                                            .init(codingPath: [], debugDescription: "Second description")))
        var error = RoutingError.generic(context)
        XCTAssertEqual(error.context, context)

        error = RoutingError.typeMismatch(type: Int.self, expectedType: String.self, context)
        XCTAssertEqual(error.context, context)

        error = RoutingError.compositionFailed(context)
        XCTAssertEqual(error.context, context)

        error = RoutingError.initialController(.notFound, context)
        XCTAssertEqual(error.context, context)

        error = RoutingError.generic(context)
        XCTAssertEqual(error.context, context)
    }

    func testErrorContextDescription() {
        var context = RoutingError.Context("Test description")
        XCTAssertEqual(context.description, "Test description")

        context = RoutingError.Context("")
        XCTAssertEqual(context.description, "No valuable information provided")

        context = RoutingError.Context("", underlyingError: RoutingError.generic(.init("Test")))
        XCTAssertEqual(context.description, "Generic Error: Test")

        context = RoutingError.Context("Test description", underlyingError: RoutingError.generic(.init("Test")))
        XCTAssertEqual(context.description, "Test description -> Generic Error: Test")
    }

    func testErrorValues() {
        let context = RoutingError.Context("Test description")
        let error = RoutingError.generic(context)
        XCTAssertThrowsError(try RoutingResult.failure(error).swiftResult.get())
        XCTAssertNoThrow(try RoutingResult.success.swiftResult.get())
    }

    func testGetError() {
        let context = RoutingError.Context("Test description")
        let error = RoutingError.generic(context)
        XCTAssertEqual((try? RoutingResult.failure(error).getError() as? RoutingError)?.description, error.description)
        XCTAssertThrowsError(try RoutingResult.success.getError())
    }

}
