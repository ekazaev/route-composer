//
// Created by Eugene Kazaev on 2018-11-12.
//

import Foundation

protocol MainThreadChecking {

}

extension MainThreadChecking {

    func assertIfNotMainThread(functionName: String = #function) {
        if !Thread.isMainThread {
            assertionFailure("Method \(functionName) requires to be called on the main thread.")
        }
    }

}
