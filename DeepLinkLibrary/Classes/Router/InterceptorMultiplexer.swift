//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

class InterceptorMultiplexer: AnyRouterInterceptor, CustomStringConvertible {

    private let interceptors: [AnyRouterInterceptor]

    init(_ interceptors: [AnyRouterInterceptor]) {
        self.interceptors = interceptors
    }

    func execute(with context: Any?, completion: @escaping (InterceptorResult) -> Void) {
        guard self.interceptors.count > 0 else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: AnyRouterInterceptor) {
            interceptor.execute(with: context) { result in
                if case .failure(_) = result  {
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

    var description: String {
        return String(describing: interceptors)
    }

}