////
////  MultiplexerTest.swift
////  RouteComposer_Tests
////
////  Created by Eugene Kazaev on 20/08/2018.
////  Copyright © 2018 Gilt Groupe. All rights reserved.
////
//
//import UIKit
//import Foundation
//import XCTest
//@testable import RouteComposer
//
//class MultiplexerTest: XCTestCase {
//
//    struct TestDestination: RoutingDestination {
//
//        private(set) var finalStep: RoutingStep
//
//        private(set) var context: Any?
//
//    }
//
//    struct WrongDestination: RoutingDestination {
//
//        private(set) var finalStep: RoutingStep
//
//        private(set) var context: Any?
//
//    }
//
//    func testRoutingInterceptorPrepare() {
//        var prepareCountRun: Int = 0
//        let interceptors = [
//            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: TestDestination) throws in
//                prepareCountRun += 1
//            }, { (_: TestDestination) in
//
//            })),
//            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: TestDestination) throws in
//                prepareCountRun += 9
//            }, { (_: TestDestination) in
//
//            }))
//        ]
//
//        var multiplexer = InterceptorMultiplexer(interceptors)
//        try? multiplexer.prepare(with: TestDestination(finalStep: CurrentViewControllerStep(), context: nil))
//        XCTAssertEqual(prepareCountRun, 10)
//    }
//
//    func testRoutingPrepareInterceptorThrow() {
//        let interceptors = [
//            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: TestDestination) throws in
//                throw RoutingError.message("Should be handled")
//            }, { (_: TestDestination) in
//
//            }))
//        ]
//
//        var multiplexer = InterceptorMultiplexer(interceptors)
//        let destination = TestDestination(finalStep: CurrentViewControllerStep(), context: nil)
//        XCTAssertThrowsError(try multiplexer.prepare(with: destination))
//    }
//
//    func testRoutingWrongDestinationInterceptorThrow() {
//        let interceptors = [
//            RoutingInterceptorBox(InlineInterceptor(prepare: { (_: TestDestination) throws in
//                throw RoutingError.message("Should be handled")
//            }, { (_: TestDestination) in
//
//            }))
//        ]
//
//        let multiplexer = InterceptorMultiplexer(interceptors)
//        multiplexer.execute(for: WrongDestination(finalStep: CurrentViewControllerStep(), context: nil), completion: { result in
//            guard case .failure = result else {
//                XCTAssertFalse(true)
//                return
//            }
//            XCTAssertFalse(false)
//        })
//    }
//
//    func testContextTaskPrepare() {
//
//        struct CustomContextTask: ContextTask {
//
//            var prepareCalledCount = 0
//
//            mutating func prepare(with context: Any?) throws {
//                prepareCalledCount += 1
//            }
//
//            func apply(on viewController: UIViewController, with context: Any?) throws {
//                XCTAssertEqual(prepareCalledCount, 1)
//            }
//        }
//
//        let contextTask = [
//            ContextTaskBox(CustomContextTask())
//        ]
//
//        var multiplexer = ContextTaskMultiplexer(contextTask)
//        let destination = TestDestination(finalStep: CurrentViewControllerStep(), context: nil)
//        try? multiplexer.prepare(with: nil, for: destination)
//        try? multiplexer.apply(on: UIViewController(), with: nil, for: destination)
//    }
//
//    func testContextTaskWrongDestinationThrow() {
//        let contextTask = [
//            ContextTaskBox(InlineContextTask { (_: UIViewController, _: String) throws in
//
//            })
//        ]
//
//        let multiplexer = ContextTaskMultiplexer(contextTask)
//        XCTAssertThrowsError(try multiplexer.apply(on: UIViewController(), with: nil, for: WrongDestination(finalStep: CurrentViewControllerStep(), context: nil)))
//    }
//
//    func testPostTaskWrongDestinationThrow() {
//        let postTasks = [
//            PostRoutingTaskBox(InlinePostTask({ (_: UIViewController, _: TestDestination, _: [UIViewController]) in
//            }))
//        ]
//
//        let multiplexer = PostRoutingTaskMultiplexer(postTasks)
//        let destination = WrongDestination(finalStep: CurrentViewControllerStep(), context: nil)
//        XCTAssertThrowsError(try multiplexer.execute(on: UIViewController(), for: destination, routingStack: [UIViewController()]))
//    }
//
//    func testRoutingInterceptorMutation() {
//        struct Interceptor: RoutingInterceptor {
//            var count = 0
//
//            mutating func prepare(with destination: TestDestination) throws {
//                count += 1
//            }
//
//            func execute(for destination: TestDestination, completion: @escaping (InterceptorResult) -> Void) {
//                guard count == 1 else {
//                    completion(.failure("Count should be 1"))
//                    return
//                }
//                completion(.success)
//            }
//        }
//        var multiplexer = InterceptorMultiplexer([RoutingInterceptorBox(Interceptor())])
//        let destination = TestDestination(finalStep: CurrentViewControllerStep(), context: nil)
//        try? multiplexer.prepare(with: destination)
//        multiplexer.execute(for: destination) { (result: InterceptorResult) in
//            guard case .success = result else {
//                XCTAssertFalse(true)
//                return
//            }
//            XCTAssertFalse(false)
//        }
//    }
//
//}
