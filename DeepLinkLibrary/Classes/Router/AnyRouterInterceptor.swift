//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non typesafe boxing wrapper for RouterInterceptor protocol
protocol AnyRouterInterceptor {

    func execute(with context: Any?, completion: @escaping (_: InterceptorResult) -> Void)

}

class RouterInterceptorBox<R: RouterInterceptor>: AnyRouterInterceptor {

    let routerInterceptor: R

    init(_ routerInterceptor: R) {
        self.routerInterceptor = routerInterceptor
    }

    func execute(with context: Any?, completion: @escaping (InterceptorResult) -> Void) {
        guard let typedContext = context as? R.Context? else {
            completion(.failure("\(String(describing: routerInterceptor)) does not accept \(String(describing: context)) as a context."))
            return
        }
        routerInterceptor.execute(with: typedContext, completion: completion)
    }
}
