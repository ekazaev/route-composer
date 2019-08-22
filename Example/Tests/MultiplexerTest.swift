//
//  MultiplexerTest.swift
//  RouteComposer_Tests
//
//  Created by Eugene Kazaev on 20/08/2018.
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
        XCTAssertEqual(multiplexer.description, "[InlineInterceptor<Optional<Any>>(prepareBlock: Optional((Function)), " +
                "performBlock: (Function)), InlineInterceptor<Optional<Any>>(prepareBlock: Optional((Function)), " +
                "performBlock: (Function))]")
    }

    func testRoutingPrepareInterceptorPrepareThrows() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Any?) throws in
                throw RoutingError.generic(.init("Should be handled"))
            }, { (_: Any?) in

            }))
        ]

        var multiplexer = InterceptorMultiplexer(interceptors)
        XCTAssertThrowsError(try multiplexer.prepare(with: nil as Any?))
    }

    func testRoutingInterceptorPerformThrows() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Any?) throws in
            }, { (_: Any?) in
                throw RoutingError.generic(.init("Should be handled"))
            }))
        ]

        var multiplexer = InterceptorMultiplexer(interceptors)
        XCTAssertNoThrow(try multiplexer.prepare(with: nil as Any?))
        var wasInCompletion = false
        multiplexer.perform(with: nil as Any?, completion: { result in
            wasInCompletion = true
            XCTAssertFalse(result.isSuccessful)
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testRoutingInterceptorPerformNoInterceptors() {
        var multiplexer = InterceptorMultiplexer([])
        XCTAssertNoThrow(try multiplexer.prepare(with: nil as Any?))
        var wasInCompletion = false
        multiplexer.perform(with: nil as Any?, completion: { result in
            wasInCompletion = true
            XCTAssertTrue(result.isSuccessful)
        })
        XCTAssertTrue(wasInCompletion)
    }

    func testRoutingInterceptorWithWrongContextTypeThrows() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: Int) throws in
                throw RoutingError.generic(.init("Should be handled"))
            }, { (_: Int) in

            }))
        ]

        var multiplexer = InterceptorMultiplexer(interceptors)
        XCTAssertThrowsError(try multiplexer.prepare(with: "Wrong Context Type"))
        multiplexer.perform(with: "Wrong Context Type", completion: { result in
            guard case .failure = result else {
                XCTAssertFalse(true)
                return
            }
            XCTAssertFalse(false)
        })
    }

    func testContextTaskPrepare() {

        struct CustomContextTask: ContextTask {

            var prepareCallsCount = 0

            mutating func prepare(with context: Any?) throws {
                prepareCallsCount += 1
            }

            func perform(on viewController: UIViewController, with context: Any?) throws {
                XCTAssertEqual(prepareCallsCount, 1)
            }
        }

        let contextTask = [
            ContextTaskBox(CustomContextTask())
        ]

        var multiplexer = ContextTaskMultiplexer(contextTask)
        try? multiplexer.prepare(with: nil as Any?)
        try? multiplexer.perform(on: UIViewController(), with: nil as Any?)
    }

    func testContextTaskWithWrongContextTypeThrows() {
        let contextTask = [
            ContextTaskBox(InlineContextTask { (_: UIViewController, _: String) throws in

            })
        ]

        var multiplexer = ContextTaskMultiplexer(contextTask)
        XCTAssertThrowsError(try multiplexer.prepare(with: nil as Any?))
        XCTAssertThrowsError(try multiplexer.perform(on: UIViewController(), with: nil as Any?))
    }

    func testContextTaskDescription() {
        let contextTask = [
            ContextTaskBox(ContextSettingTask<ExtrasTest.ContentAcceptingViewController>())
        ]

        let multiplexer = ContextTaskMultiplexer(contextTask)
        XCTAssertEqual(multiplexer.description, "[ContextSettingTask<ContentAcceptingViewController>()]")
    }

    func testPostTaskWithWrongContextTypeThrow() {
        let postTasks = [
            PostRoutingTaskBox(InlinePostTask({ (_: UIViewController, _: Int, _: [UIViewController]) in
            }))
        ]

        let multiplexer = PostRoutingTaskMultiplexer(postTasks)
        XCTAssertThrowsError(try multiplexer.perform(on: UIViewController(), with: "Wrong Context Type", routingStack: [UIViewController()]))
    }

    func testPostTaskDescription() {
        let postTasks = [
            PostRoutingTaskBox(InlinePostTask({ (_: UIViewController, _: Int, _: [UIViewController]) in
            }))
        ]

        let multiplexer = PostRoutingTaskMultiplexer(postTasks)
        XCTAssertEqual(multiplexer.description, "[InlinePostTask<UIViewController, Int>(completion: (Function))]")
    }

    func testRoutingInterceptorMutation() {
        struct Interceptor: RoutingInterceptor {
            var count = 0

            mutating func prepare(with context: Any?) throws {
                count += 1
            }

            func perform(with context: Any?, completion: @escaping (RoutingResult) -> Void) {
                guard count == 1 else {
                    completion(.failure(RoutingError.generic(.init("Count should be equal to 1"))))
                    return
                }
                completion(.success)
            }
        }

        var multiplexer = InterceptorMultiplexer([RoutingInterceptorBox(Interceptor())])
        try? multiplexer.prepare(with: nil as Any?)
        multiplexer.perform(with: nil as Any?) { (result: RoutingResult) in
            guard case .success = result else {
                XCTAssertFalse(true)
                return
            }
            XCTAssertFalse(false)
        }
    }

    func testTasksWithAnyOrVoidContext() {
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

            func perform(on viewController: UIViewController, with context: C) throws {
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

            func perform(with context: C, completion: @escaping (RoutingResult) -> Void) {
                isApplied = true
                completion(.success)
            }
        }

        struct TestPostRoutingTask<C>: PostRoutingTask {
            typealias ViewController = UIViewController
            typealias Context = C

            func perform(on viewController: UIViewController, with context: C, routingStack: [UIViewController]) {
                viewController.title = "test"
            }
        }

        XCTAssertNil(try? TestFinder<Any?>().findViewController())
        XCTAssertNil(TestFinder<Any?>().getViewController())
        XCTAssertNil(try? TestFinder<Void>().findViewController())
        XCTAssertNil(TestFinder<Void>().getViewController())
        let viewController1 = UIViewController()
        TestPostRoutingTask<Any?>().perform(on: viewController1, routingStack: [])
        XCTAssertEqual(viewController1.title, "test")

        let viewController2 = UIViewController()
        TestPostRoutingTask<Void>().perform(on: viewController2, routingStack: [])
        XCTAssertEqual(viewController1.title, "test")

        var ct1 = TestContextTask<Any?>()
        try? ct1.prepare()
        try? ct1.perform(on: viewController1)
        XCTAssertTrue(ct1.isPrepared)
        XCTAssertTrue(ct1.isApplied)

        var ct2 = TestContextTask<Void>()
        try? ct2.prepare()
        try? ct2.perform(on: viewController1)
        XCTAssertTrue(ct2.isPrepared)
        XCTAssertTrue(ct2.isApplied)

        var ri1 = TestRoutingInterceptor<Any?>()
        try? ri1.prepare()
        ri1.perform(completion: { _ in })
        XCTAssertTrue(ri1.isPrepared)
        XCTAssertTrue(ri1.isApplied)

        var ri2 = TestRoutingInterceptor<Void>()
        try? ri2.prepare()
        ri2.perform(completion: { _ in })
        XCTAssertTrue(ri2.isPrepared)
        XCTAssertTrue(ri2.isApplied)
    }
}
