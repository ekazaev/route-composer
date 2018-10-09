//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for RoutingInterceptor protocol
protocol AnyRoutingInterceptor {

    mutating func prepare(with context: Any?) throws

    func execute(with context: Any?, completion: @escaping (_: InterceptorResult) -> Void)

}

struct RoutingInterceptorBox<R: RoutingInterceptor>: AnyRoutingInterceptor, CustomStringConvertible {

    var routingInterceptor: R

    init(_ routingInterceptor: R) {
        self.routingInterceptor = routingInterceptor
    }

    mutating func prepare(with context: Any?) throws {
        guard let typedDestination = Any?.some(context as Any) as? R.Context else {
            throw RoutingError.typeMismatch(R.Context.self, RoutingError.Context(debugDescription: "\(String(describing: routingInterceptor.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }

        try self.routingInterceptor.prepare(with: typedDestination)
    }

    func execute(with context: Any?, completion: @escaping (InterceptorResult) -> Void) {
        guard let typedDestination = Any?.some(context as Any) as? R.Context else {
            completion(.failure(RoutingError.typeMismatch(R.Context.self, RoutingError.Context(debugDescription: "\(String(describing: routingInterceptor.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))))
            return
        }
        routingInterceptor.execute(with: typedDestination, completion: completion)
    }

    var description: String {
        return String(describing: routingInterceptor)
    }

}
