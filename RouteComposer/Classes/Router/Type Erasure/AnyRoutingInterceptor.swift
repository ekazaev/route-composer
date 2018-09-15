//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for RoutingInterceptor protocol
protocol AnyRoutingInterceptor {

    mutating func prepare(with context: Any?) throws

    func execute(for context: Any?, completion: @escaping (_: InterceptorResult) -> Void)

}

struct RoutingInterceptorBox<R: RoutingInterceptor>: AnyRoutingInterceptor, CustomStringConvertible {

    var routingInterceptor: R

    init(_ routingInterceptor: R) {
        self.routingInterceptor = routingInterceptor
    }

    mutating func prepare(with context: Any?) throws {
        guard let typedDestination = Any?.some(context as Any) as? R.Context else {
            throw RoutingError.message("\(String(describing: routingInterceptor)) does not accept \(String(describing: context)) as a destination.")
        }

        try self.routingInterceptor.prepare(with: typedDestination)
    }

    func execute(for context: Any?, completion: @escaping (InterceptorResult) -> Void) {
        guard let typedDestination = Any?.some(context as Any) as? R.Context else {
            completion(.failure("\(String(describing: routingInterceptor)) does not accept \(String(describing: context)) as a destination."))
            return
        }
        routingInterceptor.execute(for: typedDestination, completion: completion)
    }

    var description: String {
        return String(describing: routingInterceptor)
    }

}
