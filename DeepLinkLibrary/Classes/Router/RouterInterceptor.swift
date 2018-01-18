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

    func apply(with arguments: Any?, completion: @escaping (_: InterceptorResult) -> Void)

}

public class InterceptorMultiplex: RouterInterceptor {

    private let interceptors: [RouterInterceptor]

    public init(_ interceptors: [RouterInterceptor]) {
        self.interceptors = interceptors
    }

    public func apply(with arguments: Any?, completion: @escaping (InterceptorResult) -> Void) {
        guard self.interceptors.count > 0 else {
            completion(.success)
            return
        }

        var interceptor = self.interceptors

        func runInterceptor(action: RouterInterceptor) {
            action.apply(with:arguments) { result in
                if result == .failure || interceptor.count == 0 {
                    completion(result)
                } else {
                    runInterceptor(action: interceptor.removeFirst())
                }
            }
        }

        runInterceptor(action: interceptor.removeFirst())
    }
}