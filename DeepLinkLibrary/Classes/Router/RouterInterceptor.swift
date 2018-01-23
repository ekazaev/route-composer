//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation

/// Router interceptor is called before the actual deeplinking if something has to be done before eg. user should be
/// Logged in. Interceptor is asynchronous action. So it should be implemented very carefully that will guarantee that
/// no matter what result will be achieved by the end of the action it MUST call completion method. Otherwise router will
/// stay in limbo state waiting for interceptor to finish its action.
public enum InterceptorResult {

    /// Interceptor successfully finished it task and router may continue deep linking.
    case success

    /// Interceptor was not able to finish it task so router should not continue deep linking.
    case failure

}

public protocol RouterInterceptor {

    func execute(with arguments: Any?, logger: Logger?, completion: @escaping (_: InterceptorResult) -> Void)

}