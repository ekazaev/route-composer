//
// RouteComposer
// InterceptorMultiplexer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation

struct InterceptorMultiplexer: AnyRoutingInterceptor, MainThreadChecking, CustomStringConvertible {

    private var interceptors: [AnyRoutingInterceptor]

    init(_ interceptors: [AnyRoutingInterceptor]) {
        self.interceptors = interceptors
    }

    mutating func prepare<Context>(with context: Context) throws {
        interceptors = try interceptors.map {
            var interceptor = $0
            try interceptor.prepare(with: context)
            return interceptor
        }
    }

    func perform<Context>(with context: Context, completion: @escaping (RoutingResult) -> Void) {
        guard !self.interceptors.isEmpty else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: AnyRoutingInterceptor) {
            assertIfNotMainThread()
            interceptor.perform(with: context) { result in
                self.assertIfNotMainThread()
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

#endif
