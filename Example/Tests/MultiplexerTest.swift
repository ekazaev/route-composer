//
//  MultiplexerTest.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 20/08/2018.
//  Copyright © 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import RouteComposer

class MultiplexerTest: XCTestCase {

    func testRoutingInterceptorPrepare() {
        var prepareCountRun: Int = 0
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Any?) throws in
                prepareCountRun += 1
            }, { (_: Any?) in

            })),
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Any?) throws in
                prepareCountRun += 9
            }, { (_: Any?) in

            }))
        ]

        var multiplexer = InterceptorMultiplexer(interceptors)
        try? multiplexer.prepare(with: nil)
        XCTAssertEqual(prepareCountRun, 10)
    }

    func testRoutingPrepareInterceptorThrow() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Any?) throws in
                throw RoutingError.generic(RoutingError.Context(debugDescription: "Should be handled"))
            }, { (_: Any?) in

            }))
        ]

        var multiplexer = InterceptorMultiplexer(interceptors)
        XCTAssertThrowsError(try multiplexer.prepare(with: nil))
    }

    func testRoutingWrongContextTypeInterceptorThrow() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Int) throws in
                throw RoutingError.generic(RoutingError.Context(debugDescription: "Should be handled"))
            }, { (_: Int) in

            }))
        ]

        let multiplexer = InterceptorMultiplexer(interceptors)
        multiplexer.execute(with: "Wrong Context Type", completion: { result in
            guard case .failure = result else {
                XCTAssertFalse(true)
                return
            }
            XCTAssertFalse(false)
        })
    }

    func testContextTaskPrepare() {

        struct CustomContextTask: ContextTask {

            var prepareCalledCount = 0

            mutating func prepare(with context: Any?) throws {
                prepareCalledCount += 1
            }

            func apply(on viewController: UIViewController, with context: Any?) throws {
                XCTAssertEqual(prepareCalledCount, 1)
            }
        }

        let contextTask = [
            ContextTaskBox(CustomContextTask())
        ]

        var multiplexer = ContextTaskMultiplexer(contextTask)
        try? multiplexer.prepare(with: nil)
        try? multiplexer.apply(on: UIViewController(), with: nil)
    }

    func testContextTaskWrongContextTypeThrow() {
        let contextTask = [
            ContextTaskBox(InlineContextTask { (_: UIViewController, _: String) throws in

            })
        ]

        let multiplexer = ContextTaskMultiplexer(contextTask)
        XCTAssertThrowsError(try multiplexer.apply(on: UIViewController(), with: nil))
    }

    func testPostTaskWrongContextTypeThrow() {
        let postTasks = [
            PostRoutingTaskBox(InlinePostTask({ (_: UIViewController, _: Int, _: [UIViewController]) in
            }))
        ]

        let multiplexer = PostRoutingTaskMultiplexer(postTasks)
        XCTAssertThrowsError(try multiplexer.execute(on: UIViewController(), with: "Wrong Context Type", routingStack: [UIViewController()]))
    }

    func testRoutingInterceptorMutation() {
        struct Interceptor: RoutingInterceptor {
            var count = 0

            mutating func prepare(with context: Any?) throws {
                count += 1
            }

            func execute(with context: Any?, completion: @escaping (InterceptorResult) -> Void) {
                guard count == 1 else {
                    completion(.failure(RoutingError.generic(RoutingError.Context(debugDescription: "Count should be equal to 1"))))
                    return
                }
                completion(.success)
            }
        }
        var multiplexer = InterceptorMultiplexer([RoutingInterceptorBox(Interceptor())])
        try? multiplexer.prepare(with: nil)
        multiplexer.execute(with: nil) { (result: InterceptorResult) in
            guard case .success = result else {
                XCTAssertFalse(true)
                return
            }
            XCTAssertFalse(false)
        }
    }

}
