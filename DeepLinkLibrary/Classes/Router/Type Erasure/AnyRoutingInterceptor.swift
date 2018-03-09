//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non typesafe boxing wrapper for RoutingInterceptor protocol
protocol AnyRoutingInterceptor {

    func execute<D: RoutingDestination>(for destination: D, completion: @escaping (_: InterceptorResult) -> Void)

}

class RoutingInterceptorBox<R: RoutingInterceptor>: AnyRoutingInterceptor, CustomStringConvertible {

    let routingInterceptor: R

    init(_ routingInterceptor: R) {
        self.routingInterceptor = routingInterceptor
    }

    func execute<D: RoutingDestination>(for destination:D, completion: @escaping (InterceptorResult) -> Void) {
        guard let typedDestination = destination as? R.Destination else {
            completion(.failure("\(String(describing: routingInterceptor)) does not accept \(String(describing: destination)) as a destination."))
            return
        }
        routingInterceptor.execute(for: typedDestination, completion: completion)
    }

    var description: String {
        return String(describing: routingInterceptor)
    }

}
