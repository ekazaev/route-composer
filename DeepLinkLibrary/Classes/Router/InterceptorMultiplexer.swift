//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

class InterceptorMultiplexer: RouterInterceptor {

    private let interceptors: [RouterInterceptor]

    init(_ interceptors: [RouterInterceptor]) {
        self.interceptors = interceptors
    }

    func execute(with arguments: Any?, logger: Logger?, completion: @escaping (InterceptorResult) -> Void) {
        guard self.interceptors.count > 0 else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: RouterInterceptor) {
            interceptor.execute(with: arguments, logger: logger) { result in
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