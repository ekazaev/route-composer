//
// Created by Kazaev, Eugene on 2018-12-05.
//

import Foundation

protocol CompletionWatching {

    func createWatchDog(logger: Logger?) -> WatchDog

}

extension CompletionWatching {

    func createWatchDog(logger: Logger?) -> WatchDog {
        #if targetEnvironment(simulator)
        return WatchDog.starting(repeating: {
            logger?.log(.info("The completion method of \(String(describing: self)) hasn't been called yet."))
        }, onRunningDeinit: {
            logger?.log(.warning("\(String(describing: self)) was deallocated without the completion method being called."))
        })
        #else
        return WatchDog.starting(onRunningDeinit: {
            logger?.log(.warning("\(String(describing: self)) was deallocated without the completion method being called."))
        })
        #endif
    }

}
