//
// RouteComposer
// InterceptorMultiplexer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

struct InterceptorMultiplexer: AnyRoutingInterceptor, MainThreadChecking, CustomStringConvertible {

    private var interceptors: [AnyRoutingInterceptor]

    init(_ interceptors: [AnyRoutingInterceptor]) {
        self.interceptors = interceptors
    }

    mutating func prepare(with context: AnyContext) throws {
        interceptors = try interceptors.map {
            var interceptor = $0
            try interceptor.prepare(with: context)
            return interceptor
        }
    }

    func perform(with context: AnyContext, completion: @escaping (RoutingResult) -> Void) {
        guard !self.interceptors.isEmpty else {
            completion(.success)
            return
        }

        var interceptors = interceptors

        func runInterceptor(interceptor: AnyRoutingInterceptor) {
            assertIfNotMainThread()
            interceptor.perform(with: context) { result in
                assertIfNotMainThread()
                if case .failure = result {
                    completion(result)
                } else if interceptors.isEmpty {
                    completion(result)
                } else {
                    runInterceptor(interceptor: interceptors.removeFirst())
                }
            }
        }

        runInterceptor(interceptor: interceptors.removeFirst())
    }

    var description: String {
        String(describing: interceptors)
    }

}
