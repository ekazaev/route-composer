//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation

/// Router interceptor is called before the actual deeplinking(navigation) happens in case it's defined,
/// e.g. user should be logged in.
/// Interceptor is an asynchronous action. For router to continue working, completion of interceptor's execute method HAS to be called.
/// Otherwise router will stay in limbo state waiting for interceptor to finish its action.
public protocol AnyRouterInterceptor {

    func execute(with arguments: Any?, logger: Logger?, completion: @escaping (_: InterceptorResult) -> Void)

}

public protocol ConcreteRouterInterceptor {

    associatedtype A

    func execute(with arguments: A?, logger: Logger?, completion: @escaping (_: InterceptorResult) -> Void)

}

class RouterInterceptorBox<R: ConcreteRouterInterceptor>: AnyRouterInterceptor {

    let routerInterceptor: R

    init(_ routerInterceptor: R) {
        self.routerInterceptor = routerInterceptor
    }

    func execute(with arguments: Any?, logger: Logger?, completion: @escaping (InterceptorResult) -> Void) {
        guard let typedArguments = arguments as? R.A? else {
            logger?.log(.warning("\(String(describing:routerInterceptor)) does not accept \(String(describing: arguments)) as a parameter."))
            completion(.failure)
            return
        }
        routerInterceptor.execute(with: typedArguments, logger: logger, completion: completion)
    }
}
