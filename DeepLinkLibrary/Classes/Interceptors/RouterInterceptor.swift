//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation

/// Router interceptor is called before the actual deeplinking(navigation) happens in case it's defined,
/// e.g. user should be logged in.
/// Interceptor is an asynchronous action. For router to continue working, completion of interceptor's execute method HAS to be called.
/// Otherwise router will stay in limbo state waiting for interceptor to finish its action.
public protocol RouterInterceptor {

    associatedtype Context

    func execute(with context: Context?, completion: @escaping (_: InterceptorResult) -> Void)

}
