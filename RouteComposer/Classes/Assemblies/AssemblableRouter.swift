//
// Created by Eugene Kazaev on 18/06/2018.
//

import Foundation

public protocol AssemblableRouter {

    @discardableResult
    mutating func add<R: RoutingInterceptor>(_ interceptor: R) -> Self

    @discardableResult
    mutating func add<CT: ContextTask>(_ contentTask: CT) -> Self

    @discardableResult
    mutating func add<P: PostRoutingTask>(_ postTask: P) -> Self

}
