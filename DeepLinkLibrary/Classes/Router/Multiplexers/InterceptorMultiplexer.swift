//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

class InterceptorMultiplexer: AnyRoutingInterceptor, CustomStringConvertible {

    private let interceptors: [AnyRoutingInterceptor]

    init(_ interceptors: [AnyRoutingInterceptor]) {
        self.interceptors = interceptors
    }

    func execute<D: RoutingDestination>(for destination: D, completion: @escaping (InterceptorResult) -> Void) {
        guard self.interceptors.count > 0 else {
            completion(.success)
            return
        }

        var interceptors = self.interceptors

        func runInterceptor(interceptor: AnyRoutingInterceptor) {
            interceptor.execute(for: destination) { result in
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