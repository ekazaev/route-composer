//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

internal protocol AnyRouterInterceptor {

    func execute(with arguments: Any?, logger: Logger?, completion: @escaping (_: InterceptorResult) -> Void)

}

internal class RouterInterceptorBox<R: RouterInterceptor>: AnyRouterInterceptor {

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
