//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

class PostRoutingTaskMultiplexer: PostRoutingTask {

    private let tasks: [PostRoutingTask]

    init(_ tasks: [PostRoutingTask]) {
        self.tasks = tasks
    }

    func execute(on viewController: UIViewController, with arguments: Any?, routingStack: [UIViewController]) {
        self.tasks.forEach({ $0.execute(on: viewController, with: arguments, routingStack: routingStack) })
    }
}