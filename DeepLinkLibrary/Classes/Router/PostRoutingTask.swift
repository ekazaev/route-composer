//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

public protocol PostRoutingTask {

    func execute(on viewController: UIViewController, with arguments: Any?)

}

public class PostRoutingTaskMultiplexer: PostRoutingTask {

    private let tasks: [PostRoutingTask]

    public init(_ tasks: [PostRoutingTask]) {
        self.tasks = tasks
    }

    public func execute(on viewController: UIViewController, with arguments: Any?) {
        self.tasks.forEach({ $0.execute(on: viewController, with: arguments)})
    }
}