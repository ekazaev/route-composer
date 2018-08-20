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
    
    struct TestDestination: RoutingDestination {
        
        private(set) var finalStep: RoutingStep
        
        private(set) var context: Any?
        
    }
    
    func testRoutingInterceptorPrepare() {
        var prepareCountRun: Int = 0
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (destination: TestDestination) throws in
                prepareCountRun += 1
            }, { (destination: TestDestination) in
            
            })),
            RoutingInterceptorBox(InlineInterceptor(prepare: { (destination: TestDestination) throws in
                prepareCountRun += 9
            }, { (destination: TestDestination) in
            
            }))
        ]
        
        var multiplexer = InterceptorMultiplexer(interceptors)
        try? multiplexer.prepare(with: TestDestination(finalStep: CurrentViewControllerStep(), context: nil))
        XCTAssertEqual(prepareCountRun, 10)
    }
    
    func testRoutingInterceptorThrow() {
        let interceptors = [
            RoutingInterceptorBox(InlineInterceptor(prepare: { (destination: TestDestination) throws in
                throw RoutingError.message("Should be handled")
            }, { (destination: TestDestination) in
            
            }))
        ]
        
        var multiplexer = InterceptorMultiplexer(interceptors)
        XCTAssertThrowsError(try multiplexer.prepare(with: TestDestination(finalStep: CurrentViewControllerStep(), context: nil)))
    }
    
    func testRoutingInterceptorMutation() {
        struct Interceptor: RoutingInterceptor {
            var count = 0
            
            mutating func prepare(with destination: TestDestination) throws {
                count += 1
            }
            
            func execute(for destination: TestDestination, completion: @escaping (InterceptorResult) -> Void) {
                guard count == 1 else {
                    completion(.failure("Count should be 1"))
                    return
                }
                completion(.success)
            }
        }
        var multiplexer = InterceptorMultiplexer([RoutingInterceptorBox(Interceptor())])
        let destination = TestDestination(finalStep: CurrentViewControllerStep(), context: nil)
        try? multiplexer.prepare(with: destination)
        multiplexer.execute(for: destination) { (result: InterceptorResult) in
            guard case .success = result else {
                XCTAssertFalse(true)
                return
            }
            XCTAssertFalse(false)
        }
    }
    
}
