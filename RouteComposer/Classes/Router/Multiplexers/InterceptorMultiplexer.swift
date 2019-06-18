//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

struct InterceptorMultiplexer: AnyRoutingInterceptor, MainThreadChecking, CustomStringConvertible {

    private var interceptors: [AnyRoutingInterceptor]

    init(_ interceptors: [AnyRoutingInterceptor]) {
        self.interceptors = interceptors
    }

    mutating func prepare<Context>(with context: Context) throws {
        interceptors = try interceptors.map({
            var interceptor = $0
            try interceptor.prepare(with: context)
            return interceptor
        })
    }

    func execute<Context>(with context: Context, completion: @escaping (RoutingResult) -> Void) {
        guard !self.interceptors.isEmpty else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: AnyRoutingInterceptor) {
            self.assertIfNotMainThread()
            interceptor.execute(with: context) { result in
                self.assertIfNotMainThread()
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
