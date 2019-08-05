//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

struct RoutingInterceptorBox<RI: RoutingInterceptor>: AnyRoutingInterceptor, PreparableEntity, CustomStringConvertible, MainThreadChecking {

    var routingInterceptor: RI

    var isPrepared = false

    init(_ routingInterceptor: RI) {
        self.routingInterceptor = routingInterceptor
    }

    mutating func prepare<Context>(with context: Context) throws {
        guard let typedDestination = Any?.some(context as Any) as? RI.Context else {
            throw RoutingError.typeMismatch(type: type(of: context),
                    expectedType: RI.Context.self,
                    .init("\(String(describing: routingInterceptor.self)) does not accept \(String(describing: context.self)) as a context."))
        }

        try self.routingInterceptor.prepare(with: typedDestination)
        isPrepared = true
    }

    func perform<Context>(with context: Context, completion: @escaping (RoutingResult) -> Void) {
        guard let typedDestination = Any?.some(context as Any) as? RI.Context else {
            completion(.failure(RoutingError.typeMismatch(type: type(of: context),
                    expectedType: RI.Context.self,
                    .init("\(String(describing: routingInterceptor.self)) does not accept \(String(describing: context.self)) as a context."))))
            return
        }
        assertIfNotPrepared()
        assertIfNotMainThread()
        routingInterceptor.perform(with: typedDestination) { result in
            self.assertIfNotMainThread()
            completion(result)
        }
    }

    var description: String {
        return String(describing: routingInterceptor)
    }

}
