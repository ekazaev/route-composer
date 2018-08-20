//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for RoutingInterceptor protocol
protocol AnyRoutingInterceptor {

    mutating func prepare<D: RoutingDestination>(with destination: D) throws
    
    func execute<D: RoutingDestination>(for destination: D, completion: @escaping (_: InterceptorResult) -> Void)

}

struct RoutingInterceptorBox<R: RoutingInterceptor>: AnyRoutingInterceptor, CustomStringConvertible {

    var routingInterceptor: R

    init(_ routingInterceptor: R) {
        self.routingInterceptor = routingInterceptor
    }

    mutating func prepare<D: RoutingDestination>(with destination: D) throws {
        guard let typedDestination = destination as? R.Destination else {
            throw RoutingError.message("\(String(describing: routingInterceptor)) does not accept \(String(describing: destination)) as a destination.")
        }
        
        try self.routingInterceptor.prepare(with: typedDestination)
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
