//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

class InterceptorMultiplexer: AnyRouterInterceptor {

    private let interceptors: [AnyRouterInterceptor]

    init(_ interceptors: [AnyRouterInterceptor]) {
        self.interceptors = interceptors
    }

    func execute(with context: Any?, logger: Logger?, completion: @escaping (InterceptorResult) -> Void) {
        guard self.interceptors.count > 0 else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: AnyRouterInterceptor) {
            interceptor.execute(with: context, logger: logger) { result in
                if result == .failure {
                    logger?.log(.warning("\(interceptor) interceptor has stopped routing."))
                    completion(result)
                } else if interceptors.count == 0 {
                    completion(result)
                } else {
                    runInterceptor(interceptor: interceptors.removeFirst())
                }
            }
        }

        runInterceptor(interceptor: interceptors.removeFirst())
    }
    
}