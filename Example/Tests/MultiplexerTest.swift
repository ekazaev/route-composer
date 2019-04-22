//
//  MultiplexerTest.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 20/08/2018.
//  Copyright © 2018 HBC Digital. All rights reserved.
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
        try? multiplexer.prepare(with: nil as Any?)
        XCTAssertEqual(prepareCountRun, 10)
    }

    func testRoutingPrepareInterceptorThrow() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Any?) throws in
                throw RoutingError.generic(.init("Should be handled"))
            }, { (_: Any?) in

            }))
        ]

        var multiplexer = InterceptorMultiplexer(interceptors)
        XCTAssertThrowsError(try multiplexer.prepare(with: nil as Any?))
    }

    func testRoutingWrongContextTypeInterceptorThrow() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Int) throws in
                throw RoutingError.generic(.init("Should be handled"))
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
        try? multiplexer.prepare(with: nil as Any?)
        try? multiplexer.apply(on: UIViewController(), with: nil as Any?)
    }

    func testContextTaskWrongContextTypeThrow() {
        let contextTask = [
            ContextTaskBox(InlineContextTask { (_: UIViewController, _: String) throws in

            })
        ]

        let multiplexer = ContextTaskMultiplexer(contextTask)
        XCTAssertThrowsError(try multiplexer.apply(on: UIViewController(), with: nil as Any?))
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
                    completion(.failure(RoutingError.generic(.init("Count should be equal to 1"))))
                    return
                }
                completion(.continueRouting)
            }
        }

        var multiplexer = InterceptorMultiplexer([RoutingInterceptorBox(Interceptor())])
        try? multiplexer.prepare(with: nil as Any?)
        multiplexer.execute(with: nil as Any?) { (result: InterceptorResult) in
            guard case .continueRouting = result else {
                XCTAssertFalse(true)
                return
            }
            XCTAssertFalse(false)
        }
    }

    func testIsSuccessfulInterceptor() {
        let result1 = InterceptorResult.continueRouting
        XCTAssertTrue(result1.isSuccessful)
        let result2 = InterceptorResult.failure(RoutingError.generic(.init("test")))
        XCTAssertFalse(result2.isSuccessful)
    }

    func testAnyOrVoidMethods() {
        struct TestFinder<C>: Finder {
            typealias ViewController = UIViewController
            typealias Context = C

            func findViewController(with context: Context) -> ViewController? {
                return nil
            }
        }

        class TestContextTask<C>: ContextTask {
            typealias ViewController = UIViewController
            typealias Context = C
            var isPrepared = false
            var isApplied = false

            func prepare(with context: C) throws {
                isPrepared = true
            }

            func apply(on viewController: UIViewController, with context: C) throws {
                isApplied = true
            }
        }

        class TestRoutingInterceptor<C>: RoutingInterceptor {
            typealias ViewController = UIViewController
            typealias Context = C

            var isPrepared = false
            var isApplied = false

            func prepare(with context: C) throws {
                isPrepared = true
            }

            func execute(with context: C, completion: @escaping (InterceptorResult) -> Void) {
                isApplied = true
            }
        }

        struct TestPostRoutingTask<C>: PostRoutingTask {
            typealias ViewController = UIViewController
            typealias Context = C

            func execute(on viewController: UIViewController, with context: C, routingStack: [UIViewController]) {
                viewController.title = "test"
            }
        }

        XCTAssertNil(try? TestFinder<Any?>().findViewController())
        XCTAssertNil(try? TestFinder<Void>().findViewController())
        let viewController1 = UIViewController()
        TestPostRoutingTask<Any?>().execute(on: viewController1, routingStack: [])
        XCTAssertEqual(viewController1.title, "test")

        let viewController2 = UIViewController()
        TestPostRoutingTask<Void>().execute(on: viewController2, routingStack: [])
        XCTAssertEqual(viewController1.title, "test")

        var ct1 = TestContextTask<Any?>()
        try? ct1.prepare()
        try? ct1.apply(on: viewController1)
        XCTAssertTrue(ct1.isPrepared)
        XCTAssertTrue(ct1.isApplied)

        var ct2 = TestContextTask<Void>()
        try? ct2.prepare()
        try? ct2.apply(on: viewController1)
        XCTAssertTrue(ct2.isPrepared)
        XCTAssertTrue(ct2.isApplied)

        var ri1 = TestRoutingInterceptor<Any?>()
        try? ri1.prepare()
        ri1.execute(completion: { _ in })
        XCTAssertTrue(ri1.isPrepared)
        XCTAssertTrue(ri1.isApplied)

        var ri2 = TestRoutingInterceptor<Void>()
        try? ri2.prepare()
        ri2.execute(completion: { _ in })
        XCTAssertTrue(ri2.isPrepared)
        XCTAssertTrue(ri2.isApplied)
    }
}
