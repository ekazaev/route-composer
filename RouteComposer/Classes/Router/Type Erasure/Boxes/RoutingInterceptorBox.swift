//
// RouteComposer
// RoutingInterceptorBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

struct RoutingInterceptorBox<RI: RoutingInterceptor>: AnyRoutingInterceptor, PreparableEntity, CustomStringConvertible, MainThreadChecking {

    var routingInterceptor: RI

    var isPrepared = false

    init(_ routingInterceptor: RI) {
        self.routingInterceptor = routingInterceptor
    }

    mutating func prepare(with context: AnyContext) throws {
        let typedDestination: RI.Context = try context.value()
        try routingInterceptor.prepare(with: typedDestination)
        isPrepared = true
    }

    func perform(with context: AnyContext, completion: @escaping (RoutingResult) -> Void) {
        do {
            let typedContext: RI.Context = try context.value()
            assertIfNotPrepared()
            assertIfNotMainThread()
            routingInterceptor.perform(with: typedContext) { result in
                assertIfNotMainThread()
                completion(result)
            }
        } catch {
            completion(.failure(error))
        }

    }

    var description: String {
        String(describing: routingInterceptor)
    }

}
