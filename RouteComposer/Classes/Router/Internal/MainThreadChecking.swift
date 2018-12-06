//
// Created by Eugene Kazaev on 2018-11-12.
//

import Foundation

protocol MainThreadChecking {

}

extension MainThreadChecking {

    func assertIfNotMainThread(functionName: String = #function, logger: Logger? = nil) {
        if !Thread.isMainThread {
            let errorMessage = "Internal inconsistency: Method \(functionName) requires to be called on the main thread."
            logger?.log(.error(errorMessage))
            assertionFailure(errorMessage)
        }
    }

}
