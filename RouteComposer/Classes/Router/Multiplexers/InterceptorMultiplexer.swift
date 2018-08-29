//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

struct InterceptorMultiplexer: AnyRoutingInterceptor, CustomStringConvertible {

    private var interceptors: [AnyRoutingInterceptor]

    init(_ interceptors: [AnyRoutingInterceptor]) {
        self.interceptors = interceptors
    }

    mutating func prepare<D: RoutingDestination>(with destination: D) throws {
        interceptors = try interceptors.map({
            var interceptor = $0
            try interceptor.prepare(with: destination)
            return interceptor
        })
    }

    func execute<D: RoutingDestination>(for destination: D, completion: @escaping (InterceptorResult) -> Void) {
        guard !self.interceptors.isEmpty else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: AnyRoutingInterceptor) {
            interceptor.execute(for: destination) { result in
                if case .failure(_) = result {
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
        return String(describing: interceptors)
    }

}
