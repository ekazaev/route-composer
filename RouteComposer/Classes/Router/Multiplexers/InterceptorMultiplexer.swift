//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

struct InterceptorMultiplexer: AnyRoutingInterceptor, MainThreadChecking, CustomStringConvertible {

    private var interceptors: [AnyRoutingInterceptor]

    init(_ interceptors: [AnyRoutingInterceptor]) {
        self.interceptors = interceptors
    }

    mutating func prepare(with context: Any?) throws {
        interceptors = try interceptors.map({
            var interceptor = $0
            try interceptor.prepare(with: context)
            return interceptor
        })
    }

    func execute(with context: Any?, logger: Logger? = nil, completion: @escaping (InterceptorResult) -> Void) {
        guard !self.interceptors.isEmpty else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: AnyRoutingInterceptor) {
            self.assertIfNotMainThread(logger: logger)
            interceptor.execute(with: context, logger: logger) { result in
                self.assertIfNotMainThread(logger: logger)
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
