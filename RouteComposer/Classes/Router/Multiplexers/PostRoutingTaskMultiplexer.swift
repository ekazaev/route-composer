//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

struct PostRoutingTaskMultiplexer: AnyPostRoutingTask, CustomStringConvertible {

    private let tasks: [AnyPostRoutingTask]

    init(_ tasks: [AnyPostRoutingTask]) {
        self.tasks = tasks
    }

    func execute(on viewController: UIViewController, for destination: Any?, routingStack: [UIViewController]) throws {
        try self.tasks.forEach({ try $0.execute(on: viewController, for: destination, routingStack: routingStack) })
    }

    var description: String {
        return String(describing: tasks)
    }

}
