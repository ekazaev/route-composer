//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyRoutingInterceptor {

    mutating func prepare(with context: Any?) throws

    func execute(with context: Any?, logger: Logger?, completion: @escaping (_: InterceptorResult) -> Void)

}

struct RoutingInterceptorBox<R: RoutingInterceptor>: AnyRoutingInterceptor, AnyPreparableEntity, CustomStringConvertible, MainThreadChecking, CompletionWatching {

    var routingInterceptor: R

    var isPrepared = false

    init(_ routingInterceptor: R) {
        self.routingInterceptor = routingInterceptor
    }

    mutating func prepare(with context: Any?) throws {
        guard let typedDestination = Any?.some(context as Any) as? R.Context else {
            throw RoutingError.typeMismatch(R.Context.self, RoutingError.Context("\(String(describing: routingInterceptor.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }

        try self.routingInterceptor.prepare(with: typedDestination)
        isPrepared = true
    }

    func execute(with context: Any?, logger: Logger? = nil, completion: @escaping (InterceptorResult) -> Void) {
        guard let typedDestination = Any?.some(context as Any) as? R.Context else {
            completion(.failure(RoutingError.typeMismatch(R.Context.self, RoutingError.Context("\(String(describing: routingInterceptor.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))))
            return
        }
        assertIfNotPrepared()
        assertIfNotMainThread(logger: logger)
        let watchDog = createWatchDog(logger: logger)
        routingInterceptor.execute(with: typedDestination) { result in
            watchDog.stop()
            self.assertIfNotMainThread(logger: logger)
            completion(result)
        }
    }

    var description: String {
        return String(describing: routingInterceptor)
    }

}
