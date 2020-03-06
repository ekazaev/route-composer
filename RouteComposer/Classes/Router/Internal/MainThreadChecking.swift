//
// RouteComposer
// MainThreadChecking.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation

protocol MainThreadChecking {}

extension MainThreadChecking {

    func assertIfNotMainThread(functionName: String = #function, logger: Logger? = nil) {
        if !Thread.isMainThread {
            let errorMessage = "Internal inconsistency: Method \(functionName) requires to be called on the main thread."
            logger?.log(.error(errorMessage))
            assertionFailure(errorMessage)
        }
    }

}

#endif
