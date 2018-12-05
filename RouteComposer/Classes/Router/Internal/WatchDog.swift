//
// Created by Kazaev, Eugene on 2018-12-04.
//

import Foundation

class WatchDog {

    enum State {
        case started
        case stopped
    }

    private var timer: DispatchSourceTimer?

    private(set) var state: State = .stopped

    private let onDunningDeinitBlock: (() -> Void)?

    init(onRunningDeinit onDunningDeinitBlock: (() -> Void)? = nil) {
        self.onDunningDeinitBlock = onDunningDeinitBlock
    }

    static func starting(every interval: DispatchTimeInterval = .seconds(10),
                         repeating repeatingBlock: @escaping DispatchSourceProtocol.DispatchSourceHandler,
                         onRunningDeinit onDunningDeinitBlock: (() -> Void)? = nil) -> WatchDog {
        let watchDog = WatchDog(onRunningDeinit: onDunningDeinitBlock)
        watchDog.startRepeating(every: interval, repeatingBlock)
        return watchDog
    }

    static func starting(onRunningDeinit onDunningDeinitBlock: @escaping (() -> Void)) -> WatchDog {
        let watchDog = WatchDog(onRunningDeinit: onDunningDeinitBlock)
        watchDog.start()
        return watchDog
    }

    deinit {
        if state == .started {
            onDunningDeinitBlock?()
            stop()
        }
    }

    func start() {
        guard state == .stopped else {
            assertionFailure("Attempted to start WatchDog again.")
            return
        }
        state = .started
    }

    func startRepeating(every interval: DispatchTimeInterval = .seconds(10), _ block: @escaping DispatchSourceProtocol.DispatchSourceHandler) {
        start()

        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: interval, leeway: .seconds(1))
        timer?.setEventHandler(handler: block)
        timer?.resume()
    }

    func stop() {
        guard state == .started else {
            assertionFailure("Attempted to stop WatchDog which has not started.")
            return
        }
        timer?.cancel()
        timer = nil
        state = .stopped
    }

}
