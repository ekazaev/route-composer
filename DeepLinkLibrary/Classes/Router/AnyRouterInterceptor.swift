//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyRouterInterceptor {

    func execute(with context: Any?, logger: Logger?, completion: @escaping (_: InterceptorResult) -> Void)

}

class RouterInterceptorBox<R: RouterInterceptor>: AnyRouterInterceptor {

    let routerInterceptor: R

    init(_ routerInterceptor: R) {
        self.routerInterceptor = routerInterceptor
    }

    func execute(with context: Any?, logger: Logger?, completion: @escaping (InterceptorResult) -> Void) {
        guard let typedContext = context as? R.C? else {
            logger?.log(.warning("\(String(describing:routerInterceptor)) does not accept \(String(describing: context)) as a context."))
            completion(.failure)
            return
        }
        routerInterceptor.execute(with: typedContext, logger: logger, completion: completion)
    }
}
